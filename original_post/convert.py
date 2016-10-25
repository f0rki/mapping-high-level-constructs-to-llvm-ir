#!/usr/bin/env python3

import os
import re
import errno


# programming by stackoverflow: http://stackoverflow.com/questions/600268/mkdir-p-functionality-in-python#600612
def mkdir_p(path):
    try:
        os.makedirs(path)
    except OSError as exc:
        if exc.errno == errno.EEXIST and os.path.isdir(path):
            pass
        else:
            raise


src_ext_map = {"LLVM": "ll", "C": "c", "C++": "cpp"}

class LineBuffer:

    def __init__(self, fileobj):
        self.file = fileobj
        self._iter = iter(self.file.readlines())
        self.buf = []
        self.num = 0
        self._iter_empty = False

    @property
    def has_next(self):
        return (not self._iter_empty) or self.buf

    def next(self):
        if self.buf:
            line = self.buf.pop()
        else:
            if self._iter_empty:
                raise StopIteration()
            try:
                line = self._iter.__next__()
            except StopIteration:
                self._iter_empty = True
                raise
        self.num += 1
        return (self.num, line)

    __next__ = next

    def put_back(self, line):
        self.num -= 1
        self.buf.append(line)

    def __iter__(self):
        return self

    def destroy(self):
        self.file.close()
        self._iter = None
        self.buf = []
        self.num = -1
        self._iter_empty = True


def space_to_dash(s):
    s = s.lower()
    return re.sub(r"\s+", "-", s)


class Converter:

    def __init__(self, infile, outdir):
        self.infile = infile
        self.outdir = outdir
        self.current_chapter = None
        self.current_section = None
        self.curof = None
        self.current_line = -1
        self.current_listing = 0

    def __enter__(self):
        self.curof = open(os.path.join(self.outdir, "README.md"), "w")
        self.summaryf = open(os.path.join(self.outdir, "SUMMARY.md"), "w")
        self.inp = LineBuffer(self.infile)
        return self

    def __exit__(self, type, value, traceback):
        self.curof.close()
        self.summaryf.close()
        self.inp.destroy()
        return False

    def convert_to_md(self):
        self.summaryf.write("# Summary\n\n")

        for i, line in self.inp:
            self.current_line = i
            if line.startswith("!"):
                s = line.split(" ")
                cmd, args = s[0], " ".join(s[1:])
                self.handle_cmd(cmd, args)
            elif line.startswith("{todo"):
                self.handle_todo(line)
            elif "!format" in line:
                self.handle_code_listing(line)
            else:
                self.process_line(line)

    def process_line(self, line):
        # TODO: regex replace
        line = re.sub(r"{c:([^}]+)}", r"`\1`", line)
        line = re.sub(r"{b:([^}]+)}", r"**\1**", line)
        line = re.sub(r"{i:([^}]+)}", r"*\1*", line)
        line = re.sub(r"{link:([^|]+)\|([^}]+)}",
                      r"[\2](\1)", line)
        line = re.sub(r"{mail:([^|]+)\|([^}]+)}",
                      r"[\2](mailto:\1)", line)
        line = line.replace("#", "-")
        self.curof.write(line)

    def handle_todo(self, line):
        self.curof.write(line)

    def switch_file(self, newfile, subdir=None):
        if subdir is None:
            fname = os.path.join(self.outdir, newfile)
        else:
            realdir = os.path.join(self.outdir, subdir)
            if not os.path.exists(realdir):
                mkdir_p(realdir)
            fname = os.path.join(realdir, newfile)
        self.curof.close()
        self.curof = open(fname, "w")

    def handle_code_listing(self, line):
        _, srcfmt = line.strip().split()
        extension = src_ext_map[srcfmt]
        realdir = os.path.join(self.outdir,
                               self.current_chapter,
                               "listings")
        if not os.path.exists(realdir):
            mkdir_p(realdir)
        sourcefname = os.path.join(realdir,
                                   "listing_{}.{}"
                                   .format(self.current_listing,
                                           extension))
        sourcef = open(sourcefname, "w")
        self.current_listing += 1

        def write(what):
            self.curof.write(what)
            sourcef.write(what)

        self.curof.write("```" + extension + "\n")
        lastwasempty = False
        while self.inp.has_next:
            i, line = self.inp.next()
            if line.strip() == "":
                lastwasempty = True
                continue
            if line[0] == "\t" and "!format" not in line:
                if lastwasempty:
                    write("\n")
                write(line[1:])
                lastwasempty = False
            else:
                break
        self.curof.write("```\n\n")
        if lastwasempty:
            self.inp.put_back("\n")

        self.inp.put_back(line)

        sourcef.close()

    def handle_cmd(self, cmd, args):
        if cmd == "!chapter":
            self.info("processing chapter", args)
            chaptername = args.strip()
            self.current_chapter = (space_to_dash(chaptername.strip())
                                    .replace("/", "+")
                                    .replace(":", ""))
            self.current_section = ""
            self.switch_file("README.md", self.current_chapter)
            self.current_listing = 0
            self.curof.write("# {}\n".format(args))

            self.summaryf.write("* [{}]({}/README.md)\n"
                                .format(chaptername,
                                        self.current_chapter))
        elif cmd == "!section":
            self.info("processing section", args, "in", self.current_chapter)
            sectionname = args.strip()
            self.current_section = (space_to_dash(sectionname)
                                    .replace("/", "+"))
            self.switch_file(self.current_section + ".md",
                             self.current_chapter)
            self.curof.write("## {}\n".format(sectionname))
            self.curof.write("\n\n")

            self.summaryf.write("   * [{}]({}/{}.md)\n"
                                .format(sectionname,
                                        self.current_chapter,
                                        self.current_section))
        elif cmd == "!subsection":
            self.curof.write("### {}\n".format(args))
        else:
            self.warn("unknown command '{}'".format(cmd))
            # self.curof.write("`{} {}`".format(cmd, args))

    def warn(self, *args):
        s = " ".join(map(lambda x: str(x).strip(), args))
        print("\x1b[93;41mWARNING\x1b[0m (line {}): {}"
              .format(self.current_line, s))

    def info(self, *args):
        s = " ".join(map(lambda x: str(x).strip(), args))
        print("info (line {}): {}".format(self.current_line, s))


if __name__ == "__main__":
    origfile = "./Mapping-High-Level-Constructs-to-LLVM-IR.page"
    with open(origfile) as f:
        with Converter(f, "..") as conv:
            conv.convert_to_md()

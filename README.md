# Mapping High Level Constructs to LLVM IR

## About
This is a gitbook dedicated to providing a description on how LLVM based
compilers map high-level language constructs into the LLVM intermediate
representation (IR).

This document targets people interested in how modern compilers work and
want to learn how high-level language constructs can be implemented.
Currently the books focuses on C and C++, but contributions about other
languages targeting LLVM are highly welcome. This document should help
to make the learning curve less steep for aspiring LLVM users.

For the sake of simplicity, we'll be working with a 32-bit target
machine so that pointers and word-sized operands are 32-bits. Also, for
the sake of readability we do not mangle (encode) names. Rather, they
are given simple, easy-to-read names that reflect their purpose. A
production compiler for any language that supports overloading would
generally need to mangle the names so as to avoid conflicts between
symbols.

## Reading the Book
Read the book online at [ReadTheDocs](https://mapping-high-level-constructs-to-llvm-ir.rtfd.io/).

## Relevant External Resources on LLVM IR
This section presents various external links of relevance to those studying LLVM IR:

* [Getting Started / Tutorials](https://llvm.org/docs/GettingStartedTutorials.html)
* [A Gentle Introduction to LLVM IR](https://mcyoung.xyz/2023/08/01/llvm-ir/)
* [Mapping Python to LLVM IR](https://blog.exaloop.io/python-llvm/)

If you have other relevant links, please open an issue or submit a pull request with the link added to the list above.

## Contributing
All contributions are welcome!

The repository is on [GitHub](https://github.com/f0rki/mapping-high-level-constructs-to-llvm-ir).

If you find an error, [file an issue](https://github.com/f0rki/mapping-high-level-constructs-to-llvm-ir/issues)
or [create a pull request](https://github.com/f0rki/mapping-high-level-constructs-to-llvm-ir/pulls).

## Building
You can build the book in one of two ways: Using Ubuntu Linux or Docker on Linux.

### Fetching the Project
1. Change to your home directory: `cd ~`
2. Clone the repository: `git clone https://github.com/f0rki/mapping-high-level-constructs-to-llvm-ir llvm-ir`
3. Enter the project directory: `cd llvm-ir`

### Setting Up Ubuntu Linux
1. Install Make and some friends (~244 MB): `sudo apt install -y build-essential`
2. Install the Python pip tool (~38 MB): `sudo apt install -y python3-pip`
3. Install Sphinx for Python (~15 MB): `sudo apt install -y python3-sphinx`
4. Install ReadTheDocs theme for Sphinx (~15 MB): `sudo apt install -y python3-sphinx-rtd-theme`

You can now build the documentation locally:

5. Build the documentation locally: `make html`.
6. You can now browse the documentation in the `_build/html` folder.

### Building using Docker
1. [Install Docker](https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository).
   DO NOT INSTALL USING THE STANDARD UBUNTU REPOSITORIES. IT WON'T WORK!
2. Create the docker image: `sudo make docker-build`.
3. Make the book: `sudo make docker-make O=html`.
4. The book can now be found in the `_build/html` folder.

## License
UNLESS OTHERWISE NOTED, THE CONTENTS OF THIS REPOSITORY/DOCUMENT ARE LICENSED
UNDER THE CREATIVE COMMONS ATTRIBUTION - SHARE ALIKE 4.0 INTERNATIONAL LICENSE

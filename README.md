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

## The Book
Read the book online [ReadTheDocs](http://mapping-high-level-constructs-to-llvm-ir.rtfd.io/).

## Contributing
The repository for this document is hosted on
`github <https://github.com/f0rki/mapping-high-level-constructs-to-llvm-ir>`__.

All contributions are welcome. If you find an error file an
`Issue <https://github.com/f0rki/mapping-high-level-constructs-to-llvm-ir/issues>`__
or fork the repository `and create a
pull-request <https://github.com/f0rki/mapping-high-level-constructs-to-llvm-ir/pulls>`__.

## Building
You can build the book in one of two ways: Using Ubuntu Linux or Docker on Linux.

### Building on Ubuntu Linux
1. Install Make and friends: `sudo apt install -y build-essential` (244 MB).
2. Install the Python pip tool: `sudo apt install -y python3-pip` (38 MB).
3. Install Sphinx for Python: `sudo apt install -y python3-sphinx` (15 MB).
4. Install ReadTheDocs theme for sphinx: `sudo apt install -y python3-sphinx-rtd-theme` (15 MB).
5. Build the documentation locally: `make html`.
6. You can now browse the documentation in the `_build/html` folder.

### Building using Docker
1. [Install Docker](https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository).
   DO NOT ATTEMPT TO INSTALL DOCKER USING THE STANDARD UBUNTU REPOSITORIES, IT WON'T WORK!
2. Create the docker image: `sudo make docker-build`.
3. Make the book: `sudo make docker-make O=html`.
4. The book can now, as with the native Ubuntu build, be found in the `_build/html` folder.

## License
UNLESS OTHERWISE NOTED, THE CONTENTS OF THIS REPOSITORY/DOCUMENT ARE LICENSED
UNDER THE CREATIVE COMMONS ATTRIBUTION - SHARE ALIKE 4.0 INTERNATIONAL LICENSE

# Mapping High Level Constructs to LLVM IR

[Click here to read the book on gitbooks.io](https://f0rki.gitbooks.io/mapping-high-level-constructs-to-llvm-ir/content/)

## About

This is a gitbook dedicated to providing a description on how LLVM based
compilers map high-level language constructs into the LLVM intermediate
representation (IR).

This document targets people interested in how modern compilers work and want
to learn how high-level language constructs can be implemented. Currently the
books focuses on C and C++, but contributions about other languages targeting
LLVM are highly welcome. This document should help to make the learning curve
less steep for aspiring LLVM users.

For the sake of simplicity, we'll be working with a 32-bit target machine so
that pointers and word-sized operands are 32-bits.
Also, for the sake of readability we do not mangle (encode) names. Rather,
they are given simple, easy-to-read names that reflect their purpose. A
production compiler for any language that supports overloading would generally
need to mangle the names so as to avoid conflicts between symbols.


## Contributing

The repository for this gitbook is hosted on [github](https://github.com/f0rki/mapping-high-level-constructs-to-llvm-ir). All contributions are welcome. If you find an
error file an [Issue](https://github.com/f0rki/mapping-high-level-constructs-to-llvm-ir/issues)
or fork the repository [and create a pull-request](https://github.com/f0rki/mapping-high-level-constructs-to-llvm-ir/pulls).


## License

UNLESS OTHERWISE NOTED, THE CONTENTS OF THIS REPOSITORY ARE LICENSED UNDER THE CREATIVE COMMONS ATTRIBUTION - SHARE ALIKE 4.0 INTERNATIONAL LICENSE

![https://creativecommons.org/licenses/by-sa/4.0/](https://i.creativecommons.org/l/by-sa/4.0/88x31.png)


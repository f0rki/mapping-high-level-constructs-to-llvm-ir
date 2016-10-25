

In this document we will take a look at how to map various classic high-level programming language constructs to LLVM IR.  The
purpose of the document is to make the learning curve less steep for aspiring LLVM users.

For the sake of simplicity, we'll be working with a 32-bit target machine so that pointers and word-sized operands are 32-bits.

Also, for the sake of readability we do not mangle (encode) names.  Rather, they are given simple, easy-to-read names that reflect
their purpose.  A production compiler for any language that supports overloading would generally need to mangle the names so as to
avoid conflicts between symbols.


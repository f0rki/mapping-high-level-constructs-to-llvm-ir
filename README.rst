Mapping High Level Constructs to LLVM IR
========================================

`Click here to read the book on
gitbooks.io <https://f0rki.gitbooks.io/mapping-high-level-constructs-to-llvm-ir/content/>`__

About
-----

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

Contributing
------------

The repository for this gitbook is hosted on
`github <https://github.com/f0rki/mapping-high-level-constructs-to-llvm-ir>`__.
All contributions are welcome. If you find an error file an
`Issue <https://github.com/f0rki/mapping-high-level-constructs-to-llvm-ir/issues>`__
or fork the repository `and create a
pull-request <https://github.com/f0rki/mapping-high-level-constructs-to-llvm-ir/pulls>`__.

License
-------

UNLESS OTHERWISE NOTED, THE CONTENTS OF THIS REPOSITORY ARE LICENSED
UNDER THE CREATIVE COMMONS ATTRIBUTION - SHARE ALIKE 4.0 INTERNATIONAL
LICENSE

.. figure:: https://i.creativecommons.org/l/by-sa/4.0/88x31.png
   :alt: https://creativecommons.org/licenses/by-sa/4.0/

   https://creativecommons.org/licenses/by-sa/4.0/


.. toctree::
   :maxdepth: 1
   :caption: Contents:

   a-quick-primer/index
   basic-constructs/index
   control-structures/index
   object-oriented-constructs/index
   exception-handling/index
   advanced-constructs/index
   interoperating-with-a-runtime-library/index
   interfacing-to-the-operating-system/index
   epilogue/index
   appendix-a-how-to-implement-a-string-type-in-llvm/index


Indices and tables
------------------

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`

## Class Inheritance Test


A class inheritance test is a question of the form:

: *Is class X identical to or derived from class Y?*

To answer that question, we can use one of two methods:

- The naive implementation where we search upwards in the chain of parents.
- The faster implementation where we search a preallocated list of parents.

The naive implementation is documented in the first two exception handling
examples as the `Object_IsA` function.




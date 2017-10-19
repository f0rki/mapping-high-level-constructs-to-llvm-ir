Class Equivalence Test
----------------------

There are two ways of doing this:

-  If you can guarantee that each class a unique vtable, you can simply
   compare the pointers to the vtable.
-  If you cannot guarantee that each class has a unique vtable (because
   different vtables may have been merged by the linker), you need to
   add a unique field to the vtable so that you can compare that
   instead.

The first variant goes roughly as follows (assuming identical strings
aren't merged by the compiler, something that they are most of the
time):

.. code-block:: cpp

    bool equal = (typeid(first) == typeid(other));

As far as I know, RTTI is simply done by adding two fields to the
\_vtable structure: ``parent`` and ``signature``. The former is a
pointer to the vtable of the parent class and the latter is the mangled
(encoded) name of the class. To see if a given class is another class,
you simply compare the ``signature`` fields. To see if a given class is
a derived class of some other class, you simply walk the chain of
``parent`` fields, while checking if you have found a matching
signature.

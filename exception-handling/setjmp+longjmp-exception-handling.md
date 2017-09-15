## Setjmp/Longjmp Exception Handling

The basic idea behind the `setjmp` and `longjmp` exception handling scheme is
that you save the CPU state whenever you encounter a `try` keyword and then do
a `longjmp` whenever you throw an exception. If there are few `try` blocks in
the program, as is typically the case, the cost of this method is not as high
as it might seem. However, often there are implicit exception handlers due to
the need to release local resources such as class instances allocated on the
stack and then the cost can become quite high.

`setjmp`/`longjmp` exception handling is often abbreviated `SjLj` for
`SetJmp`/`LongJmp`.

The sample translates into something like this:

{% codesnippet "exception-handling/listings/setjmp_longjmp.ll" %}{% endcodesnippet %}

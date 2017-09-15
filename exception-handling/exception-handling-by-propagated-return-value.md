## Exception Handling by Propagated Return Value

This method is a compiler-generated way of implicitly checking each function's
return value. Its main advantage is that it is simple - at the cost of many
mostly unproductive checks of return values. The great thing about this method
is that it readily interfaces with a host of languages and environments - it is
all a matter of returning a pointer to an exception.

The C++ example from the beginning of the section maps to the following code:

{% codesnippet "exception-handling/listings/propagated_return_values.ll" %}{% endcodesnippet %}

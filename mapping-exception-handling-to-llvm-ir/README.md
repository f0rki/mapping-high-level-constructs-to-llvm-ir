# Mapping Exception Handling to LLVM IR

Exceptions can be implemented in one of three ways:

- The simple way, by using a propagated return value.
- The bulky way, by using `setjmp` and `longjmp`.
- The efficient way, by using a zero-cost exception ABI.

Please notice that many compiler developers with respect for themselves won't accept the first method as a proper way of handling
exceptions.  However, it is unbeatable in terms of simplicity and can likely help people to understand that implementing exceptions
does not need to be very difficult.

The second method is used by some production compilers, but it has large overhead both in terms of code bloat and the cost of a
`try-catch` statement (because all CPU registers are saved using `setjmp` whenever a `try` statement is encountered).

The third method is very advanced but in return does not add any cost to execution paths where no exceptions are being thrown. This
method is the de-facto "right" way of implementing exceptions, whether you like it or not. LLVM directly supports this kind of
exception handling.

In the three sections below, we'll be using this sample and transform it:

```cpp
#include <stdio.h>
#include <stdlib.h>

class Object
{
public:
	virtual ~Object()
	{
	}
};

class Exception: public Object
{
public:
	Exception(const char *text):
		_text(text)
	{
	}

	const char *GetText(const)
	{
		return _text;
	}

private:
	const char *_text;
}

class Foo
{
public:
	int GetLength() const
	{
		return _length;
	}

	void SetLength(int value)
	{
		_length = value;
	}

private:
	int _length;
};

int Bar(bool fail)
{
	Foo foo;
	foo.SetLength(17);
	if (fail)
		throw new Exception("Exception requested by caller");
	foo.SetLength(24);
	return foo.GetLength();
}

int main(int argc, const char *argv[])
{
	int result;

	try
	{
		/* The program throws an exception if an argument is specified. */
		bool fail = (argc >= 2);

		/* Let callee decide if an exception is thrown. */
		int value = Bar(fail);

		result = EXIT_SUCCESS;
	}
	catch (Exception *that)
	{
		printf("Error: %s\n", that->GetText());
		result = EXIT_FAILURE;
	}
	catch (...)
	{
		puts("Internal error: Unhandled exception detected");
		result = EXIT_FAILURE;
	}

	return result;
}
```


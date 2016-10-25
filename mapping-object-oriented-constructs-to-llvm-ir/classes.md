## Classes


A class is nothing more than a structure with an associated set of functions that take an implicit first parameter, namely a
pointer to the structure.  Therefore, is is very trivial to map a class to LLVM IR:

```cpp
#include <stddef.h>

class Foo
{
public:
	Foo()
	{
		_length = 0;
	}

	size_t GetLength() const
	{
		return _length;
	}

	void SetLength(size_t value)
	{
		_length = value;
	}

private:
	size_t _length;
};
```

We first transform this code into two separate pieces:


- The structure definition.
- The list of methods, including the constructor.

```ll
; The structure definition for class Foo.
%Foo = type { i32 }

; The default constructor for class Foo.
define void @Foo_Create_Default(%Foo* %this) nounwind {
	%1 = getelementptr %Foo* %this, i32 0, i32 0
	store i32 0, i32* %1
	ret void
}

; The Foo::GetLength() method.
define i32 @Foo_GetLength(%Foo* %this) nounwind {
	%1 = getelementptr %Foo* %this, i32 0, i32 0
	%2 = load i32* %this
	ret i32 %2
}

; The Foo::SetLength() method.
define void @Foo_SetLength(%Foo* %this, i32 %value) nounwind {
	%1 = getelementptr %Foo* %this, i32 0, i32 0
	store i32 %value, i32* %1
	ret void
}
```

Then we make sure that the constructor (``Foo_Create_Default``) is invoked

whenever an instance of the structure is created:

```cpp
Foo foo;
```

```ll

%foo = alloca %Foo
call void @Foo_Create_Default(%Foo* %foo)
```


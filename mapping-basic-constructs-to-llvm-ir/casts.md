## Casts



There are nine different types of casts:

- Bitwise casts (type casts).
- Zero-extending casts (unsigned upcasts).
- Sign-extending casts (signed upcasts).
- Truncating casts (signed and unsigned downcasts).
- Floating-point extending casts (float upcasts).
- Floating-point truncating casts (float downcasts).
- Pointer-to-integer casts ({todo:Document pointer-to-integer casts}).
- Integer-to-pointer casts ({todo:Document integer-to-pointer casts}).
- Address-space casts (pointer casts).


### Bitwise Casts

A bitwise cast (`bitcast`) reinterprets a given bit pattern without changing any bits in the operand.  For instance, you could
make a bitcast of a pointer to byte into a pointer to some structure as follows:

```cpp
typedef struct
{
	int a;
} Foo;

extern void *malloc(size_t size);
extern void free(void *value);

void allocate()
{
	Foo *foo = (Foo *) malloc(sizeof(Foo));
	foo.a = 12;
	free(foo);
}
```

Becomes:


```ll
%Foo = type { i32 }

declare i8* @malloc(i32)
declare void @free(i8*)

define void @allocate() nounwind {
	%1 = call i8* @malloc(i32 4)
	%foo = bitcast i8* %1 to %Foo*
	%2 = getelementptr %Foo* %foo, i32 0, i32 0
	store i32 12, i32* %2
	call void @free(i8* %1)
	ret void
}
```

### Zero-Extending Casts (Unsigned Upcasts)


To upcast an unsigned value like in the example below:

```cpp
uint8 byte = 117;
uint32 word;

void main()
{
	/* The compiler automatically upcasts the byte to a word. */
	word = byte;
}
```

You use the `zext` instruction:


```ll
@byte = global i8 117
@word = global i32 0

define void @main() nounwind {
	%1 = load i8* @byte
	%2 = zext i8 %1 to i32
	store i32 %2, i32* @word
	ret void
}
```

### Sign-Extending Casts (Signed Upcasts)


To upcast a signed value, you replace the `zext` instruction with the `sext` instruction and everything else works just like in
the previous section:

```ll
@char = global i8 -17
@int  = global i32 0

define void @main() nounwind {
	%1 = load i8* @char
	%2 = sext i8 %1 to i32
	store i32 %2, i32* @int
	ret void
}
```

### Truncating Casts (Signed and Unsigned Downcasts)


Both signed and unsigned integers use the same instruction, `trunc`, to reduce the size of the number in question.  This is
because LLVM IR assumes that all signed integer values are in two's complement format for which reason `trunc` is sufficient to
handle both cases:

```ll
@int = global i32 -1
@char = global i8 0

define void @main() nounwind {
	%1 = load i32* @int
	%2 = trunc i32 %1 to i8
	store i8 %2, i8* @char
	ret void
}
```

### Floating-Point Extending Casts (Float Upcasts)


Floating points numbers can be extended using the `fpext` instruction:

```cpp
float small = 1.25;
double large;

void main()
{
	/* The compiler inserts an implicit float upcast. */
	large = small;
}
```

Becomes:


```ll
@small = global float 1.25
@large = global double 0.0

define void @main() nounwind {
	%1 = load float* @small
	%2 = fpext float %1 to double
	store double %2, double* @large
	ret void
}
```

### Floating-Point Truncating Casts (Float Downcasts)


Likewise, a floating point number can be truncated to a smaller size:

```ll
@large = global double 1.25
@small = global float 0.0

define void @main() nounwind {
	%1 = load double* @large
	%2 = fptrunc double %1 to float
	store float %2, float* @small
	ret void
}
```

### Pointer-to-Integer Casts


{todo:Document pointer-to-integer casts.}


### Integer-to-Pointer Casts

{todo:Document integer-to-pointer casts.}


### Address-Space Casts (Pointer Casts)

{todo:Find a useful example of an address-space casts, using the {c:addrspacecast} instruction, to be included here.}



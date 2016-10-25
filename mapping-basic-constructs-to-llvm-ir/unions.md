## Unions



Unions are getting more and more rare as the years have shown that they are quite dangerous to use; especially the C variant that
does not have a selector field to indicate which of the union's variants are valid. Some may still have a legacy reason to use
unions.  In fact, LLVM does not support unions at all:

```cpp
union Foo
{
	int a;
	char *b;
	double c;
};
Foo Union;
```
Becomes this when run through Clang++:


```ll
%union.Foo = type { double }
@Union = %union.Foo { 0.0 }
```
What happened here?  Where did the other union members go?  The answer is that in LLVM there are no unions; there are only structs

that can be cast into whichever type the front-end want to cast the struct into.  So to access the above union from LLVM IR, you'd
use the `bitcast` instruction to cast a pointer to the "union" into whatever pointer you'd want it to be:

```ll
%1 = bitcast %union.Foo* @Union to i32*
store i32 1, i32* %1
%2 = bitcast %union.Foo* @Union to i8**
store i8* null, i8** %2
```
This may seem strange, but the truth is that a union is nothing more than a piece of memory that is being accessed using different

implicit pointer casts.

If you want to support unions in your front-end language, you should simply allocate the total size of the union (i.e. the size of
the largest member) and then generate code to reinterpret the allocated memory as needed.

The cleanest approach might be to simply allocate a range of bytes (`i8`), possibly with alignment padding at the end, and then
cast whenever you access the structure.  That way you'd be sure you did everything properly all the time.



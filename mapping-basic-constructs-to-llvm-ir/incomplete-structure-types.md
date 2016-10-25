## Incomplete Structure Types


Incomplete types are very useful for hiding the details of what fields a given structure has.  A well-designed C interface can be
made so that no details of the structure are revealed to the client, so that the client cannot inspect or modify private members
inside the structure:

```cpp
void Bar(struct Foo *);
```
Becomes:


```ll
%Foo = type opaque
declare void @Bar(%Foo)
```

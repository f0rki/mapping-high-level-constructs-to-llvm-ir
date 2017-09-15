## Virtual Inheritance


Virtual inheritance is actually quite simple as it dictates that identical base classes are to be merged into a single occurence.
For instance, given this:

```cpp
class BaseA
{
public:
	int a;
};

class BaseB: public BaseA
{
public:
	int b;
};

class BaseC: public BaseA
{
public:
	int c;
};

class Derived:
	public virtual BaseB,
	public virtual BaseC
{
	int d;
};
```

`Derived` will only contain a single instance of `BaseA` even if its inheritance graph dictates that it should have two

instances.  The result looks something like this:

```cpp
class Derived
{
public:
	int a;
	int b;
	int c;
	int d;
};
```

So the second instance of `a` is silently ignored because it would cause multiple instances of `BaseA` to exist in `Derived`,

which clearly would cause lots of confusion and ambiguities.



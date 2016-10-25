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

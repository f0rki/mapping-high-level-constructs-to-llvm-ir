class Base
{
public:
	void SetA(int value)
	{
		_a = value;
	}

private:
	int _a;
};

class Derived: public Base
{
public:
	void SetB(int value)
	{
		SetA(value);
		_b = value;
	}

protected:
	int _b;
}

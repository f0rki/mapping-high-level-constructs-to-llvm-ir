class BaseA
{
public:
	void SetA(int value)
	{
		_a = value;
	}

private:
	int _a;
};

class BaseB: public BaseA
{
public:
	void SetB(int value)
	{
		SetA(value);
		_b = value;
	}

private:
	int _b;
};

class Derived:
	public BaseA,
	public BaseB
{
public:
	void SetC(int value)
	{
		SetB(value);
		_c = value;
	}

private:
	int _c;
};

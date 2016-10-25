class Foo
{
public:
	virtual int GetLengthTimesTwo() const
	{
		return _length * 2;
	}

	void SetLength(size_t value)
	{
		_length = value;
	}

private:
	int _length;
};

int main()
{
	Foo foo;
	foo.SetLength(4);
	return foo.GetLengthTimesTwo();
}

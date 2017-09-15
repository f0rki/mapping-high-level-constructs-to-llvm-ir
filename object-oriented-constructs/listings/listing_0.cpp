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

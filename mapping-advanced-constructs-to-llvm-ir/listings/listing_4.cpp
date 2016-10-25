#include <stdio.h>

generator int foo()
{
	yield 1;
	yield 2;
	yield 3;
}

int main()
{
	foreach (int i in foo())
		printf("Value: %d\n", i);

	return 0;
}

#include <stdio.h>

generator int foo(int start, int after)
{
	for (int index = start; index < after; index++)
	{
		if (index % 2 == 0)
			yield index + 1;
		else
			yield index - 1;
	}
}

int main(void)
{
	foreach (int i in foo(0, 5))
		printf("Value: %d\n", i);

	return 0;
}

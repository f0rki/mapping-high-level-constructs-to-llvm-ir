struct Foo
{
	int a;
	char *b;
	double c;
};

int main(void)
{
	Foo foo;
	char **bptr = &foo.b;

	Foo bar[100];
	bar[17].c = 0.0;

	return 0;
}

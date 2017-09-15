typedef struct
{
	int a;
} Foo;

extern void *malloc(size_t size);
extern void free(void *value);

void allocate()
{
	Foo *foo = (Foo *) malloc(sizeof(Foo));
	foo.a = 12;
	free(foo);
}

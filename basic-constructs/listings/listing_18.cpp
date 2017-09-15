uint8 byte = 117;
uint32 word;

void main()
{
	/* The compiler automatically upcasts the byte to a word. */
	word = byte;
}

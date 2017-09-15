CC=clang++
CXXFLAGS=-S -emit-llvm -std=c++14 -O1

%.ll: %.cpp
	$(CC) $(CXXFLAGS) $<

clean:
	-$(RM) *.bc

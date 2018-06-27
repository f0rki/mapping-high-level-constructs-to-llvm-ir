CC=clang
CXX=clang++
CXXFLAGS=-emit-llvm -std=c++14 -O0
CFLAGS=-emit-llvm -O0

%.ll: %.cpp
	$(CXX) -S $(CXXFLAGS) $<

%.ll: %.c
	$(CC) -S $(CFLAGS) $<

%.bc: %.ll
	$(CXX) -c $(CXXFLAGS) $<

clean:
	-$(RM) *.bc

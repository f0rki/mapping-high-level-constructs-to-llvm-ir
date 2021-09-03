CC=clang
CXX=clang++
CXXFLAGS=-emit-llvm -std=c++14 -O0
CFLAGS=-emit-llvm -O0

RUSTC=rustc
RUSTFLAGS=

%.ll: %.cpp
	$(CXX) -S $(CXXFLAGS) $<

%.ll: %.c
	$(CC) -S $(CFLAGS) $<

%.bc: %.ll
	$(CXX) -c $(CXXFLAGS) $<

%.ll: %.rs
	$(RUSTC) --emit-ir=llvm $<

clean:
	-$(RM) *.bc

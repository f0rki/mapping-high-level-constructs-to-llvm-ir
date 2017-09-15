CXX=clang++
CXXFLAGS=-emit-llvm -std=c++14 -O0

%.ll: %.cpp
	$(CXX) -S $(CXXFLAGS) $<

%.bc: %.ll
	$(CXX) -c $(CXXFLAGS) $<

clean:
	-$(RM) *.bc

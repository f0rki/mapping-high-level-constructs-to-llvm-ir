Foo foo;

!format LLVM
%foo = alloca %Foo
call void @Foo_Create_Default(%Foo* %foo)

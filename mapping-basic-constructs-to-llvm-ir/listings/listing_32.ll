%1 = bitcast %union.Foo* @Union to i32*
store i32 1, i32* %1
%2 = bitcast %union.Foo* @Union to i8**
store i8* null, i8** %2

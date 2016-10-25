%Base = type {
	i32         ; '_a' in class Base
}

define void @Base_SetA(%Base* %this, i32 %value) nounwind {
	%1 = getelementptr %Base* %this, i32 0, i32 0
	store i32 %value, i32* %1
	ret void
}

%Derived = type {
	i32,        ; '_a' from class Base
	i32         ; '_b' from class Derived
}

define void @Derived_SetB(%Derived* %this, i32 %value) nounwind {
	%1 = bitcast %Derived* %this to %Base*
	call void @Base_SetA(%Base* %1, i32 %value)
	%2 = getelementptr %Derived* %this, i32 0, i32 1
	store i32 %value, i32* %2
	ret void
}

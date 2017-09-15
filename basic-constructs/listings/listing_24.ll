@large = global double 1.25
@small = global float 0.0

define void @main() nounwind {
	%1 = load double* @large
	%2 = fptrunc double %1 to float
	store float %2, float* @small
	ret void
}

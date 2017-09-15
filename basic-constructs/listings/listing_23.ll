@small = global float 1.25
@large = global double 0.0

define void @main() nounwind {
	%1 = load float* @small
	%2 = fpext float %1 to double
	store double %2, double* @large
	ret void
}

#include <iostream>
#include <cmath>

void add(int n, float* x, float* y) {
	for (int i = 0; i < n; i++) {
		y[i] += x[i];
	}
}

int main(void) {
	int N = 1<<20; // 1M elements

	float* x = new float[N];
	float* y = new float[N];


	for (int i = 0; i < N; i++) {
		y[i] = 1.f;
		x[i] = 2.f;
	}
	add(N, x, y);

	float maxError = 0.f;
	for (int i = 0; i < N; i++)
		maxError = std::fmax(maxError, std::fabs(y[i] - 3.f));

	std::cout << "Max error: " << maxError << std::endl;

	delete[] x;
	delete[] y;

	return 0;
}

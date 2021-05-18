#include <iostream>
#include <cmath>

// CUDA Kernel function to add the elements of two arrays on the GPU
__global__
void add(int n, float* x, float* y) {
	int index = blockIdx.x * blockDim.x + threadIdx.x; // index of current thread within its block
	int stride = gridDim.x * blockDim.x; // number of threads in block
	for (int i = index; i < n; i += stride) {
		y[i] += x[i];
	}
}

int main(void) {
	int N = 1<<20; // 1M elements

	float *x, *y;

	// allocation unifed memory -- accessible from CPU and GPU
	cudaMallocManaged(&x, N*sizeof(float));
	cudaMallocManaged(&y, N*sizeof(float));

	for (int i = 0; i < N; i++) {
		y[i] = 1.f;
		x[i] = 2.f;
	}
	// launching add() kernel, which invokes on the GPU
	// <<<n, m>>> -- m is number of threads in a thread block, n is number of
	// thread blocks;
	int blockSize = 256;
	int numBlocks = (N + blockSize - 1) / blockSize;
	add<<<numBlocks, 256>>>(N, x, y);


	// making CPU to wait until the kernel is done
	cudaDeviceSynchronize();
	float maxError = 0.f;
	for (int i = 0; i < N; i++)
		maxError = std::fmax(maxError, std::fabs(y[i] - 3.f));

	std::cout << "Max error: " << maxError << std::endl;

	// free memory
	cudaFree(x);
	cudaFree(y);

	return 0;
}

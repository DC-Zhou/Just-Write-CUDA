#include <cstdio>

using namespace std;

__global__ void foo_kernel(int step) {
    printf("Loop: %d \n", step);
}

int main()
{
    int n_streams = 5;
    cudaStream_t *ls_streams = new cudaStream_t[n_streams];

    // create multiple streams
    for (int i = 0; i < n_streams; i++) {
        cudaStreamCreate(&ls_streams[i]);
    }

    // execute kernel in multiple streams
    for (int i = 0; i < n_streams; i++) {
        foo_kernel<<<1, 1, 0, ls_streams[i]>>>(i);
    }

    // synchronize
    cudaDeviceSynchronize();

    // terminates all the created CUDA streams
    for(int i = 0; i < n_streams; i++) {
        cudaStreamDestroy(ls_streams[i]);
    }

    delete [] ls_streams;

    return 0;
}
#include <fftw3.h>
#include <stdio.h>

int main() {
    int N = 10;
    float in[N], out[N];
    fftwf_plan p;

    // Initialize input data
    for (int i = 0; i < N; i++) {
        in[i] = i;
    }

    // Create FFT plan
    p = fftwf_plan_dft_r2c_1d(N, in, (fftwf_complex*)out, FFTW_ESTIMATE);

    // Execute FFT
    fftwf_execute(p);

    // Destroy the plan
    fftwf_destroy_plan(p);

    return 0;
}


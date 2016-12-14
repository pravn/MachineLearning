SET(CMAKE_VERBOSE_MAKEFILE TRUE)
CUDA_ADD_EXECUTABLE(sampler gmm.cu sampler_functions.cu sampler.cu utils.cu)
CUDA_ADD_EXECUTABLE(kmeans gmm.cu sampler_functions.cu kmeans_functions.cu kmeans.cu utils.cu)


CUDA_PATH = /opt/cuda
OPENCL_SDK_PATH = /usr/local/OpenCL-SDK
OPTIX_SDK_PATH = /usr/local/OptiX_SDK/NVIDIA-OptiX-SDK-7.2.0-linux64-x86_64

EXEC = main.out

SRCS := $(wildcard src/*.cpp)
OBJS := $(notdir $(SRCS:%.cpp=%.o))

CUDA_SRCS := $(wildcard src/kernels/*.cu)
CUDA_OBJS := $(notdir $(CUDA_SRCS:%.cu=%.o))

CFLAGS =-I$(OPENCL_SDK_PATH)/include/api -I$(CUDA_PATH)/include -I$(OPTIX_SDK_PATH)/include
LDFLAGS =-L$(OPENCL_SDK_PATH)/build -L$(CUDA_PATH)/lib64 -L$(OPTIX_SDK_PATH)/SDK/build/lib -lOpenCL -lcuda -lcudart -lsutil_7_sdk -ldl

GPU_C =75
NVCCFLAGS =-gencode arch=compute_$(GPU_C),code=sm_$(GPU_C)

$EXEC: $(CUDA_OBJS) $(OBJS)
	g++ $(CFLAGS) -o bin/$(EXEC) build/*.o $(LDFLAGS)

%.o: src/%.cpp
	g++ $(CFLAGS) -c $^ -o build/$@

%.o: src/kernels/%.cu
	$(CUDA_PATH)/bin/nvcc $(CFLAGS) $(NVCCFLAGS) -c $^ -o build/$@
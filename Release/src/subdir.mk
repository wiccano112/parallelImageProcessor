################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CPP_SRCS += \
../src/Image.cpp \
../src/ProcessNode.cpp 

CU_SRCS += \
../src/parallelImageProcessor.cu 

CU_DEPS += \
./src/parallelImageProcessor.d 

OBJS += \
./src/Image.o \
./src/ProcessNode.o \
./src/parallelImageProcessor.o 

CPP_DEPS += \
./src/Image.d \
./src/ProcessNode.d 


# Each subdirectory must supply rules for building sources it contributes
src/%.o: ../src/%.cpp
	@echo 'Building file: $<'
	@echo 'Invoking: NVCC Compiler'
	nvcc -I"/home/perro/Dropbox/DEVenviroment/cuda project/parallelImageProcessor/src" -I"/home/perro/Dropbox/DEVenviroment/cuda project/parallelImageProcessor/src/lib" -O3 -gencode arch=compute_30,code=sm_30 -odir "src" -M -o "$(@:%.o=%.d)" "$<"
	nvcc -I"/home/perro/Dropbox/DEVenviroment/cuda project/parallelImageProcessor/src" -I"/home/perro/Dropbox/DEVenviroment/cuda project/parallelImageProcessor/src/lib" -O3 --compile  -x c++ -o  "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

src/%.o: ../src/%.cu
	@echo 'Building file: $<'
	@echo 'Invoking: NVCC Compiler'
	nvcc -I"/home/perro/Dropbox/DEVenviroment/cuda project/parallelImageProcessor/src" -I"/home/perro/Dropbox/DEVenviroment/cuda project/parallelImageProcessor/src/lib" -O3 -gencode arch=compute_30,code=sm_30 -odir "src" -M -o "$(@:%.o=%.d)" "$<"
	nvcc --compile -I"/home/perro/Dropbox/DEVenviroment/cuda project/parallelImageProcessor/src" -I"/home/perro/Dropbox/DEVenviroment/cuda project/parallelImageProcessor/src/lib" -O3 -gencode arch=compute_30,code=compute_30 -gencode arch=compute_30,code=sm_30  -x cu -o  "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '



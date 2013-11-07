/*
 * cudaSources.cuh
 *
 *  Created on: 03/11/2013
 *      Author: perro
 */

#ifndef CUDASOURCES_CUH_
#define CUDASOURCES_CUH_

__global__ void d_processGreyTransformation(int* d_originMap,
		int* d_convertedMap) {
	// Cada tarea tiene un ID numérico basada en su posición en el bloque.

	int convertedIdx = blockIdx.x * blockDim.x + threadIdx.x;
	int originalIdx = convertedIdx * 3;

	// Cada tarea trabaja sobre una porción de los datos
	d_convertedMap[convertedIdx] = (int) (d_originMap[originalIdx]
			+ d_originMap[originalIdx + 1] + d_originMap[originalIdx + 2]) / 3;
	// Y no hay bucle! Hay una tarea por posición: cada tarea trabaja sólo sobre una posición!
}

void cudaConvertToGreyMap(int* originMap, int* convertedMap,
		int convertedMapSize) {
	// La GPU trabaja sobre distinta RAM: reservamos memoria y copiamos allí los datos.
	// El prefijo d_ nos ayuda a diferenciar los datos que están en el device (la GPU)
	int *d_originMap;
	int *d_convertedMap;

	// cudaMalloc reserva la memoria y asigna el puntero al valor correcto
	cudaMalloc((void**) &d_originMap, sizeof(int) * convertedMapSize * 3);
	cudaMalloc((void**) &d_convertedMap, sizeof(int) * convertedMapSize);

	// cudaMemcpy copia los datos desde la RAM normal a la de la GPU
	// el primer argumento es la zona de memoria de destino
	// el segundo argumento es la zona de memoria de origen
	// el tercer argumento es la dirección en la que circulan los datos
	cudaMemcpy(d_originMap, originMap, sizeof(int) * convertedMapSize * 3,
			cudaMemcpyHostToDevice);

	// Esta llamada invoca al kernel, que se ejecuta en la GPU a la vez en múltiples
	// tareas organizadas en bloques.
	int blockSize = 256;
	int numBlocks = convertedMapSize / blockSize;
	d_processGreyTransformation<<<blockSize, numBlocks>>>(d_originMap,
			d_convertedMap);

	// cudaMemcpy espera a que todos los kernels se hayan terminado de ejecutar
	// y copia de vuelta los datos procesados. Ahora la dirección de los datos
	// ha cambiado.
	cudaMemcpy(convertedMap, d_convertedMap, sizeof(int) * convertedMapSize,
			cudaMemcpyDeviceToHost);

	// Liberamos la memoria de la gráfica
	cudaFree(d_originMap);
	cudaFree(d_convertedMap);
}

__device__ int d_matrixOperator(int * d_greyMap, int * d_mask, int a, int b, int c, int d, int idx, int idy, int factor) {
	int convertedPixel = 0;
	for (int i = a; i <= b; i++) {
		for (int j = c; j <= d; j++) {
			int x = idx + i - 1;
			int y = idy + j - 1;
			convertedPixel = convertedPixel
					+ (d_greyMap[(x) + (x) * (y)] * d_mask[i + i * j]);
		}
	}
	convertedPixel = convertedPixel / factor;
	
	//normalizing
	if (convertedPixel > 255) {
		convertedPixel = 255;
	}
	if (convertedPixel < 0) {
		convertedPixel = 0;
	}

	return convertedPixel;
}

__global__ void d_processConvolution(int* d_greyMap, int *d_mask,
		int *d_convertedMap, int factor, int row, int column) {
	int idx = blockIdx.x * blockDim.x + threadIdx.x;
	int idy = blockIdx.y * blockDim.y + threadIdx.y;
	int convertedPixel = 0;
	int a;
	int b;
	int c;
	int d;

	if (idx == 0) {
		if (idy == 0) {
			a=1;
			b=2;
			c=1;
			d=2;
			convertedPixel = d_matrixOperator(d_greyMap, d_mask, a, b, c , d, idx, idy, factor);
		} else if (idy == (column - 1)) {
			a=1;
			b=2;
			c=0;
			d=1;
			convertedPixel = d_matrixOperator(d_greyMap, d_mask, a, b, c , d, idx, idy, factor);
		} else {
			a=1;
			b=2;
			c=0;
			d=2;
			convertedPixel = d_matrixOperator(d_greyMap, d_mask, a, b, c , d, idx, idy, factor);
		}
	} else if (idx == (row - 1)) {
		if (idy == 0) {
			a=0;
			b=1;
			c=1;
			d=2;
			convertedPixel = d_matrixOperator(d_greyMap, d_mask, a, b, c , d, idx, idy, factor);
		} else if (idy == (column - 1)) {
			a=0;
			b=1;
			c=0;
			d=1;
			convertedPixel = d_matrixOperator(d_greyMap, d_mask, a, b, c , d, idx, idy, factor);
		} else {
			a=0;
			b=1;
			c=0;
			d=2;
			convertedPixel = d_matrixOperator(d_greyMap, d_mask, a, b, c , d, idx, idy, factor);
		}
	} else {
		if (idy == 0) {
			a=0;
			b=2;
			c=1;
			d=2;
			convertedPixel = d_matrixOperator(d_greyMap, d_mask, a, b, c , d, idx, idy, factor);
		} else if (idy == (column - 1)) {
			a=0;
			b=2;
			c=0;
			d=1;
			convertedPixel = d_matrixOperator(d_greyMap, d_mask, a, b, c , d, idx, idy, factor);
		} else {
			a=0;
			b=2;
			c=0;
			d=2;
			convertedPixel = d_matrixOperator(d_greyMap, d_mask, a, b, c , d, idx, idy, factor);
		}
	}
	d_convertedMap[idx + idx * idy] = convertedPixel;
}

//TODO complete cuda call
void cudaConvolution(int* greyMap, int *convertedMap, int* mask,
		int row, int column, int factor) {
	// La GPU trabaja sobre distinta RAM: reservamos memoria y copiamos allí los datos.
	// El prefijo d_ nos ayuda a diferenciar los datos que están en el device (la GPU)
	int* d_greyMap;
	int* d_convertedMap;
	int* d_mask;

	// cudaMalloc reserva la memoria y asigna el puntero al valor correcto
	cudaMalloc((void**) &d_greyMap, sizeof(int) * (row * column));
	cudaMalloc((void**) &d_convertedMap, sizeof(int) * (row * column));
	cudaMalloc((void**) &d_mask, sizeof(int) * 9);

	// cudaMemcpy copia los datos desde la RAM normal a la de la GPU
	// el primer argumento es la zona de memoria de destino
	// el segundo argumento es la zona de memoria de origen
	// el tercer argumento es la dirección en la que circulan los datos
	cudaMemcpy(d_greyMap, greyMap, sizeof(int) * (row * column),
			cudaMemcpyHostToDevice);
	cudaMemcpy(d_mask, mask, sizeof(int) * 9,
				cudaMemcpyHostToDevice);

	// Esta llamada invoca al kernel, que se ejecuta en la GPU a la vez en múltiples
	// tareas organizadas en bloques.
	dim3 threadsPerBlock(256, 256);
 	dim3 numBlocks(row / threadsPerBlock.x, column / threadsPerBlock.y);

	d_processConvolution<<<threadsPerBlock, numBlocks>>>(d_greyMap, d_mask,
		d_convertedMap, factor, row, column);

	// cudaMemcpy espera a que todos los kernels se hayan terminado de ejecutar
	// y copia de vuelta los datos procesados. Ahora la dirección de los datos
	// ha cambiado.
	cudaMemcpy(convertedMap, d_convertedMap, sizeof(int) * row * column,
			cudaMemcpyDeviceToHost);

	// Liberamos la memoria de la gráfica
	cudaFree (d_greyMap);
	cudaFree(d_mask);
	cudaFree(d_convertedMap);
}
#endif /* CUDASOURCES_CUH_ */

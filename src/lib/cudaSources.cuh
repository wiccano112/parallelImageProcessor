/*
 * cudaSources.cuh
 *
 *  Created on: 03/11/2013
 *      Author: perro
 */

#ifndef CUDASOURCES_CUH_
#define CUDASOURCES_CUH_

__global__ void d_processGreyTransformation(int* d_originMap,
		int* d_convertedMap, int sizeMap) {
	// Cada tarea tiene un ID numérico basada en su posición en el bloque.

	int convertedIdx = blockIdx.x * blockDim.x + threadIdx.x;
	int originalIdx = convertedIdx * 3;
	if (convertedIdx < sizeMap) {
		// Cada tarea trabaja sobre una porción de los datos
		d_convertedMap[convertedIdx] = (int) (d_originMap[originalIdx]
				+ d_originMap[originalIdx + 1] + d_originMap[originalIdx + 2])
				/ 3;
	}
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
	int blockSize = (int) convertedMapSize / 900;
	int numBlocks = (int) (convertedMapSize / blockSize) + 1;
	d_processGreyTransformation<<<blockSize, numBlocks>>>(d_originMap,
			d_convertedMap, convertedMapSize);

	// cudaMemcpy espera a que todos los kernels se hayan terminado de ejecutar
	// y copia de vuelta los datos procesados. Ahora la dirección de los datos
	// ha cambiado.
	cudaMemcpy(convertedMap, d_convertedMap, sizeof(int) * convertedMapSize,
			cudaMemcpyDeviceToHost);

	// Liberamos la memoria de la gráfica
	cudaFree(d_originMap);
	cudaFree(d_convertedMap);
}

__device__ int d_matrixOperator(int *d_greyMap, int *d_mask, int a, int b,
		int c, int d, int idx, int idy, int factor, int row) {
	int convertedPixel = 0;

	for (int i = a; i <= b; i++) {
		for (int j = c; j <= d; j++) {
			int x = idx + i - 1;
			int y = idy + j - 1;
			convertedPixel = convertedPixel
					+ (d_greyMap[x + row * y] * d_mask[i + 3 * j]);
		}
	}
	convertedPixel = (int) convertedPixel / factor;

	//normalizing
	if (convertedPixel > 255) {
		convertedPixel = 255;
	}
	if (convertedPixel < 0) {
		convertedPixel = 0;
	}

	return convertedPixel;
}

__global__ void d_processConvolution(int *d_greyMap, int *d_mask,
		int *d_convertedMap, int factor, int row, int column) {
	int idx = blockIdx.x * blockDim.x + threadIdx.x;
	int idy = blockIdx.y * blockDim.y + threadIdx.y;
	int convertedPixel = 0;
	int a;
	int b;
	int c;
	int d;
	if (idx < row && idy < column) {
		if (idx == 0) {
			if (idy == 0) {
				a = 1;
				b = 2;
				c = 1;
				d = 2;
				convertedPixel = d_matrixOperator(d_greyMap, d_mask, a, b, c, d,
						idx, idy, factor, row);
			} else if (idy == (column - 1)) {
				a = 1;
				b = 2;
				c = 0;
				d = 1;
				convertedPixel = d_matrixOperator(d_greyMap, d_mask, a, b, c, d,
						idx, idy, factor, row);
			} else {
				a = 1;
				b = 2;
				c = 0;
				d = 2;
				convertedPixel = d_matrixOperator(d_greyMap, d_mask, a, b, c, d,
						idx, idy, factor, row);
			}
		} else if (idx == (row - 1)) {
			if (idy == 0) {
				a = 0;
				b = 1;
				c = 1;
				d = 2;
				convertedPixel = d_matrixOperator(d_greyMap, d_mask, a, b, c, d,
						idx, idy, factor, row);
			} else if (idy == (column - 1)) {
				a = 0;
				b = 1;
				c = 0;
				d = 1;
				convertedPixel = d_matrixOperator(d_greyMap, d_mask, a, b, c, d,
						idx, idy, factor, row);
			} else {
				a = 0;
				b = 1;
				c = 0;
				d = 2;
				convertedPixel = d_matrixOperator(d_greyMap, d_mask, a, b, c, d,
						idx, idy, factor, row);
			}
		} else {
			if (idy == 0) {
				a = 0;
				b = 2;
				c = 1;
				d = 2;
				convertedPixel = d_matrixOperator(d_greyMap, d_mask, a, b, c, d,
						idx, idy, factor, row);
			} else if (idy == (column - 1)) {
				a = 0;
				b = 2;
				c = 0;
				d = 1;
				convertedPixel = d_matrixOperator(d_greyMap, d_mask, a, b, c, d,
						idx, idy, factor, row);
			} else {
				a = 0;
				b = 2;
				c = 0;
				d = 2;
				convertedPixel = d_matrixOperator(d_greyMap, d_mask, a, b, c, d,
						idx, idy, factor, row);
			}
		}
		d_convertedMap[idx + idy * row] = convertedPixel;
	}
}

void cudaConvolution(int *greyMap, int *convertedMap, int* mask, int row,
		int column, int factor) {

	int* d_greyMap;
	int* d_convertedMap;
	int* d_mask;

	cudaMalloc((void**) &d_greyMap, sizeof(int) * (row * column));
	cudaMalloc((void**) &d_convertedMap, sizeof(int) * (row * column));
	cudaMalloc((void**) &d_mask, sizeof(int) * 9);

	cudaMemcpy(d_greyMap, greyMap, sizeof(int) * (row * column),
			cudaMemcpyHostToDevice);
	cudaMemcpy(d_mask, mask, sizeof(int) * 9, cudaMemcpyHostToDevice);

	dim3 threadsPerBlock(256, 256);
	dim3 numBlocks((row / threadsPerBlock.x) + 1,
			(column / threadsPerBlock.y) + 1);
	d_processConvolution<<<threadsPerBlock, numBlocks>>>(d_greyMap, d_mask,
			d_convertedMap, factor, row, column);

	cudaMemcpy(convertedMap, d_convertedMap, sizeof(int) * row * column,
			cudaMemcpyDeviceToHost);

	cudaFree(d_greyMap);
	cudaFree(d_mask);
	cudaFree(d_convertedMap);
}

__global__ void d_processSumArrays(int *d_arrayA, int *d_arrayB, int *d_arrayC,
		int mapSize) {
	int idx = blockIdx.x * blockDim.x + threadIdx.x;
	if (idx < mapSize) {
		d_arrayC[idx] = d_arrayA[idx] + d_arrayB[idx];
		if (d_arrayC[idx] > 255) {
			d_arrayC[idx] = 255;
		}
	}
}

void cudaSobelFilter(int *greyMap, int *convertedMap, int row, int column,
		int factor) {

	int *d_horizontalGreyMap;
	int *d_verticalGreyMap;
	int *d_convertedMap;

	int *horizontalEdgesMap;
	int *verticalEdgesMap;
	int *mask;
	horizontalEdgesMap = new int[row * column];
	verticalEdgesMap = new int[row * column];
	mask = new int[9];

	//deteccion de bordes horizontal
	horizontalEdgesMask(mask);
	cudaConvolution(greyMap, horizontalEdgesMap, mask, row, column, factor);

	//deteccion de bordes vertical
	verticalEdgesMask(mask);
	cudaConvolution(greyMap, verticalEdgesMap, mask, row, column, factor);

	cudaMalloc((void**) &d_horizontalGreyMap, sizeof(int) * (row * column));
	cudaMalloc((void**) &d_verticalGreyMap, sizeof(int) * (row * column));
	cudaMalloc((void**) &d_convertedMap, sizeof(int) * (row * column));

	cudaMemcpy(d_horizontalGreyMap, horizontalEdgesMap,
			sizeof(int) * (row * column), cudaMemcpyHostToDevice);
	cudaMemcpy(d_verticalGreyMap, verticalEdgesMap,
			sizeof(int) * (row * column), cudaMemcpyHostToDevice);

	int blockSize = (int) row * column / 900;
	int numBlocks = (int) (row * column / blockSize) + 1;
	d_processSumArrays<<<blockSize, numBlocks>>>(d_horizontalGreyMap,
			d_verticalGreyMap, d_convertedMap, row * column);

	cudaMemcpy(convertedMap, d_convertedMap, sizeof(int) * row * column,
			cudaMemcpyDeviceToHost);

	// Liberamos la memoria de la gráfica
	cudaFree(d_horizontalGreyMap);
	cudaFree(d_verticalGreyMap);
	cudaFree(d_convertedMap);
}
#endif /* CUDASOURCES_CUH_ */

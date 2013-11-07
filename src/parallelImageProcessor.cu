/**
 * Copyright 1993-2012 NVIDIA Corporation.  All rights reserved.
 *
 * Please refer to the NVIDIA end user license agreement (EULA) associated
 * with this source code for terms and conditions that govern your use of
 * this software. Any use, reproduction, disclosure, or distribution of
 * this software and related documentation outside the terms of the EULA
 * is strictly prohibited.
 */
#include <iostream>
#include <cstdio>
#include <cstdlib>
#include <fstream>
#include <cstring>
#include <Util.cuh>
#include <Image.h>
#include <cuda.h>
#include <cudaSources.cuh>
using namespace std;

int main(int argc, char **argv) {
	char tamano[20];
	int maximo = 0;
	int posicion = 0;
	int f = 0;
	int c = 0;
	int *map;
	int *greyMap;
	int *filterMap;
	int *convolutionMask;

	//cudaTest();
	cout << "Hola Mundo" << endl;

	if (argc <= 1) {
		cout << "no ingresaste archivos por linea de comandos" << endl;
		return 0;
	}

	posicion = filePreProcess(argv[1], tamano, maximo);
	//cout << "RPM " << posicion << endl;
	f = getLengthFromString(tamano);
	c = getWidthFromString(tamano);
	map = new int[f * c * 3];
	greyMap = new int[f * c];
	filterMap = new int[f * c];

	convolutionMask = new int[9];
	convolutionMask[0] = 1;
	convolutionMask[1] = 1;
	convolutionMask[2] = 1;
	convolutionMask[3] = 1;
	convolutionMask[4] = 1;
	convolutionMask[5] = 1;
	convolutionMask[6] = 1;
	convolutionMask[7] = 1;
	convolutionMask[8] = 1;

	bitMapBuilder(posicion, argv[1], f, c, map, 3);
	Image imagen("P3", 255, f, c, map);
	imagen.convertToGrey();
	greyMap = imagen.getBitMap();
	//cudaConvertToGreyMap(map, greyMap, (f * c));

	cudaConvolution(greyMap, filterMap, convolutionMask, f, c, 9);
	cudaError_t err;
	err = cudaDeviceSynchronize();
	cout << cudaGetErrorString(err)<< endl;

	for (int i = 0; i < f * c; i++) {
			cout << convolutionMask[i] << endl;
		}
	//

	//imagen.printImagetoConsole();

	//cout << "RPM alto" << f << " ancho " << c << endl;

	return 0;
}

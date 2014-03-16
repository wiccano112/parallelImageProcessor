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
#include <Util.h>
#include <Image.h>
#include <cuda.h>
#include <cudaSources.cuh>
#include <filterApplication.h>

using namespace std;

void testCode(int * v) {
	for(int i=0;i<9;i++){
		cout<<v[i]<< " ";
	}
}
void testCodeStaticSobel(Image image) {
	int f = image.getLength();
	int c = image.getWidth();

	int * grayMap = new int[f * c];
	int * cGrayMap1 = new int[f * c];
	int * cGrayMap2 = new int[f * c];
	int * conc = new int[f * c];
	int * mask = new int[9];

	horizontalEdgesMask(mask);
	cudaConvertToGreyMap(image.getBitMap(), grayMap, image.getBipMapLength());
	staticSobel(grayMap, mask, cGrayMap1, 1, f, c);
	verticalEdgesMask(mask);
	staticSobel(grayMap, mask, cGrayMap2, 1, f, c);
	sumMatrix(cGrayMap1, cGrayMap2, conc, f, c);
}

void testCodeParalellSobel(Image image) {
	int f = image.getLength();
	int c = image.getWidth();

	int * grayMap = new int[f * c];
	int * cGrayMap1 = new int[f * c];
	int * cGrayMap2 = new int[f * c];
	int * conc = new int[f * c];
	int * mask = new int[9];

	horizontalEdgesMask(mask);
	cudaConvertToGreyMap(image.getBitMap(), grayMap, image.getBipMapLength());
	cudaSobelFilter(grayMap, conc, f, c, 1);
}

int main(int argc, char **argv) {
	char tamano[20];
	int maximo = 0;
	int posicion = 0;
	int f = 0;
	int c = 0;
	int *map;
	int *convolutionKernel;
	int factor = 1;
	vector<ProcessNode> nodes;

	if (argc <= 1) {
		cout << "no ingresaste archivos por linea de comandos" << endl;
		return 0;
	}
	if (argv[2]) {
		factor = atoi(argv[2]);
	} else {
		cout << "sin factor " << endl << endl;
	}

	posicion = filePreProcess(argv[1], tamano, maximo);
	c = getLengthFromString(tamano);
	f = getWidthFromString(tamano);
	map = new int[f * c * 3];
	convolutionKernel = new int[9];

	bitMapBuilder(posicion, argv[1], f, c, map, 3);
	readConvolutionKernel(convolutionKernel);
	Image imagen("P3", 255, f, c, map);

	if (argv[3] && strcmp(argv[3], "debug") == 0) {
		if (strcmp(argv[4], "s") == 0) {
			testCodeStaticSobel(imagen);
		} else if (strcmp(argv[4], "p") == 0) {
			testCodeParalellSobel(imagen);
		} else {
			cout << "test code " << endl;
			testCode(convolutionKernel);
		}
		return 0;
	}

	if (setEmptyPipeline(&nodes, imagen)) {
		pipelineIterator(&nodes, imagen, factor);
	} else {
		cout << "No se pudo instanciar un pipeline vacio" << endl;
		return 0;
	}
	int size = 0;
	size = nodes.size() - 1;
	writeGpmImage(nodes[size].getOutputImage().getBitMap(), f, c, maximo);
	cudaError_t err;
	err = cudaDeviceSynchronize();
	cout << cudaGetErrorString(err) << endl;
	return 0;

}

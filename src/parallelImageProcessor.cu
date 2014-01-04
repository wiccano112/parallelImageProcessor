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

void testCode(vector<ProcessNode> *nodes, Image image) {

}

int main(int argc, char **argv) {
	char tamano[20];
	int maximo = 0;
	int posicion = 0;
	int f = 0;
	int c = 0;
	int *map;
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

	bitMapBuilder(posicion, argv[1], f, c, map, 3);
	Image imagen("P3", 255, f, c, map);

	if (setEmptyPipeline(&nodes, imagen)) {
		pipelineIterator(&nodes, imagen, factor);
	} else {
		cout << "todo mal" << endl;
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

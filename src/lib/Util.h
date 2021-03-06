/*
 * Util.cu
 *
 *  Created on: 31/10/2013
 *      Author: perro
 */

#ifndef UTIL_H_
#define UTIL_H_

#define MIN_OPTION 1
#define MAX_OPTION 7

#include <ProcessNode.h>
#include <vector>
#include <cstdio>
#include <sys/time.h>
#include <iostream>

using namespace std;

int filePreProcess(char * arg, char tamano[20], int &maximo) {

	char cadena[300];
	cadena[0] = '\0';
	bool leer = false;
	int salida = 0;

	fstream entrada;
	entrada.open(arg, fstream::in);

	while (!entrada.eof()) {

		entrada.getline(cadena, 300);
		if (strcmp(cadena, "P3") == 0) {
			leer = true;
		}
		if (leer) {
			if (cadena[0] == '#') {
				entrada.seekg((int) entrada.tellg(), entrada.beg);
				entrada.getline(cadena, 300);
				strcpy(tamano, cadena);

				entrada.seekg((int) entrada.tellg(), entrada.beg);
				entrada.getline(cadena, 300);
				maximo = atoi(cadena);
				break;
			}
		} else {
			cout << "El formato de archivo es incorrecto" << endl;
			break;
		}
	}
	salida = entrada.tellg();
	entrada.close();
	return salida;
}

void bitMapBuilder(int pos, char * arg, int a, int b, int *m, int n) {

	char cadena[300];
	cadena[0] = '\0';

	int size = a * b * n;
	//m = new int[size];
	fstream entrada;
	entrada.open(arg, fstream::in);
	entrada.seekg(pos, entrada.beg);

	for (int i = 0; i < size; i++) {
		entrada.getline(cadena, 300);
		m[i] = atoi(cadena);
	}
	entrada.close();
}
void createConvolutionKernelArray(fstream & input, float * convolutionKernel) {

	float current = 0;
	int i = 0;
	while (input >> current) {
		convolutionKernel[i++] = current;
	}
}

void readConvolutionKernel(float *convolutionKernel) {

	fstream entrada;
	char * file =
			"/home/perro/Dropbox/DEVenviroment/cuda project/parallelImageProcessor/Debug/convolutionKernel";
	entrada.open(file, fstream::in);
	createConvolutionKernelArray(entrada, convolutionKernel);
}

/**
 * @brief De un string "alto" espacio ancho, solo retorna el ancho en entero.
 * @param t String formato alto espacio ancho ej "500 500"
 * @return Retorna el ancho como integer
 ** */
int getWidthFromString(char *t) {

	int c = 0;
	int valor = -1;
	char aux[20];
	aux[0] = '\0';

	for (int i = 0; i < strlen(t); i++) {

		if (t[i] != ' ') {
			c = strlen(aux);
			aux[c] = t[i];
			aux[c + 1] = '\0';
		} else {
			break;
		}
	}
	valor = atoi(aux);

	if (valor != -1)
		return valor;
	else
		return -1;
}

/**
 * @brief De un string alto espacio ancho, solo retorna el alto en entero.
 * @param t String formato alto espacio ancho ej "500 500"
 * @return Retorna el alto como integer
 ** */
int getLengthFromString(char *t) {

	int c = 0;
	char aux[20];
	aux[0] = '\0';
	int valor = -1;
	bool leer = false;

	for (int i = 0; i < strlen(t); i++) {

		if (t[i] == ' ') {
			leer = true;
			continue;
		} else {
			if (leer) {
				c = strlen(aux);
				aux[c] = t[i];
				aux[c + 1] = '\0';
			}
		}
	}
	valor = atoi(aux);
	if (valor != -1)
		return valor;
	else
		return -1;

}

void horizontalEdgesMask(float *mask) {
	mask[0] = 1;
	mask[1] = 2;
	mask[2] = 1;
	mask[3] = 0;
	mask[4] = 0;
	mask[5] = 0;
	mask[6] = -1;
	mask[7] = -2;
	mask[8] = -1;
}

void verticalEdgesMask(float * mask) {
	mask[0] = 1;
	mask[1] = 0;
	mask[2] = -1;
	mask[3] = 2;
	mask[4] = 0;
	mask[5] = -2;
	mask[6] = 1;
	mask[7] = 0;
	mask[8] = -1;
}

void sharpenMask(float * mask) {
	mask[0] = -1;
	mask[1] = -1;
	mask[2] = -1;
	mask[3] = -1;
	mask[4] = 9;
	mask[5] = -1;
	mask[6] = -1;
	mask[7] = -1;
	mask[8] = -1;
}

void blurMask(float * mask) {
	mask[0] = 1;
	mask[1] = 1;
	mask[2] = 1;
	mask[3] = 1;
	mask[4] = 1;
	mask[5] = 1;
	mask[6] = 1;
	mask[7] = 1;
	mask[8] = 1;
}

void serialSobelFilter(int *a, int *b, int *c, int size) {

	for (int i = 0; i < size; i++) {
		c[i] = a[i] + b[i];
		if (c[i] > 255) {
			c[i] = 255;
		}
	}
}

void writeGpmImage(int *image, int row, int column, int max) {

	ofstream outputFile;
	outputFile.open("test.pgm", outputFile.out);
	outputFile << "P2" << endl;
	outputFile << "#RPM TT dev" << endl;
	outputFile << row << " " << column << endl;
	outputFile << max << endl;
	for (int i = 0; i < row * column; i++) {
		outputFile << image[i] << endl;
	}

	outputFile.close();

}

void displayImagesFilter() {

	string filters[100];
	int filtersNumber = MAX_OPTION;

	filters[0] = "1 convertir imagen a escala de grises";
	filters[1] =
			"2 deteccion de bordes horizontal con convolucion bidimensional";
	filters[2] = "3 deteccion de bordes vertical con convolucion bidimensional";
	filters[3] = "4 deteccion de bordes de sobel";
	filters[4] = "5 convolucion bidimensional desde archivo convolutionKernel";
	filters[5] = "6 sharpen filter por convolucion bidimensional";
	filters[6] = "7 blur filter por convolucion bidimensional";

	cout << "seleccionar de la siguiente lista los filtros: " << endl;
	for (int i = 0; i < filtersNumber; i++) {
		cout << "\t" << filters[i] << endl;
	}
	cout << endl << endl << "Opcion : ";
}

bool checkInputFilterOption(int a) {

	if (a >= MIN_OPTION && a <= MAX_OPTION) {
		return true;
	}
	return false;
}

bool setImageFiltersToNodes(int filtersNumber, vector<ProcessNode> *node) {

	int option = 0;
	bool okProcess = true;

	for (int i = 0; i < filtersNumber; i++) {
		cout << "Para el filtro numero " << i + 1 << endl << endl;
		displayImagesFilter();
		cin >> option;
		cout << endl;
		if (!checkInputFilterOption(option)) {
			okProcess = false;
			break;
		}
		ProcessNode p;
		p.setFilter(option);
		node->push_back(p);
	}

	if (okProcess) {
		return true;
	} else {
		cout << "nook";
		return false;
	}

}

bool checkOkNumbersOfNodes(int number) {
	if (number > 0) {
		return true;
	}
	return false;
}

bool initialSettings(vector<ProcessNode> *nodes) {
	int nodesNumber = -1;

	cout << "ingresar el numero de filtros a ejecutar ";
	cin >> nodesNumber;
	if (!checkOkNumbersOfNodes(nodesNumber)) {
		cout << "Error al ingresar un numero incorrecto de nodos" << endl;
		return false;
	}

	if (!setImageFiltersToNodes(nodesNumber, nodes)) {
		cout << "Error al momento de seleccionar filtros, opcion no valida"
				<< endl;
		return false;
	}

	return true;
}

bool setEmptyPipeline(vector<ProcessNode> *nodes, Image image) {

	ProcessNode initNode;
	ProcessNode finalNode;

	initNode.setInputImage(image);
	nodes->push_back(initNode);
	if (!initialSettings(nodes)) {
		nodes->pop_back();
		return false;
	}
	nodes->push_back(finalNode);
	return true;
}

int sMatrixOperator(int *d_greyMap, float *d_mask, int a, int b, int c, int d,
		int idx, int idy, int factor, int row) {
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

void staticConvolution(int *d_greyMap, float *d_mask, int *d_convertedMap, int factor,
		int row, int column) {
	int convertedPixel = 0;
	int a;
	int b;
	int c;
	int d;

	for (int idx = 0; idx < row; idx++) {
		for (int idy = 0; idy < column; idy++) {

			if (idx < row && idy < column) {
				if (idx == 0) {
					if (idy == 0) {
						a = 1;
						b = 2;
						c = 1;
						d = 2;
						convertedPixel = sMatrixOperator(d_greyMap, d_mask, a,
								b, c, d, idx, idy, factor, row);
					} else if (idy == (column - 1)) {
						a = 1;
						b = 2;
						c = 0;
						d = 1;
						convertedPixel = sMatrixOperator(d_greyMap, d_mask, a,
								b, c, d, idx, idy, factor, row);
					} else {
						a = 1;
						b = 2;
						c = 0;
						d = 2;
						convertedPixel = sMatrixOperator(d_greyMap, d_mask, a,
								b, c, d, idx, idy, factor, row);
					}
				} else if (idx == (row - 1)) {
					if (idy == 0) {
						a = 0;
						b = 1;
						c = 1;
						d = 2;
						convertedPixel = sMatrixOperator(d_greyMap, d_mask, a,
								b, c, d, idx, idy, factor, row);
					} else if (idy == (column - 1)) {
						a = 0;
						b = 1;
						c = 0;
						d = 1;
						convertedPixel = sMatrixOperator(d_greyMap, d_mask, a,
								b, c, d, idx, idy, factor, row);
					} else {
						a = 0;
						b = 1;
						c = 0;
						d = 2;
						convertedPixel = sMatrixOperator(d_greyMap, d_mask, a,
								b, c, d, idx, idy, factor, row);
					}
				} else {
					if (idy == 0) {
						a = 0;
						b = 2;
						c = 1;
						d = 2;
						convertedPixel = sMatrixOperator(d_greyMap, d_mask, a,
								b, c, d, idx, idy, factor, row);
					} else if (idy == (column - 1)) {
						a = 0;
						b = 2;
						c = 0;
						d = 1;
						convertedPixel = sMatrixOperator(d_greyMap, d_mask, a,
								b, c, d, idx, idy, factor, row);
					} else {
						a = 0;
						b = 2;
						c = 0;
						d = 2;
						convertedPixel = sMatrixOperator(d_greyMap, d_mask, a,
								b, c, d, idx, idy, factor, row);
					}
				}
				d_convertedMap[idx + idy * row] = convertedPixel;
			}
		}
	}
}

void sumMatrix(int * a, int * b, int *c, int f, int co) {

	for (int i = 0; i < f * co; i++) {
		c[i] = sqrt((float) a[i] * a[i] + b[i] * b[i]);
	}
}

#endif /* UTIL_CU_ */

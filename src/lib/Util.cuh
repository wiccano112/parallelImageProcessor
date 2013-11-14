/*
 * Util.cu
 *
 *  Created on: 31/10/2013
 *      Author: perro
 */

#ifndef UTIL_CUH_
#define UTIL_CUH_

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
		if (strcmp(cadena, "P3")) {
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
		//TODO instanciar arreglo antes de recorrerlo plop
		m[i] = atoi(cadena);
		//cout<<"RPM "<<cadena <<" ";
	}
	entrada.close();
}

/**
 * @brief De un string alto espacio ancho, solo retorna el ancho en entero.
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

void horizontalEdgesMask(int *mask) {
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

void verticalEdgesMask(int * mask) {
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

void testSobel(int *a, int *b, int *c, int size) {

	for (int i = 0; i < size; i++) {
		c[i] = a[i] + b[i];
		if (c[i] > 255) {
			c[i] = 255;
		}
	}
}

#endif /* UTIL_CU_ */

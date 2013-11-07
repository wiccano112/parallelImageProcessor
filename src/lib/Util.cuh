/*
 * Util.cu
 *
 *  Created on: 31/10/2013
 *      Author: perro
 */

#ifndef UTIL_CUH_
#define UTIL_CUH_

using namespace std;

//static const int WORK_SIZE = 256;
//
///**
// * This macro checks return value of the CUDA runtime call and exits
// * the application if the call failed.
// */
//#define CUDA_CHECK_RETURN(value) {											\
//	cudaError_t _m_cudaStat = value;										\
//	if (_m_cudaStat != cudaSuccess) {										\
//		fprintf(stderr, "Error %s at line %d in file %s\n",					\
//				cudaGetErrorString(_m_cudaStat), __LINE__, __FILE__);		\
//		exit(1);															\
//	} }
//
//__device__ unsigned int bitreverse(unsigned int number) {
//	number = ((0xf0f0f0f0 & number) >> 4) | ((0x0f0f0f0f & number) << 4);
//	number = ((0xcccccccc & number) >> 2) | ((0x33333333 & number) << 2);
//	number = ((0xaaaaaaaa & number) >> 1) | ((0x55555555 & number) << 1);
//	return number;
//}
//
///**
// * CUDA kernel function that reverses the order of bits in each element of the array.
// */
//__global__ void bitreverse(void *data) {
//	unsigned int *idata = (unsigned int*) data;
//	idata[threadIdx.x] = bitreverse(idata[threadIdx.x]);
//}
//
//void cudaTest() {
//	void *d;
//	int i;
//	unsigned int idata[WORK_SIZE], odata[WORK_SIZE];
//
//	for (i = 0; i < WORK_SIZE; i++)
//		idata[i] = (unsigned int) i;
//
//	CUDA_CHECK_RETURN(cudaMalloc((void**) &d, sizeof(int) * WORK_SIZE));
//	CUDA_CHECK_RETURN(
//			cudaMemcpy(d, idata, sizeof(int) * WORK_SIZE, cudaMemcpyHostToDevice));
//
//	bitreverse<<<1, WORK_SIZE, WORK_SIZE * sizeof(int)>>>(d);
//
//	CUDA_CHECK_RETURN(cudaThreadSynchronize());
//	// Wait for the GPU launched work to complete
//	CUDA_CHECK_RETURN(cudaGetLastError());
//	CUDA_CHECK_RETURN(
//			cudaMemcpy(odata, d, sizeof(int) * WORK_SIZE, cudaMemcpyDeviceToHost));
//
//	for (i = 0; i < WORK_SIZE; i++)
//		printf("Input value: %u, device output: %u\n", idata[i], odata[i]);
//
//	CUDA_CHECK_RETURN(cudaFree((void*) d));
//	CUDA_CHECK_RETURN(cudaDeviceReset());
//}

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

#endif /* UTIL_CU_ */

/*
 * filterAplication.h
 *
 *  Created on: 22/12/2013
 *      Author: perro
 */

#ifndef FILTERAPPLICATION_H_
#define FILTERAPPLICATION_H_

#include <vector>
#include <ProcessNode.h>
#include <cudaSources.cuh>

using namespace std;

// "1 convertir imagen a escala de grises";
// "2 deteccion de bordes horizontal con convolucion bidimensional";
// "3 deteccion de bordes vertical con convolucion bidimensional";
// "4 deteccion de bordes de sobel";
// "5 convolucion bidimensional por defecto";

Image doFilter(Image image, int filterOption, int factor) {

	switch (filterOption) {
	case 1: {
		// "1 convertir imagen a escala de grises";
		if (strcmp(image.getHeader(), "P3") == 0) {
			int bitMapLenght = image.getBipMapLength();
			int *bitMap = new int[bitMapLenght];
			int *grayBitMap = new int[bitMapLenght];
			bitMap = image.getBitMap();
			cudaConvertToGreyMap(bitMap, grayBitMap, bitMapLenght);
			image.setHeader("P2");
			image.setBitMap(grayBitMap);
			image.setBitMapLength(bitMapLenght);
		} else {
			// do nothing
		}
		break;
	}
	case 2: {
		// "2 deteccion de bordes horizontal con convolucion bidimensional"
		int cFactor = factor;
		if (strcmp(image.getHeader(), "P3") == 0) {
			int bitMapLenght = image.getBipMapLength();
			int *bitMap = new int[bitMapLenght];
			int *grayBitMap = new int[bitMapLenght];
			int *convolutionBitMap = new int[bitMapLenght];
			int *mask = new int[9];
			int row = image.getLength();
			int column = image.getWidth();
			horizontalEdgesMask(mask);
			bitMap = image.getBitMap();
			cudaConvertToGreyMap(bitMap, grayBitMap, bitMapLenght);
			cudaConvolution(grayBitMap, convolutionBitMap, mask, row, column,
					cFactor);
			image.setHeader("P2");
			image.setBitMap(convolutionBitMap);
			image.setBitMapLength(bitMapLenght);
		} else if (strcmp(image.getHeader(), "P2") == 0) {
			int bitMapLenght = image.getBipMapLength();
			int *grayBitMap = new int[bitMapLenght];
			int *convolutionBitMap = new int[bitMapLenght];
			int *mask = new int[9];
			int row = image.getLength();
			int column = image.getWidth();
			horizontalEdgesMask(mask);
			grayBitMap = image.getBitMap();
			cudaConvolution(grayBitMap, convolutionBitMap, mask, row, column,
					cFactor);
			image.setBitMap(convolutionBitMap);
			image.setBitMapLength(bitMapLenght);
		}
		break;
	}
	case 3: {
		// "3 deteccion de bordes vertical con convolucion bidimensional";
		int cFactor = factor;
		if (strcmp(image.getHeader(), "P3") == 0) {
			int bitMapLenght = image.getBipMapLength();
			int *bitMap = new int[bitMapLenght];
			int *grayBitMap = new int[bitMapLenght];
			int *convolutionBitMap = new int[bitMapLenght];
			int *mask = new int[9];
			int row = image.getLength();
			int column = image.getWidth();
			verticalEdgesMask(mask);
			bitMap = image.getBitMap();
			cudaConvertToGreyMap(bitMap, grayBitMap, bitMapLenght);
			cudaConvolution(grayBitMap, convolutionBitMap, mask, row, column,
					cFactor);
			image.setHeader("P2");
			image.setBitMap(convolutionBitMap);
			image.setBitMapLength(bitMapLenght);
		} else if (strcmp(image.getHeader(), "P2") == 0) {
			int bitMapLenght = image.getBipMapLength();
			int *grayBitMap = new int[bitMapLenght];
			int *convolutionBitMap = new int[bitMapLenght];
			int *mask = new int[9];
			int row = image.getLength();
			int column = image.getWidth();
			verticalEdgesMask(mask);
			grayBitMap = image.getBitMap();
			cudaConvolution(grayBitMap, convolutionBitMap, mask, row, column,
					cFactor);
			image.setBitMap(convolutionBitMap);
			image.setBitMapLength(bitMapLenght);
		}
		break;
	}
	case 4: {
		// "4 deteccion de bordes de sobel";
		int cFactor = factor;
		if (strcmp(image.getHeader(), "P3") == 0) {
			int bitMapLenght = image.getBipMapLength();
			int *bitMap = new int[bitMapLenght];
			int *grayBitMap = new int[bitMapLenght];
			int *convolutionBitMap = new int[bitMapLenght];
			int *mask = new int[9];
			int row = image.getLength();
			int column = image.getWidth();
			verticalEdgesMask(mask);
			bitMap = image.getBitMap();
			cudaConvertToGreyMap(bitMap, grayBitMap, bitMapLenght);
			cudaSobelFilter(grayBitMap, convolutionBitMap, row, column, cFactor);
			image.setHeader("P2");
			image.setBitMap(convolutionBitMap);
			image.setBitMapLength(bitMapLenght);
		} else if (strcmp(image.getHeader(), "P2") == 0) {
			int bitMapLenght = image.getBipMapLength();
			int *grayBitMap = new int[bitMapLenght];
			int *convolutionBitMap = new int[bitMapLenght];
			int *mask = new int[9];
			int row = image.getLength();
			int column = image.getWidth();
			verticalEdgesMask(mask);
			grayBitMap = image.getBitMap();
			cudaSobelFilter(grayBitMap, convolutionBitMap, row, column, cFactor);
			image.setBitMap(convolutionBitMap);
			image.setBitMapLength(bitMapLenght);
		}
		break;
	}
	default: {
		cout << "error extraño";
		break;
	}
	}

	return image;
}

void pipelineIterator(vector<ProcessNode> *nodes, Image image, int factor) {
	int actual = 0;

	for (int i = actual; i < nodes->size(); i++) {
		if (i == 0) {
			//initial node
			nodes[0][i + 1].setInputImage(nodes[0][i].getInputImage());
		} else if (i == nodes->size() - 1) {
			//last node
			nodes[0][i].setOutputImage(nodes[0][i].getInputImage());
		} else {
			//filter node
			nodes[0][i].setOutputImage(
					doFilter(nodes[0][i].getInputImage(),
							nodes[0][i].getFilter(), factor));
			nodes[0][i + 1].setInputImage(nodes[0][i].getOutputImage());
		}
	}
}
#endif /* FILTERAPLICATION_H_ */

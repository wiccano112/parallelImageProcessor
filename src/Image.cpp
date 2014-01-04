/*
 * colorImage.cpp
 *
 *  Created on: 31/10/2013
 *      Author: perro
 */

#include <iostream>
#include "Image.h"
#include <cstring>
using namespace std;

Image::Image() {
	header = 0;
	maxColorBit = 0;
	length = 0;
	width = 0;
	bitMap = new int[length * width];
}

Image::Image(char * head, int maxColor, int imageLength, int imageWidth,
		int * map) {
	if (strcmp(head, "P3")) {
		header = head;
		maxColorBit = maxColor;
		length = imageLength;
		width = imageWidth;
		//bitMap = new int[imageLength * imageWidth * 3];
		bitMap = map;
		bitMapLength = length * width * 3;
	}
	if (strcmp(head, "P2")) {
		header = head;
		maxColorBit = maxColor;
		length = imageLength;
		width = imageWidth;
		//bitMap = new int[imageLength * imageWidth];
		bitMap = map;
		bitMapLength = length * width;
	}
}

int Image::getBipMapLength() {
	return bitMapLength;
}
Image::~Image() {
}

void Image::convertToGrey() {
	int * auxBitMap;

	cout << "RPM begin to grey convert header " << header << " "
			<< strcmp(header, "P3") << endl;

	if (!strcmp(header, "P2")) {
		cout << "RPM its already a grey image" << endl;
	}

	if (!strcmp(header, "P3")) {
		auxBitMap = bitMap;
		bitMap = 0;
		bitMap = new int[length * width];
		int arrayLong = length * width * 3;

		for (int i = 0; i < arrayLong; i = i + 3) {
			bitMap[i / 3] = (int) (auxBitMap[i] + auxBitMap[i + 1]
					+ auxBitMap[i + 2]) / 3;
		}
		header = "P2";
		cout << "RPM image its convert" << endl;
	}
}

void Image::printImagetoConsole() {

	cout << header << endl << "#imagen creada con parallelImageProcesor"
			<< endl;
	cout << length << " " << width << endl << maxColorBit << endl;
	int bitMapLength = sizeof(bitMap) / sizeof(bitMap[0]);

	for (int i = 0; i < length * width; i++) {
		cout << bitMap[i] << endl;
	}
}

int * Image::getBitMap() {
	return bitMap;
}

char * Image::getHeader() {
	return header;
}

void Image::setBitMap(int *i) {
	bitMap = i;
}

void Image::setBitMapLength(int i){
	bitMapLength = i;
}

void Image::setHeader(char *c) {
	header = c;
}

int Image::getLength() {
	return length;
}

int Image::getWidth() {
	return width;
}

int Image::getMaxColorBit() {
	return maxColorBit;
}

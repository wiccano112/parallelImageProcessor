#ifndef PROFILINGMETHODS_H
#define PROFILINGMETHODS_H

#include <cudaSources.cuh>
#include <Util.h>
void testCodeStaticSobel(Image image) {
	int f = image.getLength();
	int c = image.getWidth();

	int * grayMap = new int[f * c];
	int * cGrayMap1 = new int[f * c];
	int * cGrayMap2 = new int[f * c];
	int * conc = new int[f * c];
	float *mask = new float[9];

	horizontalEdgesMask(mask);
	cudaConvertToGreyMap(image.getBitMap(), grayMap, image.getBipMapLength());
	staticConvolution(grayMap, mask, cGrayMap1, 1, f, c);
	verticalEdgesMask(mask);
	staticConvolution(grayMap, mask, cGrayMap2, 1, f, c);
	sumMatrix(cGrayMap1, cGrayMap2, conc, f, c);
}

void testCodeStaticSharpen(Image image) {
	int f = image.getLength();
	int c = image.getWidth();

	int * grayMap = new int[f * c];
	int * cGrayMap1 = new int[f * c];
	int * cGrayMap2 = new int[f * c];
	int * conc = new int[f * c];
	float *mask = new float[9];

	sharpenMask(mask);
	cudaConvertToGreyMap(image.getBitMap(), grayMap, image.getBipMapLength());
	staticConvolution(grayMap, mask, cGrayMap1, 1, f, c);
}

void testCodeStaticBlur(Image image) {
	int f = image.getLength();
	int c = image.getWidth();

	int * grayMap = new int[f * c];
	int * cGrayMap1 = new int[f * c];
	int * cGrayMap2 = new int[f * c];
	int * conc = new int[f * c];
	float *mask = new float[9];

	blurMask(mask);
	cudaConvertToGreyMap(image.getBitMap(), grayMap, image.getBipMapLength());
	staticConvolution(grayMap, mask, cGrayMap1, 9, f, c);
}

void testCodeParalellSobel(Image image) {
	int f = image.getLength();
	int c = image.getWidth();

	int * grayMap = new int[f * c];
	int * cGrayMap1 = new int[f * c];
	int * cGrayMap2 = new int[f * c];
	int * conc = new int[f * c];
	float * mask = new float[9];

	horizontalEdgesMask(mask);
	cudaConvertToGreyMap(image.getBitMap(), grayMap, image.getBipMapLength());
	cudaSobelFilter(grayMap, conc, f, c, 1);
}

void testCodeParalellSharpen(Image image) {
	int f = image.getLength();
	int c = image.getWidth();

	int * grayMap = new int[f * c];
	int * cGrayMap1 = new int[f * c];
	int * cGrayMap2 = new int[f * c];
	int * conc = new int[f * c];
	float * mask = new float[9];

	sharpenMask(mask);
	cudaConvertToGreyMap(image.getBitMap(), grayMap, image.getBipMapLength());
	cudaConvolution(grayMap, conc, mask, f, c, 1);
}

void testCodeParalellBlur(Image image) {
	int f = image.getLength();
	int c = image.getWidth();

	int * grayMap = new int[f * c];
	int * cGrayMap1 = new int[f * c];
	int * cGrayMap2 = new int[f * c];
	int * conc = new int[f * c];
	float * mask = new float[9];

	blurMask(mask);
	cudaConvertToGreyMap(image.getBitMap(), grayMap, image.getBipMapLength());
	cudaConvolution(grayMap, conc, mask, f, c, 9);
}

#endif

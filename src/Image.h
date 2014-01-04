/*
 * Image.h
 *
 *  Created on: 31/10/2013
 *      Author: perro
 */

#ifndef IMAGE_H_
#define IMAGE_H_

class Image {

private:
	char *header;
	int maxColorBit;
	int length;
	int width;
	int * bitMap;
	int bitMapLength;
public:
	Image();
	Image(char * head, int maxColor, int imageLength, int imageWidth,
			int * map);
	virtual ~Image();

	void convertToGrey();
	void printImagetoConsole();
	int * getBitMap();
	int getBipMapLength();
	char * getHeader();
	void setHeader(char * c);
	void setBitMap(int * i);
	void setBitMapLength(int i);
	int getLength();
	int getWidth();
	int getMaxColorBit();
};
#endif /* IMAGE_H_ */

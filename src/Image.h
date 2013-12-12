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
	char * header;
	int maxColorBit;
	int length;
	int width;
	int * bitMap;
public:
	Image();
	//Image(Image const &);
	Image(char * head, int maxColor, int imageLength, int imageWidth,
			int * map);
	virtual ~Image();

	void convertToGrey();
	void printImagetoConsole();
	int * getBitMap();
};
#endif /* IMAGE_H_ */

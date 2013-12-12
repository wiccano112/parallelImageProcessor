/*
 * CovertToGray.h
 *
 *  Created on: 11/12/2013
 *      Author: perro
 */

#ifndef COVERTTOGRAY_H_
#define COVERTTOGRAY_H_

#include "ImageFilter.h"

class CovertToGray: public ImageFilter {
private:
	int* originMap;
	int* convertedMap;
	int convertedMapSize;

public:
	CovertToGray();
	virtual ~CovertToGray();
};

#endif /* COVERTTOGRAY_H_ */

/*
 * ProcessNode.h
 *
 *  Created on: 09/12/2013
 *      Author: perro
 */

#ifndef PROCESSNODE_H_
#define PROCESSNODE_H_

#include "Image.h"

class ProcessNode {

private:
	Image outputImage;
	Image inputImage;
	int filter;

public:
	ProcessNode();
	ProcessNode(Image in, Image out);
	//ProcessNode(const ProcessNode &p);
	virtual ~ProcessNode();

	Image getInputImage();
	Image getOutputImage();
	int getFilter();
	void setOutputImage(Image i);
	void setInputImage(Image i);
	void setFilter(int f);

};

#endif /* PROCESSNODE_H_ */

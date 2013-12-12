/*
 * ProcessNode.cpp
 *
 *  Created on: 09/12/2013
 *      Author: perro
 */

#include "ProcessNode.h"
#include "Image.h"

ProcessNode::ProcessNode() {
	// TODO Auto-generated destructor stub
}

ProcessNode::ProcessNode(Image in, Image out) {
	outputImage = out;
	inputImage = in;
}

ProcessNode::~ProcessNode() {
	// TODO Auto-generated destructor stub
}

Image ProcessNode::getOutputImage() {
	return outputImage;
}

void ProcessNode::setOutputImage(Image i) {
	outputImage = i;
}


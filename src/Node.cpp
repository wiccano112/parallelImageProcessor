/*
 * Node.cpp
 *
 *  Created on: 09/12/2013
 *      Author: perro
 */

#include "Node.h"

Node::Node() {
	inputImage = 0;
}

Node::Node(Image i) {
	inputImage = i;
}

Node::~Node() {
	// TODO Auto-generated destructor stub
}

Image Node::getInputImage() {
	return inputImage;
}

void Node::setInputImage(Image i) {
	inputImage = i;
}

void Node::eraseInputImage() {
	inputImage = 0;
}

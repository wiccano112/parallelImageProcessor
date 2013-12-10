/*
 * ProcessNode.h
 *
 *  Created on: 09/12/2013
 *      Author: perro
 */

#ifndef PROCESSNODE_H_
#define PROCESSNODE_H_

#include "Node.h"

class ProcessNode : public Node {

private:
	Image outputImage;

public:
	ProcessNode();
	ProcessNode(ProcessNode const&);
	ProcessNode(Image in, Image out);
	virtual ~ProcessNode();

	Image getOutputImage();
	void setOutputImage(Image i);
	void eraseOutputImage();

};

#endif /* PROCESSNODE_H_ */

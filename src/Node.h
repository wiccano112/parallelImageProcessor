/*
 * Node.h
 *
 *  Created on: 09/12/2013
 *      Author: perro
 */

#ifndef NODE_H_
#define NODE_H_

class Node {

protected:

	Image inputImage;

public:
	Node();
	Node(Node const &);
	Node(Image i);
	virtual ~Node();

	Image getInputImage();
	void setInputImage(Image i);
	void eraseInputImage();
};

#endif /* NODE_H_ */

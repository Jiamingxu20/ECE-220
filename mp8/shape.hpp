#ifndef SHAPE_H_
#define SHAPE_H_

#include <iostream>
#include <cmath>
#include <string>
#include <algorithm>
#include <list>
#include <fstream>
#include <iomanip>

using namespace std;

// Base class
// Please implement Shape's member functions
// constructor, getName()
class Shape
{
public:
	// Base class' constructor should be called in derived classes'
	// constructor to initizlize Shape's private variable
	Shape(string name)
	{
		name_ = name;
	}

	string getName()
	{
		return name_;
	}

	virtual double getArea() const = 0;
	virtual double getVolume() const = 0;

private:
	string name_;
};

// Rectangle
// Please implement the member functions of Rectangle:
// constructor, getArea(), getVolume(), operator+, operator-

template <class T>
class Rectangle : public Shape
{
public:
	Rectangle(double width = 0, double length = 0) : Shape("Rectangle")
	{
		width_ = width;
		length_ = length;
	}

	double getArea() const
	{
		return (width_*length_);
	}

	double getVolume() const
	{
		return 0;
	}

	Rectangle operator+(const Rectangle &rec)
	{
		return Rectangle(width_ + rec.width_, length_ + rec.length_);
	}

	Rectangle operator-(const Rectangle &rec)
	{
		return Rectangle(std::max(0.0, width_ - rec.width_), std::max(0.0, length_ - rec.length_));
	}

	double getWidth() const
	{
		return width_;
	}

	double getLength() const
	{
		return length_;
	}

private:
	double width_;
	double length_;
};

// Circle
// Please implement the member functions of Circle:
// constructor, getArea(), getVolume(), operator+, operator-
//@@Insert your code here

class Circle : public Shape
{
public:
	Circle(double radius) : Shape("Circle")
	{
		radius_ = radius;
	}

	double getArea() const
	{
		return radius_ * radius_ * 3.141592653589793238;
	}

	double getVolume() const
	{
		return 0;
	}

	Circle operator+(const Circle &cir)
	{
		return Circle(radius_ + cir.radius_);
	}

	Circle operator-(const Circle &cir)
	{
		return Circle(std::max(0.0, radius_ - cir.radius_));
	}

	double getRadius() const
	{
		return radius_;
	}

private:
	double radius_;
};

// Sphere
// Please implement the member functions of Sphere:
// constructor, getArea(), getVolume(), operator+, operator-
//@@Insert your code here

class Sphere : public Shape
{
public:
	Sphere(double radius) : Shape("Sphere")
	{
		radius_ = radius;
	}

	double getVolume() const
	{
		return 4 * radius_ * radius_ * radius_ * 3.141592653589793238 / 3;
	}

	double getArea() const
	{
		return 4 * radius_ * radius_ * 3.141592653589793238;
	}

	Sphere operator+(const Sphere &sph)
	{
		return Sphere(radius_ + sph.radius_);
	}

	Sphere operator-(const Sphere &sph)
	{
		return Sphere(std::max(0.0, radius_ - sph.radius_));
	}

	double getRadius() const
	{
		return radius_;
	}

private:
	double radius_;
};

// Rectprism
// Please implement the member functions of RectPrism:
// constructor, getArea(), getVolume(), operator+, operator-
//@@Insert your code here
class RectPrism : public Shape
{
public:
	RectPrism(double width, double length, double height) : Shape("RectPrism")
	{
		length_ = length;
		width_ = width;
		height_ = height;
	}

	double getVolume() const
	{
		return height_ * width_ * length_;
	}

	double getArea() const
	{
		return 2 * (height_ * width_ + width_ * length_ + height_ * length_);
	}

	RectPrism operator+(const RectPrism &rectp)
	{
		return RectPrism(width_ + (rectp).getWidth(), length_ + rectp.length_, height_ + rectp.height_);
	}

	RectPrism operator-(const RectPrism &rectp)
	{	
		return RectPrism(std::max(0.0, width_ - rectp.width_), std::max(0.0, length_ - rectp.length_), std::max(0.0, height_ - rectp.height_));
	}

	double getWidth() const
	{
		return width_;
	}

	double getLength() const
	{
		return length_;
	}

	double getHeight() const
	{
		return height_;
	}

private:
	double length_;
	double width_;
	double height_;
};

// Read shapes from test.txt and initialize the objects
// Return a vector of pointers that points to the objects
static list<Shape *> CreateShapes(char *file_name)
{

	list<Shape *> myShape;

	ifstream thefile (file_name, std::ifstream::in);
	int count;
	thefile >> count; 

	for (int i = 0; i < count; i++) {
		string name;
		thefile >> name; 
		if (name == "Circle") {
			double r;
			thefile >> r; 
			Shape* shape_ptr = new Circle(r);
			myShape.push_back(shape_ptr);
		} else if (name == "Rectangle") {
			double w, l;
			thefile >> w >> l;
			Shape* shape_ptr = new Rectangle<double>(w, l);
			myShape.push_back(shape_ptr);
		} else if (name == "Sphere") {
			double r;
			thefile >> r;
			Shape* shape_ptr = new Sphere(r);
			myShape.push_back(shape_ptr);
		} else if (name == "RectPrism") {
			double a, b, c;
			thefile >> a >> b >> c;
			Shape* shape_ptr = new RectPrism(a, b, c);
			myShape.push_back(shape_ptr);
		}
	}
	return myShape;
}

// call getArea() of each object
// return the max area
static double MaxArea(list<Shape *> shapes)
{
	double array[shapes.size()];
	int counter = 0;
	for (list<Shape *>::iterator it = shapes.begin(); it != shapes.end(); it++) {
		array[counter] = (*it)->getArea();
		counter++;
	}
	
	double max = array[0];
	for (unsigned int i = 0; i < shapes.size(); i++) {
		if (array[i] >= max) {
			max = array[i];
		}
	}
	return max; 
}

// call getVolume() of each object
// return the max volume
static double MaxVolume(list<Shape *> shapes)
{
	double array[shapes.size()];
	int counter = 0;
	for (list<Shape *>::iterator it = shapes.begin(); it != shapes.end(); it++) {
		array[counter] = (*it)->getVolume();
		counter++;
	}
	
	double max = array[0];
	for (unsigned int i = 0; i < shapes.size(); i++) {
		if (array[i] >= max) {
			max = array[i];
		}
	}
	return max;
}
#endif

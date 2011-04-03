#ifndef life_h
#define life_h

#include "WProgram.h"

class Life {
	public:
		Life(int x, int y);
		int step();
		int* getState();
		int seed();
	private:
		int _x;
		int _y;
		int* _current;
		int* _next;

		int update(int x, int y);
		int offset(int x, int y);
};
#endif

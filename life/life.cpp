#include "WProgram.h"
#include "life.h"

Life::Life(int x, int y) {
	if (x < 1)
		x = 1;
	if (y < 1)
		y = 1;
	_x = x;
	_y = y;
	_current = (int*)calloc(x + y, sizeof(int));
	_next    = (int*)calloc(x + y, sizeof(int));
	seed();
}

int* Life::getState() {
	return _current;
}

int Life::step() {
	int changes = 0;

	for (int i = 0; i < _x; i++) {
		for (int j = 0; j < _y; j++) {
			changes += update(i, j);
		}
	}

	int* tmp = _current;
	_current = _next;
	_next = tmp;

	return changes;
}

int Life::update(int x, int y) {
	int sum = 0;
	int off = offset(x, y);

	for (int i = max(0, x-1); i < min(_x, x+2); i++) {
		for (int j = max(0, y-1); j < min(_y, y+2); j++) {
			if ((i == x) && (j == y))
				continue;
			sum += _current[offset(i, j)];
		}
	}

	int newValue = 0;
	int changed = 0;
	if (sum < 2 || sum > 3) {
		// newValue = 0;
		changed = _current[off];
	} else if (sum == 3) {
		newValue = 1;
		changed = _current[off] == 0 ? 1 : 0;
	} else if (sum == 2) {
		newValue = _current[off];
	}

	_next[off] = newValue;
	return changed;
}

int Life::offset(int x, int y) {
	return x + y * _x;
}

int Life::seed() {
	for (int i = 0; i < _x; i++) {
		for (int j = 0; j < _y; j++) {
			_current[offset(i, j)] = random(0, 2);
		}
	}
}

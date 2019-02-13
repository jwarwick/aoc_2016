package main

import (
	"testing"
)

func TestPart1(t *testing.T) {
	input := `###########
#0.1.....2#
#.#######.#
#4.......3#
###########`

	m := createMap(input)
	m.findDistances()
	short := m.shortestPath()
	expected := 14
	if expected != short {
		t.Errorf("Shortest Path: Expected: %d, got: %d", expected, short)
	}

}

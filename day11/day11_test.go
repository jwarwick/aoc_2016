package main

import (
	"testing"
)

func TestPart1(t *testing.T) {
	example := []pair{pair{1, 2}, pair{1, 3}}
	result := shortestPath(example)
	expected := 11
	if expected != result {
		t.Errorf("Expected: %d, got: %d", expected, result)
	}

}

package main

import (
	"testing"
)

func TestCell(t *testing.T) {
	vars := []struct {
		x      uint
		y      uint
		result cell
	}{
		{0, 0, Open},
		{0, 1, Open},
		{1, 0, Wall},
		{0, 2, Wall},
		{9, 6, Wall},
		{5, 5, Open},
	}

	fav := uint(10)
	for _, v := range vars {
		p := point{v.x, v.y}
		result := p.compute(fav)
		if result != v.result {
			t.Errorf("Variable: (%d, %d), expected: %d, got: %d", v.x, v.y, result, v.result)
		}
	}
}

func TestSearch(t *testing.T) {
	expected := 11
	start := point{1, 1}
	target := point{7, 4}
	m := createMaze(10)
	result := shortestPath(m, start, target)
	if result != expected {
		t.Errorf("Shortest path expected: %d, got: %d", expected, result)
	}
}

package main

import (
	"testing"
)

func TestGame(t *testing.T) {
	expected := 3
	count := 5
	result := bestPosition(count)
	if result != expected {
		t.Errorf("Input: %d, expected: %d, got: %d", count, expected, result)
	}
}

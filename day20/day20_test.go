package main

import (
	"testing"
)

func TestPart1(t *testing.T) {
	input := `5-8
0-2
4-7`

	bl := createBlackList(input)
	expected := uint(3)
	result := firstAvailable(&bl, 0, 9)
	if expected != result {
		t.Errorf("Expected: %d, got: %d", expected, result)
	}
}

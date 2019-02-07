package main

import (
	"testing"
)

func TestPath(t *testing.T) {
	vars := []struct {
		input  string
		result string
	}{
		{"hijkl", ""},
		{"ihgpwlah", "DDRRRD"},
		{"kglvqrro", "DDUDRLRRUDRD"},
		{"ulqzkmiv", "DRURDRUDDLLDLUURRDULRLDUUDDDRR"},
	}

	for _, v := range vars {
		result := shortestPath(v.input)
		if result != v.result {
			t.Errorf("Input: %s, expected: %s, got: %s", v.input, v.result, result)
		}
	}
}

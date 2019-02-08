package main

import (
	"fmt"
	"io/ioutil"
	"strconv"
	"strings"
)

func main() {
	input, err := ioutil.ReadFile("./input.txt")
	if err != nil {
		panic(err)
	}

	nodes := createNodes(string(input))

	part1 := viablePairs(&nodes)
	fmt.Println("Part 1: ", part1)

	grid := makeGrid(&nodes)
	printGrid(&grid)
}

func printGrid(grid *[][]node) {
	for _, r := range *grid {
		for _, n := range r {
			fmt.Printf("%s", n.toString(grid))
		}
		fmt.Printf("\n")
	}
}

func makeGrid(nodes *[]node) [][]node {
	maxRow := uint(0)
	maxCol := uint(0)
	for _, n := range *nodes {
		if n.y > maxRow {
			maxRow = n.y
		}
		if n.x > maxCol {
			maxCol = n.x
		}
	}

	grid := make([][]node, maxRow+1)
	for idx, _ := range grid {
		grid[idx] = make([]node, maxCol+1)
	}

	for _, n := range *nodes {
		grid[n.y][n.x] = n
	}

	return grid
}

func viablePairs(nodes *[]node) int {
	count := 0
	for _, a := range *nodes {
		for _, b := range *nodes {
			if a.viable(&b) {
				count++
			}
		}
	}
	return count
}

type node struct {
	x, y uint
	size uint
	used uint
}

func (n node) toString(grid *[][]node) string {
	if n.used == 0 {
		return "_"
	} else if n.x == 0 && n.y == 0 {
		return "G"
	} else if n.y == 0 && int(n.x) == len((*grid)[0])-1 {
		return "S"
	} else if n.movable(grid) {
		return "."
	} else {
		return "#"
	}
}

func (n node) movable(grid *[][]node) bool {
	minSize := (*grid)[0][0].size
	return n.used < minSize+100
}

func (n *node) free() uint {
	return n.size - n.used
}

func (a *node) viable(b *node) bool {
	if a.x == b.x && a.y == b.y {
		return false
	} else if a.used == 0 {
		return false
	} else if a.used > b.free() {
		return false
	}
	return true
}

func createNodes(input string) []node {
	lines := splitInput(input)
	lines = lines[2:]
	nodes := make([]node, len(lines))
	for idx, l := range lines {
		nodes[idx] = parseLine(l)
	}
	return nodes
}

func parseLine(input string) node {
	fields := strings.Fields(input)
	names := strings.Split(fields[0], "-")
	x := parseInt(strings.Trim(names[1], "x"))
	y := parseInt(strings.Trim(names[2], "y"))
	size := parseInt(strings.Trim(fields[1], "T"))
	used := parseInt(strings.Trim(fields[2], "T"))
	return node{x, y, size, used}
}

func splitInput(input string) []string {
	trimmed := strings.TrimSpace(input)
	lines := strings.Split(trimmed, "\n")
	for i, l := range lines {
		lines[i] = strings.TrimSpace(l)
	}
	return lines
}

func parseInt(input string) uint {
	trimmed := strings.Trim(input, ",")
	i, err := strconv.Atoi(trimmed)
	if nil != err {
		panic("Not a number when parsing")
	}
	return uint(i)
}

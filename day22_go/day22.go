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
	nodes := make([]node, len(lines)-2)
	for idx, l := range lines {
		if idx < 2 {
			continue
		}
		nodes[idx-2] = parseLine(l)
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

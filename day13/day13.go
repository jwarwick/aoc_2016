package main

import (
	"container/list"
	"fmt"
	"math/bits"
)

func main() {
	var input uint
	input = 1364

	start := point{x: 1, y: 1}
	target := point{x: 31, y: 39}

	m := createMaze(input)
	fmt.Println(m)

	part1 := shortestPath(m, start, target)
	fmt.Println("Part 1: ", part1)
}

func shortestPath(m maze, start point, target point) int {
	seen := make(map[point]bool)
	s := m.getCell(start)
	if s != Open {
		panic("Starting search from a Wall")
	}
	seen[start] = true
	queue := list.New()
	queue.PushBack(searchPoint{start, 0})
	return search(queue, &m, &seen, &target)
}

func search(q *list.List, m *maze, seen *map[point]bool, target *point) int {
	elt := q.Front()
	if elt == nil {
		return -1
	}
	curr := elt.Value.(searchPoint)
	q.Remove(elt)

	if curr.p == *target {
		return int(curr.depth)
	}

	neighbors := curr.p.neighbors()
	for _, n := range neighbors {
		_, prs := (*seen)[n]
		if !prs {
			(*seen)[n] = true
			t := m.getCell(n)
			if Open == t {
				q.PushBack(searchPoint{n, curr.depth + 1})
			}
		}
	}

	return search(q, m, seen, target)
}

type cell int

const (
	Wall cell = iota
	Open
)

type searchPoint struct {
	p     point
	depth uint
}

type point struct {
	x uint
	y uint
}

func (p point) compute(favoriteNumber uint) cell {
	// x*x + 3*x + 2*x*y + y + y*y
	v := (p.x * p.x) + (3 * p.x) + (2 * p.x * p.y) + p.y + (p.y * p.y) + favoriteNumber
	ones := bits.OnesCount(v)
	if ones%2 == 0 {
		return Open
	} else {
		return Wall
	}
}

func (p point) neighbors() []point {
	var n []point
	n = append(n, point{p.x + 1, p.y})
	n = append(n, point{p.x, p.y + 1})
	if p.x > 0 {
		n = append(n, point{p.x - 1, p.y})
	}
	if p.y > 0 {
		n = append(n, point{p.x, p.y - 1})
	}
	return n
}

type maze struct {
	favoriteNumber uint
	cells          map[point]cell
}

func createMaze(favoriteNumber uint) maze {
	cells := make(map[point]cell)
	m := maze{favoriteNumber, cells}
	return m
}

func (m *maze) getCell(p point) cell {
	c, prs := m.cells[p]
	if !prs {
		c = p.compute(m.favoriteNumber)
		m.cells[p] = c
	}
	return c
}

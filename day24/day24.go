package main

import (
	"container/list"
	"fmt"
	"io/ioutil"
	"math"
	"strconv"
	"strings"
)

func main() {
	input, err := ioutil.ReadFile("./input.txt")
	if err != nil {
		panic(err)
	}

	m := createMap(string(input))
	m.findDistances()
	// m.display()
	part1 := m.shortestPath()
	fmt.Println("Part 1: ", part1)
}

type floorNodes map[point]node
type loc struct {
	p           point
	locationNum uint
}

type floorMap struct {
	nodes      floorNodes
	maxX, maxY int
	locations  []loc
	distances  [][]int
}

type searchPoint struct {
	p     point
	depth int
}

func (s searchPoint) neighbors() []point {
	n := make([]point, 8)
	idx := 0
	for xOff := -1; xOff <= 1; xOff++ {
		for yOff := -1; yOff <= 1; yOff++ {
			if !(xOff == 0 && yOff == 0) && (xOff == 0 || yOff == 0) {
				n[idx] = point{s.p.x + xOff, s.p.y + yOff}
				idx++
			}
		}
	}
	return n
}

func (m *floorMap) shortestPath() int {
	locs := make([]int, len(m.locations)-1)
	for idx, _ := range locs {
		locs[idx] = idx + 1
	}
	perms := permutations(locs)
	best := math.MaxInt32
	for _, p := range perms {
		p = append([]int{0}, p...)
		d := m.pathLength(p)
		if d < best {
			best = d
		}
	}
	return best
}

func (m *floorMap) pathLength(p []int) int {
	sum := 0
	for i := 0; i < len(p)-1; i++ {
		sum += (*m).distances[p[i]][p[i+1]]
	}
	return sum
}

func (m *floorMap) findDistances() {
	for _, l := range m.locations {
		seen := make(map[point]bool)
		queue := list.New()
		queue.PushBack(searchPoint{l.p, 0})
		seen[l.p] = true
		bfs(m, queue, &seen, l.locationNum)
	}
}

func bfs(m *floorMap, q *list.List, seen *map[point]bool, location uint) {
	elt := q.Front()
	if elt == nil {
		return
	}
	curr := elt.Value.(searchPoint)
	q.Remove(elt)

	n, prs := m.nodes[curr.p]
	if prs {
		if n.kind == Location {
			num := int(n.locationNum)
			m.distances[location][num] = curr.depth
		}

		neighbors := curr.neighbors()
		for _, neigh := range neighbors {
			neighNode, neighPrs := m.nodes[neigh]
			if neighPrs {
				if neighNode.kind != Wall {
					_, seenPrs := (*seen)[neigh]
					if !seenPrs {
						q.PushBack(searchPoint{neighNode.p, curr.depth + 1})
						(*seen)[neigh] = true
					}
				}
			}
		}
	}

	bfs(m, q, seen, location)
}

func (m *floorMap) display() {
	for y := 0; y <= m.maxY; y++ {
		for x := 0; x <= m.maxX; x++ {
			p := point{x, y}
			switch m.nodes[p].kind {
			case Wall:
				fmt.Printf("#")
			case Open:
				fmt.Printf(".")
			case Location:
				fmt.Printf("%d", m.nodes[p].locationNum)
			}
		}
		fmt.Printf("\n")
	}
	fmt.Println("Locs:", m.locations)
	fmt.Println("Distances", m.distances)
}

type point struct {
	x, y int
}

type nodeType int

const (
	Wall nodeType = iota
	Open
	Location
)

type node struct {
	p           point
	kind        nodeType
	locationNum uint
}

func createMap(input string) floorMap {
	lines := splitInput(input)
	n := make(floorNodes)
	locs := make([]loc, 0)
	maxY := len(lines) - 1
	maxX := -1
	for y, l := range lines {
		if -1 == maxX {
			maxX = len(l) - 1
		}
		for x, c := range l {
			p := point{x, y}
			switch c {
			case '#':
				n[p] = node{p, Wall, 0}
			case '.':
				n[p] = node{p, Open, 0}
			default:
				i := parseInt(string(c))
				n[p] = node{p, Location, i}
				locs = append(locs, loc{p, i})
			}
		}
	}
	distances := make([][]int, len(locs))
	for idx, _ := range distances {
		distances[idx] = make([]int, len(locs))
	}
	return floorMap{n, maxX, maxY, locs, distances}
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

func permutations(input []int) [][]int {
	var output [][]int
	generate(len(input), input, &output)
	return output
}

func generate(n int, arr []int, output *[][]int) {
	if n == 1 {
		tmp := append([]int(nil), arr...)
		*output = append(*output, tmp)
	} else {
		for i := 0; i < n-1; i++ {
			generate(n-1, arr, output)
			if n%2 == 0 {
				tmp := arr[i]
				arr[i] = arr[n-1]
				arr[n-1] = tmp
			} else {
				tmp := arr[0]
				arr[0] = arr[n-1]
				arr[n-1] = tmp
			}
		}
		generate(n-1, arr, output)
	}
}

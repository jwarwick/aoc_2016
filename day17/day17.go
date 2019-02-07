package main

import (
	"container/list"
	"crypto/md5"
	"fmt"
)

func main() {
	input := "dmypynyp"

	part1 := shortestPath(input)
	fmt.Println("Part 1: ", part1)
}

func shortestPath(code string) string {
	queue := list.New()
	queue.PushBack(searchPoint{0, 0, ""})
	return search(&code, queue)
}

func search(code *string, q *list.List) string {
	elt := q.Front()
	if elt == nil {
		return ""
	}
	curr := elt.Value.(searchPoint)
	q.Remove(elt)

	if curr.x == 3 && curr.y == 3 {
		return curr.path
	}

	neighbors := curr.neighbors(code)
	for _, n := range neighbors {
		q.PushBack(n)
	}

	return search(code, q)
}

type searchPoint struct {
	x    int
	y    int
	path string
}

func (p searchPoint) neighbors(code *string) []searchPoint {
	var n []searchPoint
	locked := isLocked(*code + p.path)
	if p.x < 3 && !locked[3] {
		n = append(n, searchPoint{p.x + 1, p.y, p.path + "R"})
	}
	if p.y < 3 && !locked[1] {
		n = append(n, searchPoint{p.x, p.y + 1, p.path + "D"})
	}
	if p.x > 0 && !locked[2] {
		n = append(n, searchPoint{p.x - 1, p.y, p.path + "L"})
	}
	if p.y > 0 && !locked[0] {
		n = append(n, searchPoint{p.x, p.y - 1, p.path + "U"})
	}
	return n
}

func isLocked(code string) []bool {
	result := [4]bool{true, true, true, true}
	sum := md5.Sum([]byte(code))
	result[0] = !unlocked(sum[0] >> 4)
	result[1] = !unlocked(sum[0] & 0x0f)
	result[2] = !unlocked(sum[1] >> 4)
	result[3] = !unlocked(sum[1] & 0x0f)
	return result[:]
}

func unlocked(val byte) bool {
	return val == 0x0b || val == 0x0c || val == 0x0d || val == 0x0e || val == 0x0f
}

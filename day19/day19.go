package main

import (
	"container/list"
	"fmt"
	"math"
)

func main() {
	input := 3004953

	part1 := bestPosition(input, play)
	fmt.Println("Part 1: ", part1)

	part2 := bestPosition(input, playAcross)
	fmt.Println("Part 2: ", part2)
}

func bestPosition(count int, fp func(*list.List) int) int {
	queue := buildQueue(count)
	return fp(queue)
}

func buildQueue(count int) *list.List {
	queue := list.New()
	for i := 1; i <= count; i++ {
		queue.PushBack(i)
	}
	return queue
}

func play(q *list.List) int {
	curr := q.Front()
	for q.Len() > 1 {
		left := nextElf(curr, q)
		curr = nextElf(left, q)
		q.Remove(left)
	}
	last := q.Front()
	return last.Value.(int)
}

func playAcross(q *list.List) int {
	curr := q.Front()
	dist := int(math.Floor(float64(q.Len() / 2)))
	left := curr
	for i := 0; i < dist; i++ {
		left = nextElf(left, q)
	}

	for q.Len() > 1 {
		next := nextElf(left, q)
		q.Remove(left)
		if q.Len()%2 == 0 {
			next = nextElf(next, q)
		}
		left = next

		curr = nextElf(curr, q)
	}
	last := q.Front()
	return last.Value.(int)
}

func nextElf(e *list.Element, q *list.List) *list.Element {
	n := e.Next()
	if n == nil {
		n = q.Front()
	}
	return n
}

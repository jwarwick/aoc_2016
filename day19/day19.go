package main

import (
	"container/list"
	"fmt"
)

func main() {
	input := 3004953

	part1 := bestPosition(input)
	fmt.Println("Part 1: ", part1)
}

type elf struct {
	num      int
	presents int
}

func bestPosition(count int) int {
	queue := list.New()

	for i := 1; i <= count; i++ {
		queue.PushBack(elf{i, 1})
	}
	return play(queue)
}

func play(q *list.List) int {
	curr := q.Front()
	for q.Len() > 1 {
		left := curr.Next()
		if left == nil {
			left = q.Front()
		}
		currElf := curr.Value.(elf)
		leftElf := left.Value.(elf)
		currElf.presents += leftElf.presents
		next := left.Next()
		if next == nil {
			next = q.Front()
		}
		curr = next
		q.Remove(left)
	}
	last := q.Front()
	lastElf := last.Value.(elf)
	return lastElf.num
}

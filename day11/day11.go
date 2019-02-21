package main

import (
	"container/list"
	"fmt"
	"sort"
)

func main() {
	//   The first floor contains a thulium generator, a thulium-compatible microchip, a plutonium generator, and a strontium generator.
	// The second floor contains a plutonium-compatible microchip and a strontium-compatible microchip.
	// The third floor contains a promethium generator, a promethium-compatible microchip, a ruthenium generator, and a ruthenium-compatible microchip.
	// The fourth floor contains nothing relevant.
	// thulium, plutonium, strontium, promethuium, ruthenium
	config1 := []pair{pair{1, 1}, pair{2, 1}, pair{2, 1}, pair{3, 3}, pair{3, 3}}
	part1 := shortestPath(config1)
	fmt.Println("Part 1: ", part1)

	config2 := []pair{pair{1, 1}, pair{2, 1}, pair{2, 1}, pair{3, 3}, pair{3, 3}, pair{1, 1}, pair{1, 1}}
	part2 := shortestPath(config2)
	fmt.Println("Part 2: ", part2)
}

type pair struct {
	chip      int
	generator int
}

type byPair []pair

func (s byPair) Len() int {
	return len(s)
}
func (s byPair) Swap(i, j int) {
	s[i], s[j] = s[j], s[i]
}
func (s byPair) Less(i, j int) bool {
	if s[i].chip < s[j].chip {
		return true
	}
	return s[i].generator < s[j].generator
}

type state struct {
	elevator int
	pairs    []pair
}

func (s state) hash() string {
	tmp := make([]pair, len(s.pairs))
	copy(tmp, s.pairs)
	sort.Sort(byPair(tmp))
	return fmt.Sprintf("%d%v", s.elevator, tmp)
}

func (s *state) neighbors() []state {
	up := s.elevator + 1
	down := s.elevator - 1
	var n []state

	if up <= 4 {
		t := s.transitions(s.elevator, up)
		n = append(n, t...)
	}

	if down >= 1 {
		t := s.transitions(s.elevator, down)
		n = append(n, t...)
	}

	return n
}

func (s *state) transitions(from int, to int) []state {
	var n []state

	for outerIdx := 0; outerIdx < len(s.pairs); outerIdx++ {
		outer := s.pairs[outerIdx]
		// fmt.Println("Outer:", outer)

		if outer.chip == from {
			// fmt.Println("\tChip match")
			tmp := make([]pair, len(s.pairs))
			copy(tmp, s.pairs)
			tmp[outerIdx] = pair{to, outer.generator}
			if validState(tmp) {
				n = append(n, state{to, tmp})
			}
			for innerIdx := outerIdx; innerIdx < len(tmp); innerIdx++ {
				inner := tmp[innerIdx]
				if inner.chip == from {
					tmp2 := make([]pair, len(tmp))
					copy(tmp2, tmp)
					tmp2[innerIdx] = pair{to, inner.generator}
					if validState(tmp2) {
						n = append(n, state{to, tmp2})
					}
				}
				if inner.generator == from {
					tmp2 := make([]pair, len(tmp))
					copy(tmp2, tmp)
					tmp2[innerIdx] = pair{inner.chip, to}
					if validState(tmp2) {
						n = append(n, state{to, tmp2})
					}
				}
			}
		}

		if outer.generator == from {
			// fmt.Println("\tGenerator match")
			tmp := make([]pair, len(s.pairs))
			copy(tmp, s.pairs)
			tmp[outerIdx] = pair{outer.chip, to}
			if validState(tmp) {
				n = append(n, state{to, tmp})
			}
			for innerIdx := outerIdx; innerIdx < len(tmp); innerIdx++ {
				inner := tmp[innerIdx]
				if inner.chip == from {
					tmp2 := make([]pair, len(tmp))
					copy(tmp2, tmp)
					tmp2[innerIdx] = pair{to, inner.generator}
					if validState(tmp2) {
						n = append(n, state{to, tmp2})
					}
				}
				if inner.generator == from {
					tmp2 := make([]pair, len(tmp))
					copy(tmp2, tmp)
					tmp2[innerIdx] = pair{inner.chip, to}
					// fmt.Println("Considering:", tmp2)
					if validState(tmp2) {
						// fmt.Println("\tValid")
						n = append(n, state{to, tmp2})
					}
				}
			}
		}
	}

	// fmt.Println(n)
	return n
}

func validState(pairs []pair) bool {
	for _, p := range pairs {
		if p.chip != p.generator {
			if !noGenerator(p.chip, pairs) {
				return false
			}
		}
	}
	return true
}

func noGenerator(floor int, pairs []pair) bool {
	for _, p := range pairs {
		if p.generator == floor {
			return false
		}
	}
	return true
}

type search struct {
	s     state
	depth int
}

func (s *state) finished() bool {
	if s.elevator != 4 {
		return false
	}
	for _, p := range s.pairs {
		if p.chip != 4 || p.generator != 4 {
			return false
		}
	}
	return true
}

func shortestPath(config []pair) int {
	start := state{1, config}

	queue := list.New()
	queue.PushBack(search{start, 0})

	seen := make(map[string]bool)
	seen[start.hash()] = true

	return bfs(queue, &seen)
}

func bfs(q *list.List, seen *map[string]bool) int {
	elt := q.Front()
	if elt == nil {
		return -1
	}
	curr := elt.Value.(search)
	q.Remove(elt)

	// fmt.Println("\nCurr:", curr)

	if curr.s.finished() {
		return curr.depth
	}

	// if curr.depth >= 5 {
	// 	return -1
	// }

	neighbors := curr.s.neighbors()
	for _, n := range neighbors {
		neighHash := n.hash()
		_, prs := (*seen)[neighHash]
		if !prs {
			(*seen)[neighHash] = true
			q.PushBack(search{n, curr.depth + 1})
		}
	}

	return bfs(q, seen)
}

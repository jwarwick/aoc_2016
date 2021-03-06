package main

import (
	"fmt"
	"io/ioutil"
	"sort"
	"strconv"
	"strings"
)

func main() {
	input, err := ioutil.ReadFile("./input.txt")
	if err != nil {
		panic(err)
	}

	bl := createBlackList(string(input))

	part1 := firstAvailable(&bl, 0, 4294967295)
	fmt.Println("Part 1: ", part1)

	part2 := countAvailable(&bl, 0, 4294967295)
	fmt.Println("Part 2: ", part2)
}

func countAvailable(bl *[]blacklist, min uint, max uint) uint {
	count := 0
	val := min
	idx := 0
	for val <= max {
		if idx >= len(*bl) || val < (*bl)[idx].start {
			count++
		}
		if idx >= len(*bl) {
			val++
		} else {
			val = (*bl)[idx].end + 1
			idx++
		}
	}
	return uint(count)
}

func firstAvailable(bl *[]blacklist, min uint, max uint) uint {
	val := min
	idx := 0
	for {
		if val < (*bl)[idx].start {
			return val
		}
		val = (*bl)[idx].end + 1
		idx++
	}
}

type blacklist struct {
	start uint
	end   uint
}

type byStart []blacklist

func (s byStart) Len() int {
	return len(s)
}

func (s byStart) Swap(i, j int) {
	s[i], s[j] = s[j], s[i]
}

func (s byStart) Less(i, j int) bool {
	return s[i].start < s[j].start
}

func createBlackList(input string) []blacklist {
	lines := splitInput(input)
	bl := make([]blacklist, len(lines))
	for idx, l := range lines {
		start, end := parseLine(l)
		bl[idx] = blacklist{start, end}
	}
	sort.Sort(byStart(bl))
	return merge(bl)
}

func merge(bl []blacklist) []blacklist {
	var merged []blacklist
	merged = append(merged, bl[0])
	prev := bl[0]
	for _, curr := range bl {
		if curr.start >= prev.start && curr.end <= prev.end {
			continue
		} else if curr.start <= prev.end && curr.end > prev.end {
			merged[len(merged)-1].end = curr.end
			prev = merged[len(merged)-1]
		} else {
			merged = append(merged, curr)
			prev = curr
		}
	}
	return merged
}

func parseLine(input string) (start uint, end uint) {
	fields := strings.Split(input, "-")
	start = parseInt(fields[0])
	end = parseInt(fields[1])
	return
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

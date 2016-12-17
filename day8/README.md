# Day8

--- Day 8: Two-Factor Authentication ---

You come across a door implementing what you can only assume is an implementation of two-factor authentication after a long game of requirements telephone.

To get past the door, you first swipe a keycard (no problem; there was one on a nearby desk). Then, it displays a code on a little screen, and you type that code on a keypad. Then, presumably, the door unlocks.

Unfortunately, the screen has been smashed. After a few minutes, you've taken everything apart and figured out how it works. Now you just have to work out what the screen would have displayed.

The magnetic strip on the card you swiped encodes a series of instructions for the screen; these instructions are your puzzle input. The screen is 50 pixels wide and 6 pixels tall, all of which start off, and is capable of three somewhat peculiar operations:

rect AxB turns on all of the pixels in a rectangle at the top-left of the screen which is A wide and B tall.
rotate row y=A by B shifts all of the pixels in row A (0 is the top row) right by B pixels. Pixels that would fall off the right end appear at the left end of the row.
rotate column x=A by B shifts all of the pixels in column A (0 is the left column) down by B pixels. Pixels that would fall off the bottom appear at the top of the column.
For example, here is a simple sequence on a smaller screen:

rect 3x2 creates a small rectangle in the top-left corner:

###....
###....
.......
rotate column x=1 by 1 rotates the second column down by one pixel:

#.#....
###....
.#.....
rotate row y=0 by 4 rotates the top row right by four pixels:

....#.#
###....
.#.....
rotate column x=1 by 1 again rotates the second column down by one pixel, causing the bottom pixel to wrap back to the top:

.#..#.#
#.#....
.#.....
As you can see, this display technology is extremely powerful, and will soon dominate the tiny-code-displaying-screen market. That's what the advertisement on the back of the display tries to convince you, anyway.

There seems to be an intermediate check of the voltage used by the display: after you swipe your card, if the screen did work, how many pixels should be lit?

# Usage

```
  iex(64)> Day8.count_pixels_from_file "input.txt"
  rect: 1, 1
  rotate row: 0, 6
  rect: 1, 1
  rotate row: 0, 3
  rect: 1, 1
  rotate row: 0, 5
  rect: 1, 1
  rotate row: 0, 4
  rect: 2, 1
  rotate row: 0, 5
  rect: 2, 1
  rotate row: 0, 2
  rect: 1, 1
  rotate row: 0, 5
  rect: 4, 1
  rotate row: 0, 2
  rect: 1, 1
  rotate row: 0, 3
  rect: 1, 1
  rotate row: 0, 3
  rect: 1, 1
  rotate row: 0, 2
  rect: 1, 1
  rotate row: 0, 6
  rect: 4, 1
  rotate row: 0, 4
  rotate col: 0, 1
  rect: 3, 1
  rotate row: 0, 6
  rotate col: 0, 1
  rect: 4, 1
  rotate col: 10, 1
  rotate row: 2, 16
  rotate row: 0, 8
  rotate col: 5, 1
  rotate col: 0, 1
  rect: 7, 1
  rotate col: 37, 1
  rotate col: 21, 2
  rotate col: 15, 1
  rotate col: 11, 2
  rotate row: 2, 39
  rotate row: 0, 36
  rotate col: 33, 2
  rotate col: 32, 1
  rotate col: 28, 2
  rotate col: 27, 1
  rotate col: 25, 1
  rotate col: 22, 1
  rotate col: 21, 2
  rotate col: 20, 3
  rotate col: 18, 1
  rotate col: 15, 2
  rotate col: 12, 1
  rotate col: 10, 1
  rotate col: 6, 2
  rotate col: 5, 1
  rotate col: 2, 1
  rotate col: 0, 1
  rect: 35, 1
  rotate col: 45, 1
  rotate row: 1, 28
  rotate col: 38, 2
  rotate col: 33, 1
  rotate col: 28, 1
  rotate col: 23, 1
  rotate col: 18, 1
  rotate col: 13, 2
  rotate col: 8, 1
  rotate col: 3, 1
  rotate row: 3, 2
  rotate row: 2, 2
  rotate row: 1, 5
  rotate row: 0, 1
  rect: 1, 5
  rotate col: 43, 1
  rotate col: 31, 1
  rotate row: 4, 35
  rotate row: 3, 20
  rotate row: 1, 27
  rotate row: 0, 20
  rotate col: 17, 1
  rotate col: 15, 1
  rotate col: 12, 1
  rotate col: 11, 2
  rotate col: 10, 1
  rotate col: 8, 1
  rotate col: 7, 1
  rotate col: 5, 1
  rotate col: 3, 2
  rotate col: 2, 1
  rotate col: 0, 1
  rect: 19, 1
  rotate col: 20, 3
  rotate col: 14, 1
  rotate col: 9, 1
  rotate row: 4, 15
  rotate row: 3, 13
  rotate row: 2, 15
  rotate row: 1, 18
  rotate row: 0, 15
  rotate col: 13, 1
  rotate col: 12, 1
  rotate col: 11, 3
  rotate col: 10, 1
  rotate col: 8, 1
  rotate col: 7, 1
  rotate col: 6, 1
  rotate col: 5, 1
  rotate col: 3, 2
  rotate col: 2, 1
  rotate col: 1, 1
  rotate col: 0, 1
  rect: 14, 1
  rotate row: 3, 47
  rotate col: 19, 3
  rotate col: 9, 3
  rotate col: 4, 3
  rotate row: 5, 5
  rotate row: 4, 5
  rotate row: 3, 8
  rotate row: 1, 5
  rotate col: 3, 2
  rotate col: 2, 3
  rotate col: 1, 2
  rotate col: 0, 2
  rect: 4, 2
  rotate col: 35, 5
  rotate col: 20, 3
  rotate col: 10, 5
  rotate col: 3, 2
  rotate row: 5, 20
  rotate row: 3, 30
  rotate row: 2, 45
  rotate row: 1, 30
  rotate col: 48, 5
  rotate col: 47, 5
  rotate col: 46, 3
  rotate col: 45, 4
  rotate col: 43, 5
  rotate col: 42, 5
  rotate col: 41, 5
  rotate col: 38, 1
  rotate col: 37, 5
  rotate col: 36, 5
  rotate col: 35, 1
  rotate col: 33, 1
  rotate col: 32, 5
  rotate col: 31, 5
  rotate col: 28, 5
  rotate col: 27, 5
  rotate col: 26, 5
  rotate col: 17, 5
  rotate col: 16, 5
  rotate col: 15, 4
  rotate col: 13, 1
  rotate col: 12, 5
  rotate col: 11, 5
  rotate col: 10, 1
  rotate col: 8, 1
  rotate col: 2, 5
  rotate col: 1, 5
  116
```

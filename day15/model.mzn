%% Advent of Code 2016, Day 15
%% Align the discs

int: n;
array[1..n] of int: positions;
array[1..n] of int: starts;

var int: t;

constraint t > 0;

constraint forall (d in 1..n)
  (0 = (t + d + starts[d]) mod positions[d]);

solve minimize t;

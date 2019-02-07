%% Advent of Code 2016, Day 15
%% Align the discs

int: n;
array[1..n] of int: positions;
array[1..n] of int: starts;

var 0..1000000: t;

constraint forall (d in 1..n)
  (0 = (t + d + starts[d]) mod positions[d]);

solve minimize t;

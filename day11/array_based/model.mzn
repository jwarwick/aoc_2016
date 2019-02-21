%% Advent of Code 2016, Day 11
%% Determine a valid series of steps to get everything to the top floor
include "globals.mzn";

int: num_items;
set of int: ITEMS = 1..num_items;
constraint assert(length(chip_start) = length(generator_start), "Requires same number of Chips and Generators");

set of int: FLOORS = 1..4;
array[ITEMS] of FLOORS: chip_start;
array[ITEMS] of FLOORS: generator_start;

int: max_steps;
set of int: MAX_STEPS = 1..max_steps;
array[MAX_STEPS] of var FLOORS: elevator;
array[MAX_STEPS, ITEMS] of var FLOORS: chips;
array[MAX_STEPS, ITEMS] of var FLOORS: generators;

var MAX_STEPS: steps;

%% Initialize state
constraint elevator[1] = 1;
constraint forall (m in ITEMS) (chips[1, m] = chip_start[m]);
constraint forall (g in ITEMS) (generators[1, g] = generator_start[g]);

%% End when all items are on the 4th floor
constraint elevator[steps] = 4;
constraint forall (m in ITEMS) (chips[steps, m] = 4);
constraint forall (g in ITEMS) (generators[steps, g] = 4);

%% Elevator can only move to adjacent floors
constraint forall (s in 2..steps) (elevator[s] = elevator[s-1] + 1 \/ elevator[s] = elevator[s-1] - 1);

%% Only move 2 items at a time
constraint forall (s in 2..steps)
  ((sum([1 | m in ITEMS where elevator[s-1] = chips[s-1, m] /\ elevator[s] = chips[s, m]])
    + sum([1 | g in ITEMS where elevator[s-1] = generators[s-1, g] /\ elevator[s] = generators[s, g]]))
   <= 2);

%% Only the floor with the elevator can have new items
%% and those items must come from the previous and current elevator floors
constraint forall (s in 2..steps, m in ITEMS)
  (chips[s-1, m] != chips[s, m] -> chips[s-1, m] = elevator[s-1] /\ chips[s, m] = elevator[s]);

constraint forall (s in 2..steps, m in ITEMS)
  (generators[s-1, m] != generators[s, m] -> generators[s-1, m] = elevator[s-1] /\ generators[s, m] = elevator[s]);

%% Need to have one item in the elevator at all times
constraint forall (s in 2..steps)
  (exists (m in ITEMS) (elevator[s-1] = chips[s-1, m] /\ elevator[s] = chips[s, m])
   \/ 
   exists (g in ITEMS) (elevator[s-1] = generators[s-1, g] /\ elevator[s] = generators[s, g]));

%% Don't allow microchips with generators on the same floor as other generators
constraint forall (s in 1..steps, m in ITEMS)
  (chips[s, m] != generators[s, m] -> 0 = count(row(generators, s), chips[s, m]));

solve minimize steps;

output ["Chips:\n" ++ show2d(chips) ++ "\n"];
output ["Generators:\n" ++ show2d(generators) ++ "\n"];
output ["Elevator:\n" ++ show(elevator) ++ "\n"];
output ["Steps: \(steps-1)\n"];

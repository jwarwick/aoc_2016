%% Advent of Code 2016, Day 11
%% Determine a valid series of steps to get everything to the top floor
include "globals.mzn";

enum Items;
int: item_count = card(Items);
set of Items: Generators;
set of Items: Microchips;
array[Items] of Generators: mappings;

set of int: Floors = 1..4;
array[1..4] of set of Items: start;

set of int: MAX_STEPS = 1..20;
array[MAX_STEPS, Floors] of var set of Items: state;
array[MAX_STEPS] of var Floors: elevator;

var MAX_STEPS: steps;

%% Initialize state
constraint forall (f in Floors)
  (state[1, f] = start[f]);

%% Each step should have the same number of Items
constraint forall (s in 1..steps)
  (item_count = card(array_union(row(state, s))));

%% No overlapping items on a step
constraint forall (s in 1..steps)
  (forall (i in Items)
   (1 = sum(f in Floors)(i in state[s, f])));

%% Map elevator array to Elevator in state sets
constraint forall (s in 1..steps) (Elevator in state[s, elevator[s]]);
%% Elevator can only move to adjacent floors
constraint forall (s in 2..steps) (elevator[s] = elevator[s-1] + 1 \/ elevator[s] = elevator[s-1] - 1);

%% Only move 2 items at a time (plus the Elevator)
constraint forall (s in 2..steps, f in Floors)
  (if elevator[s] = f \/ elevator[s-1] = f then 
   card(state[s,f]) <= card(state[s-1, f]) + 3 /\
   card(state[s,f]) >= card(state[s-1, f]) - 3
   else
   state[s,f] = state[s-1,f]
   endif
  );

%% Only the floor with the elevator can have new items
%% and those items must come from the previous and current elevator floors
constraint forall (s in 2..steps, f in Floors)
  (if elevator[s] = f then
   state[s, f] subset (state[s-1,f] union state[s-1, elevator[s-1]])
   else
   state[s, f] subset state[s-1, f] endif);

%% Need to have one item in the elevator at all times
constraint forall (s in 2..steps, f in Floors)
 (Elevator in state[s,f] -> card(state[s, f] intersect state[s-1, elevator[s-1]]) > 1);

%% Don't allow microchips with generators on the same floor as other generators
constraint forall (s in 1..steps, f in Floors)
  (forall (m in Microchips)
   ((m in state[s, f] -> mappings[m] in state[s, f]) \/ {} = Generators intersect state[s, f]));

%% End when all items are on the 4th floor
constraint card(state[steps, 4]) = card(Items);

solve minimize steps;

output [show(state[i, f]) ++ if f == 4 then "\n" else " " endif | i in 1..fix(steps), f in Floors] ++ ["\n"];
output ["Elevator = ["] ++ [show(elevator[i]) ++ " " | i in 1..fix(steps)] ++ ["]\n"];
output ["Steps = \(steps - 1)\n"];

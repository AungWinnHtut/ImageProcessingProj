function y = runcode(x)
% Find a zero run in the run-length table. If not found, create a
% new entry in the table. Return the index of the run.

global RUNS
y = find(RUNS == x);
if length(y) -= 1
	RUNS = [RUNS; x];
	y = length(RUNS);
end
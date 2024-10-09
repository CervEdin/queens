include "globals.mzn";

%-------------------------------------------------------------------------------
%  Parameters
%-------------------------------------------------------------------------------

int: n;
enum color;
array[rows, cols] of color: board;

set of int: queens = 1..n;
set of int: rows = 1..n;
set of int: cols = 1..n;

%-------------------------------------------------------------------------------
%  Variables
%-------------------------------------------------------------------------------

% The row/column of each queen (implies queens are on different rows)
array[rows] of var cols: Q;

%-------------------------------------------------------------------------------
%  Constraints
%-------------------------------------------------------------------------------

% All queens must be in the different columns
constraint all_different(Q);

% Queens cannot touch on the diagonal
constraint forall(i in 1..n, j in 1..n where j == i + 1)
  ( Q[i] + 1 != Q[j] /\ Q[i] - 1 != Q[j] );

% For each color, there must be exactly one queen
constraint forall(c in color)
  ( count(i in rows, j in cols where c == board[i,j]) (Q[i] == j) == 1 );

%-------------------------------------------------------------------------------
%  Printing the solution
%-------------------------------------------------------------------------------

function string: solution(array[rows] of cols: Q) =
  let {
    array[rows, cols] of string: sol =
      [
        (i,j): if Q[i] == j then "👑"  else show(c) endif
        | i in rows, j in cols, c=board[i,j]
      ],
  } in
  join("\n", [ join("", sol[i,..]) | i in rows ]);

output solution(fix(Q));

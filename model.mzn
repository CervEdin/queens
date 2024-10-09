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

array[rows] of var cols: Q;  % Q[i] is the column where the queen in row i is placed
array[rows] of var color: assigned_colors;  % assigned_colors[i] is the color of the queen in row i

%-------------------------------------------------------------------------------
%  Constraints
%-------------------------------------------------------------------------------

% Ensure no two queens are in the same column
constraint alldifferent(Q);

% Ensure queens on the same diagonal are not adjacent
constraint
  forall(i, j in rows where i != j) (
    (abs(Q[i] - Q[j]) == abs(i - j)) -> abs(Q[i] - Q[j]) > 1
  );

% Ensure exactly one queen per color
constraint alldifferent(assigned_colors);

% Assign each queen the corresponding color from the board
constraint
  forall(i in rows) (
    assigned_colors[i] = board[i, Q[i]]
  );

%-------------------------------------------------------------------------------
%  Printing the solution
%-------------------------------------------------------------------------------

function string: solution(array[rows] of cols: Q, array[rows] of color: assigned_colors) =
  let {
    array[rows, cols] of string: sol =
      [
        (i,j): if Q[i] == j then "👑"  else show(c) endif
        | i in rows, j in cols, c=board[i,j]
      ],
  } in
  join("\n", [ join("", sol[i,..]) | i in rows ]);

output [ solution(fix(Q), fix(assigned_colors)) ];

f:read0`:input.txt;
instructions:([] d: first each f; l:"J"$2 _'f);
// lazy way of finding grid diameter 
g:2*exec max l from select sum l by d from instructions;

// define move function
move:{[dir;sign;dis;pos]
        @[pos;dir;+;sign*dis]
          };
R: move[1;1];
L:move[1;-1];
U:move[0;-1];
D:move[0;1];

// splits into individual move instructions
getMoves:{[pos;inp]
    m:max abs d:(inp-pos);
   pos+\ m# enlist 0^d%m
 };

// grid  - .g namespace for global
.g.grid: g#'g#0;
.g.gridT:.g.grid;
.g.grid0:.g.grid;
// is tail on the board 
.g.t:0b;
// initial 
.g.i:i:`long$(count[.g.grid]%2;count[.g.grid]%2);
.g.grid:.[.g.grid;i;:;1];
// first instruction
ins: value each instructions;

runGrid:{
    .at.x:x;.at.y:y;
    .[`.g.grid;x;:;0i];
    .[`.g.grid;y;:;1i];
    .g.i:y;
    // check if any T  is touching 
    if[0b~.g.t; 
        .[`.g.gridT;x;:;1];
        .[`.g.grid0;x;+;1];
        .g.t:x;
        :.g.i
        ];
    // check around
   if[0 = sum .[.g.gridT;] each .g.i +/:   ff cross  ff:(-1 + til 3);
                .[`.g.gridT;.g.t;:;0];
                .[`.g.gridT;x;:;1];
                .[`.g.grid0;x;+;1];
                .g.t:x
    ];
    .g.i
 }

runP1:{[it] 
    0N!it;
    .at.it:it;
    moves:`long$enlist[.g.i],getMoves[.g.i;(value[it])[.g.i]]   ;
    runGrid/[moves]
 } each ins


sum (raze .g.grid0)>0;



// Part 2 with multiple grids - below is general solution, need to remove above
.f.grid:til[10]!10#enlist (g#'g#0);
.f.t:(enlist[::]!enlist[::]),(til 10)!10#0b;
.f.t:(til 10)!10#enlist `long$(count[.f.grid 0]%2;count[.f.grid 0 ]%2);
.f.grid[;`long$count[.f.grid 0]%2; `long$count[.f.grid 0]%2]:1;
.f.grid0: .f.grid;

runInstruction:{
    0N!"Moving from [",.Q.s1[x], "] to: [", .Q.s1[y],"]";
    .at.x:x;.at.y:y;
     .f.grid[0]:.[.f.grid[0];x;:;0];
     .f.grid[0]:.[.f.grid[0];y;:;1];
     .f.t[0]:y;
    // check if any T  is touching 
    {[i]
        0N!"Checking body number: [",.Q.s1[i],"]";
        if[0 = sum .[.f.grid[i];] each  .f.t[i-1] +/:   ff cross  ff:(-1 + til 3);
                    // remove old grid
                    .f.grid[i]:.[.f.grid[i];.f.t[i];:;0];
                    // new move - max ever move is 1 l/r + 1 u/d
                    .f.t[i]:.f.t[i] + -1|1&.f.t[i-1]-.f.t[i];
                    .f.grid[i]:.[.f.grid[i];.f.t[i];:;1];
                    .f.grid0[i]:.[.f.grid0[i];.f.t[i];+;1];
        ]
    } each 1 _ til 10;

   .f.t[0]
    };

runAllInstructions:{[it]
    0N!"Running Instruction: ", .Q.s1 `$raze string it;
    moves:`long$enlist[.f.t 0],getMoves[.f.t 0 ;(value[it])[.f.t 0 ]];
    runInstruction/[moves]
 
 }


ins: value each instructions;

runAllInstructions each ins;
sum (raze .f.grid0[9])>0
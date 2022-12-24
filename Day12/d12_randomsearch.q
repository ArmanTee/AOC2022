f:read0`:input.txt;


// plan
// assign numerican values to grid
S:(where r:"S" in/:f),(raze where each  "S" = f);
E:(where r:"E" in/:f),(raze where each  "E" = f);
.g.grid:(.Q.a!m:til count .Q.a) f;
.[`.g.grid;S;:;0];
.[`.g.grid;E;:;max m];
grid:.g.grid;

path: (h:count[grid])#enlist (l:first[count each grid])#0b;
score:(h:count[grid])#enlist (l:first[count each grid])#1f;
path:.[path;S;:;1b];
blocklist:path;
/ p - current position
p:S;
args:(`grid`path`blocklist`p`p1`end`outcome`deadend`hl`score`counter`outcomePath`bestPath)!(.g.grid;(h:count[grid])#enlist (l:first[count each grid])#0b;(h:count[grid])#enlist (l:first[count each grid])#();S;S;E;0b;0b;-1+(h,l);(h:count[grid])#enlist (l:first[count each grid])#1f;0;()!();0n);

// try random route
// if make it from S to E, save route and end 
// if path has to go back to where it has already been, end and try again
// if previously been on a grid cell and is dead end, dont go on it again
runMultiGrid:{[args]
    path: (h:count[args`grid])#enlist (l:first[count each args`grid])#0b;
    path:.[path;S;:;1b];
    p:S;
    args[`path]:path;
    args[`p]:p;
    args[`p1]:p;
    args[`deadend]:0b;
    args[`outcome]:0b;
    args[`counter]+:1;
    0N!"running: ",.Q.s1 args`counter;
    res:runOneGrid/[args];
    args[`lastPath]:res`path;
    args[`blocklist]:res`blocklist;
    args[`bestPath]:res`bestPath;
    $[not res`outcome;
    [
        /0N!"dead end, updating scores for next run ";
        /args[`score]: 0.1 | args[`score]-0.1*res`path;
    ];
    [
        /0N!"Outcome found, updating scores ";
        /args[`score]:  args[`score]+0.1*res`path;
        0N!"Outcome Length: ",string  pp:(sum/)res`path;
        args[`bestPath]:pp^args[`bestPath];
        $[pp < args[`bestPath];
            [args[`bestPath]:pp;
            args[`score]:  args[`score]+0.5*res`path;
            ];
            /args[`score]:  0.1 | args[`score]-0.1*res`path
        ];
        /args[`outcomePath],: enlist[args`counter]!enlist res`path2
    ]
    ];
    args
 };

// randomly pick from list, porportional to a weighting 
randomBasedOnScore:{[args;i]
     rand raze (floor 100*c%sum c:.[args`score;] each i)#\:i
 };

runOneGrid:{[args]
    // for convergence
   if[any args[`deadend`outcome];:args];
    // check surrounding tiles are eligable to step on and aren't out of bounds.
   eligable:  ./:[args`grid; dir:(args`hl)&/:0 | args[`p]+/:(0 1; 0 -1; 1 0;-1 0)  ] <= 1+(args[`grid] . args[`p]);
   prevStep:  not  ./:[args`path; dir];
   notBlocked: not any  dir~\:/:  args[`blocklist] . args`p;

   if[any match:args[`end] ~/: dir where eligable;
        /0N!" #### Found end, exiting: " show args`path;
        args[`path]:.[args[`path];raze dir where match;:;1b];
        args[`outcome]:1b;
        :args];
   // randomly select new move 
   $[any e:all (eligable;prevStep;notBlocked);
        [
        /np:rand dir where e;
        np: randomBasedOnScore[args;dir where e];
        args[`path]:.[args[`path];np;:;1b];
        args[`p1]:args`p; // previous position
        args[`p]:np;
        :args
        ];
        [
        args[`deadend]:1b;
        /0N!"deadend reached";
        /show @[args[`blocklist];args`p1;,;p];
        args[`blocklist]:.[args[`blocklist];args`p1;,;enlist args`p];
        :args
        ]
    ]
    };   

res:runMultiGrid/[15000;args]
  
\
runRecursive:{[args]
    if[100<args`counter;
        0N!"hit limit, exiting:";   
        :args
    ];
    res:runOneGrid[args;0];
    args[`counter]+:1;
    if[not res`outcome;
        0N!"dead end, updating scores and running again";
        args[`score]: 0.1 | args[`score]-0.1*res`path;
        .z.s[args]
    ];
    0N!"Outcome found, updating scores ";
    args[`score]: 5 | args[`score]+0.5*res`path;
    0N!"Current best path is length: ", 1+(sum/)res`path;
    .z.s[args]
 };

score: res`score
save `score.csv
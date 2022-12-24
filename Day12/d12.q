f:read0`:input.txt;
/f:read0`:input2.txt;
S:(where r:"S" in/:f),(raze where each  "S" = f);
E:(where r:"E" in/:f),(raze where each  "E" = f);
/terrain in numerical form
grid:(.Q.a!m:til count .Q.a) f;
h:count[grid];
l:first[count each grid];
/ nodes
n:((til h) cross til l);

/ list of nodes
list:([n:n] dist:count[n]#0w; prv:count[n]#(); visited:0b );
list[S;`dist]:0f;
.[`grid;S;:;0];
.[`grid;E;:;max m];
hl:h,l;
args:(`grid`list`S`E`finished`hl)!(grid;list;S;E;0b;hl);


runLoop:{[args]
// first viist - shortest distance 
 nv:exec first n from (0!args`list) where not visited, dist = min dist;
 dv:args[`list;nv;`dist];
 eligable:  ./:[args`grid; dir:(args`hl)&/:0 | nv+/:(0 1; 0 -1; 1 0;-1 0)  ] <= 1+(args[`grid] . nv);
 unvisited:dir in exec distinct n from args`list where not visited;
 nu:dir where all (eligable;unvisited);
 args[`list]:update dist: 1+dv, prv:count[i]#enlist nv from args`list where n in nu, dist > dv+1;
 args[`list;nv;`visited]:1b;
 if[all exec visited from args`list;
    args[`finished]:1b
    ];
  :args
    };
/ run while loop, once finished it ends.
res:runLoop/[{x[`finished] ~ 0b};args];
// part 1

// part 2 try with different starting and find lowest
n0:where 0 = ((exec n from  args[`list])!{args[`grid] . x}each exec n from  args[`list]);

// kinda cheating but we only need to look at first column, the rest cant be climbed
n0:n0 where last each n0 = 0;

findCustomStart:{[args;st]
    0N!"looking at starting point: ",.Q.s1 st;
    args[`list]: update dist:0w, visited:0b, prv:() from args[`list];
    args[`list;st;`dist]:0f;
    res:runLoop/[{x[`finished] ~ 0b};args];
    res[`list;E;`dist]
 };

res1:findCustomStart[args;] peach n0 where last each n0 = 0;
min res1

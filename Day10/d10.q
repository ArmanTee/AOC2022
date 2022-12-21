f:read0`:input.txt;
noop:(enlist 1 0);
addx:{((1 0);(1, x))};
res:value each f;
t:flip `ind`val!flip raze res;
t: update val:1 from t where i = 0;
t:update sval: sums val, ind: sums ind from t;

// part 1
select sum ind*sval from (update ind:i+2 from t) where ind in 20 60 100 140 180 220;

// part 2
// greate grid
.g.t: update val: 0 from  (update ind-1 from t) where i = 0;
.g.t: update ind2:raze (`long$count[t]%40)#enlist til 40 from .g.t;
.g.grid: 500#0b;
.g.grid[0 1 2]:1b;
.g.row:();

// check grid @ 0
{[x]
    .at.x:x;
    $[.g.grid[x`ind2]; 
        .g.row,:"#";
        .g.row,:"."
    ];
    .g.grid: count[.g.grid]#0b;
    .g.grid[0 | (-1 0 1 + x`sval)]:1b;
} each .g.t

40 cut .g.row

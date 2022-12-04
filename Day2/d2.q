f:read0`:input.txt;
/  A= X = ROCK
/  B = Y = PAPER
/  C = Z = SCISSORS
s:`X`Y`Z!1 2 3;
k:{$[y~x 0;3;y~x 1;6;0]+s y};
A:k[r:key s];
B:k[1 rotate r];
C:k[r3:2 rotate r];
// Part 1
sum(value').[f;(::;1);:;"`"];
// Part 2
An:`X`Y`Z!(r3);
Bn:r!r;
Cn:r!`Y`Z`X;
sum(value')(2#'f),'((1#'f),\:"n`"),'-1#'f


f:read0`:input.txt;
p:(.Q.a,.Q.A)!1+til 52;
a:cut'["i"$(count@'f)%2;f];
// Part 1
sum p(first').'[inter;a]
// Part 2
sum p(first')((inter/)') 3 cut f

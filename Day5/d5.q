f:read0`:input.txt;
// Part 1
d:("J"$'first each s)!1_'s:(reverse')trim(flip 9#f)[1+4*til 9];
fn:{x[y 2],:z neg[y 0]#x[y 1];
    x[y 1]:neg[y 0]_x[y 1];
    x};
i:value each ltrim (10_f) except\: .Q.a,.Q.A;

k:fn[;;reverse]/[d;i]
/part 1
0N! value last each k;
/part 2 - no need to reverse
j:fn[;;::]/[d;i];
0N! value last each j;
f:read0`:input.txt;
// different methods for part 1 and 2 - would be good to go back and consolidate.
// for part 1 we add +1 to eveyrthing because we end up padding with 0s on the border
k:k0:{get rtrim raze x}each f,''" ";
k:k+1;
// fs is the transformation applied to the matrix, fi is the inverse transform 
fs: (::;reverse;{ flip x} ;{reverse flip x});
fi:(::;reverse;{ flip x} ;{ flip reverse x});
// part 1  - use maxs to get highest point - pad with 0
o:any fi@'{x > -1_flip 0,'flip (maxs x) } each  fs@\:k;

(sum/) o

// Part 2 - functions applied to whole on the whole matrix
fs: (::;{reverse each x };{ flip  x} ;{reverse each flip  x});
fi:(::;{reverse each x};{ flip  x} ;{ flip reverse each  x});
// main part is the ?0b below, which for each item in the list, looks for where the first instance of where the item we're looking at is smaller than the list
max raze prd fi@'{if[0 = count x;:0]; count[c]^1+sums[l] (l:last[x]> c:reverse -1_x)?0b} @'''{(flip (1+til count[x]) #'\:x)}'[fs@\:k0]


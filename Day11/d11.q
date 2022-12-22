f:read0`:input.txt;
// number of monkeys
resetGrid:{
    `c set count ins:7 cut f;
    .m.items:(til c)! value each 18 _ 'ins[;1];
    .m.op: (til c)!value each "{",'(ssr[;"old";"x"] each 19 _ 'ins[;2]),'"}";
    .m.op2:{floor x%3};
    .m.op3:{x mod (prd .m.mod)};
    .m.test:(til c)!{{0 =y mod x}[x]} each .m.mod:value each 21 _ 'ins[;3];
    .m.n:()!();
    .m.n[1b]:(til c)!value each 29_' ins[;4];
    .m.n[0b]:(til c)!value each 30_' ins[;5];
    .m.c:(til c)! c#0;
    };

multiRound:{[inspect;x;y]
    runRound[inspect] each til x
 };

runRound:{[inspect;x]
    if[0<count .m.items[x];
        inspect[x;] each til count .m.items[x];
    ];
 };

inspect:{[x;i]
     oldList:.m.items[n:.m.n[.m.test[x] l:.m.op2 .m.op[x] .m.items[x]0] x];
    .m.items[n]: oldList,l;
    .m.items[x]:1 _ .m.items[x];
    .m.c[x]+:1;
 };
resetGrid[];
multiRound[inspect;c;] each til 20;
prd value 2#desc .m.c

// part 2
// modulo arithmetic required to stop numbers from blowing up and getting too large 
// I found this trick in online discussion but it makes sense if we understand that 
/ x mod y == (x mod n*y) mod y
/ if we store instead x mod n*y, rather than x we can stop numbers blowing up
/ so we find n*y - where n can be whatever multiple, as long as n*y = constant 
/ if we find the product of all the test values eg prd[11 7 3 5 17 13 19 2] we canfind the constant n*y.
/ interestingly example 
/ 1000 mod 23 = 11
/ (1000 mod 46) mod 23 = 11
/ regardless of operation applied e.g if we store 1000 and add something to after, 
/  the modulo test will be the same as if we did the modulo output on the  x mod  n*y
/(19+1000) mod 23 = 7
/(19+1000 mod 46) mod 23 =7

inspect2:{[x;i]
     oldList:.m.items[n:.m.n[.m.test[x] l:.m.op3 .m.op[x] .m.items[x]0] x];
    .m.items[n]: oldList,l;
    .m.items[x]:1 _ .m.items[x];
    .m.c[x]+:1;
 };
resetGrid[];
multiRound[inspect2;c;] each til 10000

prd value 2#desc .m.c

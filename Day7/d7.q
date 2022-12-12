f:read0`:input.txt;
f: ssr[;"dir ";"dir `"] each f;
f: ssr[;"cd ";"cd `"] each f;
f: ssr[;"$ ";""] each f;
f[i]:ssr[;".";"_"] each f[i:where  f like ("[0-9]*")];
f[i]:"add . `",/: ssr[;" ";" `"] each"`" sv' " " vs' f[i:where not any f like/: ("dir*";"cd*";"ls*")];
.gl.f:();
`.r set (`symbol$())!();
`.v set (`symbol$())!();
root:`.r;
add:{[sz;fi;root]  (f:` sv root, fi) set "F"$string sz;.gl.f,:f;root};
cd:{[d;root] $[d ~ `..; ` sv -1 _ ` vs root; ` sv root,d]};
ls:{[root] root};
dir::{[x;y]y};
files:{[root;ins]value[ins]root}\[root;1_f];

{[file]
    {x set @[get;x;0]+get y}[;file] each
     -1 _ (`$".v.",/:ssr[;".";"-"] each string (.Q.dd\[1 _ ` vs  file]))

    } each .gl.f;

// part 1
sum .v where .v <= 100000;

// part 2 - how much needs to be free 
j:(sum .v  key[.v] where not  key[.v] like "*-*")-40000000;

min  .v where .v >=  j


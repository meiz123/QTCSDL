let a =3
let b=4
let c=4
if (a==b==c)
    console.log("Tam giac deu")
else if ((a==b & b!=c)|| (a==c &c!=a)|| (b==c&c!=a))
    console.log("Tam giac can")
else
    console.log("Tam giac thuong")
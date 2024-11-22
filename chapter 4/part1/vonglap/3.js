let array =[1,2,3,4,5,6,7,8,9]
let s=0
for (const i of array)
{
    if (i%2!=0)
        s=s+i
}
console.log("tong cac so le trong mang la: "+s)
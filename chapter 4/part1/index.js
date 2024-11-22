const  m=[1,-2,0,3,-3,5,8,-6]
demSoDuong=(m)=>
{
s=0
for (let i in m) if (m[i]>0)
s++
return s
}
console.log("So phan tu duong: " + demSoDuong(m))

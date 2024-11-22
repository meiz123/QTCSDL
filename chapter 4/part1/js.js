const mang = [5, -10, 3, 4, 8, 11, -2];

function tinhtbc (mang){
    let dem = 0
    let tong=0
    let avg = 0
    for (let i in mang) {
        if (mang[i] % 2 == 0) {
          dem++
          tong += mang[i]
        }
        if (mang[i] == 5) {
          mang[i] = 10
        }
      }
    return dem
}
console.log("So phan tu duong: " + demSoDuong(mang))

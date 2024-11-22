const mang = [5, -10, 3, 4, 8, 11, -2];


const DemSoChan = (mang) => {
  let dem = 0;
  for (let i in mang) {
    if (mang[i] % 2 == 0) {
      dem++;
    }
  }
  return dem;
};

console.log("So phan tu chan: " + DemSoChan(mang));

let z = DemSoChan(mang);

const tinhtb = (mang) => {
  let dem=0
  let avg = 0;
  let tong=0
  for (let i in mang) {
    if (mang[i] % 2 == 0) {
      tong=tong+mang[i]
      dem=dem+1
    }
  }
  avg=tong/dem
  return avg
};
console.log("TBC: " + tinhtb(mang));

const thaythe = (mang) => {
  for (let i in mang) {
    if (mang[i] == 5) {
      mang[i] = 10;
    }
  }
  return mang
};
console.log("ket qua : " + thaythe(mang));

const them = (mang) => {
  mang.push(10,11,12)
  return mang
};
console.log("mang sau khi them: " + them(mang));
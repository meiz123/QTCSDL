/*---------------------------------------------HÀM------------------------------------------------------*/
function sum(x, y = 5) {
    console.log(x + y)
    }
let x=sum(5,1)
console.log(x)
//boolen
function isEven(number){

    return number % 2 === 0 ? true : false;
}
console.log(isEven(12))
/*---------------------------------------------MẢNG------------------------------------------------------*/
//push: thêm phần tử vào mảng 
//pop: xoá phần tử khỏi mảng
//unshift(): thêm phần tử vào đầu mảng
//indexOf() được sử dụng để tìm vị trí xuất hiện đầu tiên của một phần tử hoặc một chuỗi con trong một mảng hoặc một chuỗi.
let numbers=[3,2,1,4,6,5]
let index=numbers.indexOf(2)
console.log(index)
console.log(numbers.sort())
console.log(numbers.sort().reverse())
//Duyệt các phần tử trong mảng
for (let num of numbers){
    console.log(num)
}
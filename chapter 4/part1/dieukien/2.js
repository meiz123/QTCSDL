let year =2000
if(year % 4 ==0)
    {
        if (year % 100 !=100)
            console.log('Nam nhuan')
        else
            console.log('Nam khong nhuan')
    } 
else if (year % 4 ==400)   
    console.log ('Nam nhuan')
else 
    console.log('Nam khong nhuan')
--Xem ngày hiện tại
Select getdate()
--Tính khoảng cách ngày , tháng , năm
Select DATEDIFF(month,'2021-05-25',getdate())
--Lấy ra ngày , tháng, năm trong getdate
Select month(getdate())
--depart(day, month, year, week, Hour, second, minute)
Select datepart(week, getdate())
--thêm ngày, tháng, năm....
 Select dateadd(day,4,getdate())
 --isdate : kiểm tra đúng, sai
 Select isdate ('2023-09-20')

 Select left('bis.net.vn',3)
 Select right('bis.net.vn',3)
 Select substring('bis.net.vn',3,3)
 Select len('bis.net.vn')
 Select str(123) + ' Nguyen Hue,Da Nang,Vn'
 Select concat('123',' Nguyen Hue',' Da Nang',' Vn')
 Select replace('bis.net.vn','.','_')
 --Lặp lại
 Select REPLICATE('bis.net.vn',10)
 --
 Select UPPER('bis.net.vn')
 /*
 rtrim, ltrim, lower, upper
 3. numberic functions
 max, min
 sum, AVG, count
 round, sqrt, square
 */
 --
 Select * from Orders
 Select [Product ID],Count(*) as  Order_count,
 max (Sales) as Sales_max, 
 min(Sales) as Sales_min,
 Sum(Sales) as Sales_sum,
 AVG(Sales) as Sales_AVG
 from Orders
 group by [Product ID]
 --
 Select round(123.756,2)

 -- set operation: union, except, intersect 
 --join tables :inner, outer,cross,seft
 --subquery
use Global_Superstore
Select * from Orders
alter table Orders
ADD ShippingStatus varchar(20)

alter table Orders
ADD shippingperiod int

update Orders
set shippingperiod=DATEDIFF(DAY,[Order Date],[Ship Date])
---
update Orders
set ShippingStatus=
case
	when shippingperiod>0 and [Ship Mode]='Same Day' then 'Late Time'
	when shippingperiod>1 and [Ship Mode]='First Class' then 'Late Time'
	when shippingperiod>3 and [Ship Mode]='Second Class' then 'Late Time'
	when shippingperiod>6 and [Ship Mode]='Standard Class' then 'Late Time'
	when shippingperiod=0 and [Ship Mode]='Same Day' then 'On Time'
	when shippingperiod=1 and [Ship Mode]='First Class' then 'On Time'
	when shippingperiod=3 and [Ship Mode]='Second Class' then 'On Time'
	when shippingperiod=6 and [Ship Mode]='Standard Class' then 'On Time'
	when shippingperiod<1 and [Ship Mode]='First Class' then 'Early Time'
	when shippingperiod<3 and [Ship Mode]='Second Class' then 'Early Time'
	when shippingperiod<6 and [Ship Mode]='Standard Class' then 'Early Time'
END
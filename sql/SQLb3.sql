use HOUSEDB
Select * from HOUSES
--q1
Update HOUSES
Set Price=Price*1.15
Update HOUSES
Set price =price *0.8
where HouseType ='family'
--iif
--set price by housetype: f:200,o:300,v:500
/*iff(<logical_expression>,<True value>,<False_value>)
Case.... when
*/
Update HOUSES
set Price = case
	when HouseType='F' then 200
	when HouseType='O' then 300	
	when HouseType='V' then 500
END
--Set area of houseID A201:100
Update HOUSES
set= Area_m2=100
where HouseID='A201'
--
Up price up 10%:Area>=100 and BedRoom>=2
Update HOUSES
set Price = Price*1.1
where Area_m2>=100 and BedRoom>=2
--
Select * from CONTRACTS
Update CONTRACTS
set Duration=0, ContractValue=0,PrePaid=0,OutstandingAmount=0
--Compute Duration(m)
Update CONTRACTS
set Duration=DATEDIFF(month, StartDate, EndDate)
--Compute Contractvalue: join Contracts vs Houses via HouseID
Update CONTRACTS
set ContractValue= Duration*Price
From CONTRACTS inner join HOUSES on CONTRACTS.HouseID=HOUSES.HouseID
/*
--Compute PrePaid by Duration:
12 months: 50% ContractValue

7-12:70%
4-7: 85%
<4:100%
--OutStandingAmount= Contractvalue-Prepaid+Tax, where tax=10%

*/
Update CONTRACTS
Set PrePaid= ContractValue**case
Case 
	when Duration>12 then 0.5 
	When 8<=Duration and Duration<12 then 0.7 
	When 4<Duration and Duration <7 then 0.85 
	when Duration <4 then 1
End

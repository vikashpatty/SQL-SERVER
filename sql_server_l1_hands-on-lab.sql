--sql-server-l1-handson-lab
--vikash.pateshwari@wipro.com
--select the query and press f5 to run

------------------------------------------------------------------------------------------
--Exercise1
------------------------------------------------------------------------------------------
--1.Display what each books price would be if a 20% price increase were to take place. 
--Show the title id , old price and new price using meaningful headings

Select titleid,price as oldprice,price+price*0.2 from dbo.titles 

------------------------------------------------------------------------------------------
--2.Summarize the total sales for each publishers

select pb.pubid, pb.pubname, sum(ti.totalsales) as sales
from dbo.titles ti,dbo.publishers pb
where ti.pubid = pb.pubid group by pb.pubid, pb.pubname

------------------------------------------------------------------------------------------
--3.For annual report, display the publisher�s id, the title id price and total sales while showing the average price
--and total sales for each publishers, as well as the average price and total year to date sales overall.

select pd.pubid,pd.titleid,pd.price,pd.pubsales,pd.avgprice,pd.totalsales,
	   avg(price) over (partition by dummy order by dummy) as overallavgprice,
	   sum(pubsales) over (partition by dummy order by dummy) as overallpubsales   
from(select 1 as dummy,pubid, titleid, price, pubsales,	
		avg(price) over (partition by pubid order by pubid) as avgprice,
		sum(pubsales) over (partition by pubid order by pubid) as totalsales from dbo.title ) as pd	

------------------------------------------------------------------------------------------
--4.Display the name of books whose price are greater than $20 and less than $55.

select title from dbo.titles where price > 20 and price < 55
------------------------------------------------------------------------------------------
--5.Display total sales made in each category. Category-Wise

select type as category, sum(pubsales) as sales from dbo.titles where pubsales is not null group by type

------------------------------------------------------------------------------------------
--6.Display the numeric part of every title id (the numeric part of the title eg BU1032 , 1032)

select  titleid,SUBSTRING(titleid, 3, len(titleid)-2) as title_numeric from dbo.titles

------------------------------------------------------------------------------------------
--7.You want to retrieve data for all the employees who joined after '1-12-90' have 4 � 6 years of experience.

select * from dbo.employee where hiredate > '1-12-90' and datediff(yy,hiredate,getdate()) between 4 and 6

------------------------------------------------------------------------------------------
--8.You want to know the year of joining of each employee. How do you display those details:

select lname,datepart(yy,hiredate) as YOJ from employee

------------------------------------------------------------------------------------------
--9.Display the collection of every book (price  * total sales) along with author_id

select ta.idau,ti.title,(ti.price*ti.pubsales) as collections from dbo.titles t,dbo.titleauthor ta where ti.titleid = ta.titleid

------------------------------------------------------------------------------------------
--10.	List the stores that have ordered the  �Sushi, Anyone?�

select sa.storeid,sti.storename from dbo.sales sa,dbo.stores st
where sa.storeid = sti.storeid and	titleid =(select titleid from dbo.titles where title = 'Sushi, Anyone?')

------------------------------------------------------------------------------------------
--11.Who published Net Etiquette�s books?

select pubname from dbo.publishers where pubid =(select pubid from dbo.titles where title = 'Net Etiquette')

------------------------------------------------------------------------------------------
--12.	List the Total_Sales for each title published by �New Moon Books� .

select title, pubsales from dbo.titles where pubid =(select pubid from dbo.publishers where pubname = 'New Moon Books')

------------------------------------------------------------------------------------------
--13.Find the titles of books published by any publisher located in a city that begin with the letter �B�

select title, pubsales from dbo.titles where pubid in (select pubid from dbo.publishers where city like 'B%')

------------------------------------------------------------------------------------------
--14.Find the titles that obtain an advance larger than the average price for books of similar type.

select ti.title, ti.type, ti.adv, av.avgprice
from dbo.titles t,(select type, avg(price) as avgprice from dbo.titles where price is not null group by type) as av
where ti.type = av.type and adv > av.avgprice
------------------------------------------------------------------------------------------
-- 15.Find the titles that obtain a larger advance than the minimum paid by �Algodata Infosystems�

select title from dbo.titles 
where adv > (select min(adv) as minadv from dbo.titles where pubid = (select pubid from dbo.publishers where pubname = 'Algodata Infosystems'))

------------------------------------------------------------------------------------------
--16.You want to know the name of the book where authors receive the highest royalty.

select title from dbo.titles where titleid in(select titleid from dbo.roytb where roy =(select max(roy) as max_r from dbo.roytb))

------------------------------------------------------------------------------------------
--17.	You, as sales person, want to find out the names of all those books whose price is higher than that of all business books. Write a query to achieve this?
	
select title from dbo.titles where price > (select max(price) as maxp from dbo.titles where type = 'business')	

------------------------------------------------------------------------------------------
--Exercise2
------------------------------------------------------------------------------------------
--DML
------------------------------------------------------------------------------------------

--1.Create your own employee table called My_Emp  by copying the data from existing table Employee in Pubs database.

select * into dbo.My_Emp from dbo.employee

------------------------------------------------------------------------------------------
--2.Change the last name of employee �VPA30890F� to Drexler.

update dbo.My_Emp set lname = 'Drexler' where EmpId='VPA30890F'

------------------------------------------------------------------------------------------
--3.Delete Paul Henriot from the MY_EMP table.

delete from dbo.My_Emp where fname='Paul' and lname='Henriot'

------------------------------------------------------------------------------------------
--4.Modify the job id of Pedro Afonso to 14

update dbo.My_Emp set JobId=14 where fname='Pedro' and lname='Afonso'

------------------------------------------------------------------------------------------
--5.Add a new employee details to My_Emp table.

insert into dbo.My_Emp values('NNV13322M', 'Nicky', 'N', 'Martin', 2, 215, '9952', '11/11/2013')
------------------------------------------------------------------------------------------
--6.Remove all the job is which are below 5.

delete from dbo.My_Emp where JobId < 5

------------------------------------------------------------------------------------------
--Exercise3
------------------------------------------------------------------------------------------
--DDL
------------------------------------------------------------------------------------------
--1. Create the tables hoose the appropriate data types and constraints.

--Member Table
--
--Column Name	Member_ID	First_Name	Last_Name	Address	City	Phone	Join_Date
--Key Type	PK						
--Null / Unique	NN,U	NN					NN
--Default Value							System Date
--Data Type	Number	Varchar	Varchar	Varchar	Varchar	Varchar	DateTime
--Length	10	25	25	100	30	15	

CREATE TABLE dbo.Member
(Member_ID int NOT NULL CONSTRAINT PK_Member_ID PRIMARY KEY(Member_ID),
 First_Name    varchar(25)  NOT NULL,
 Last_Name    varchar(25),
 Address    varchar(100),
 City     varchar(30),
 Phone    varchar(15),   
 Join_Date  datetime    NOT NULL DEFAULT (getdate())
)

------------------------------------------------------------------------------------------
--2.Title Table
--
--Column Name	Titleid	Title	Description	Rating	Category	Release_Date
--Key Type	PK					
--Null / Unique	NN,U	NN	NN			
--Check				G,PG,R,NC17,NR	Drama,
--Comedy
--Action,
--Documentary
--Data Type	Number	Varchar	Varchar	Varchar	Varchar	DateTime
--Length		60	400	4	15	

CREATE TABLE dbo.Title
(Title_ID int NOT NULL CONSTRAINT PK_Title_ID PRIMARY KEY(Title_ID),
 Title    varchar(60)  NOT NULL,
 Description    varchar(400) NOT NULL,
 Rating    varchar(4)  CHECK (Rating in ('G', 'PG', 'R', 'NC17', 'NR')),
 Category     varchar(15) CHECK (Category in ('Drama', 'Comedy', 'Action', 'Documentary')),  
 Release_Date  datetime 
)
------------------------------------------------------------------------------------------
--3.Title_Copy Table
--
--Column Name	Copy_ID	Title_ID	Status
--Key Type	PK	PK,FK	
--Null / Unique	NN,U	NN,U	NN
--Check			Available,
--Destroyed,
--Rented,
--Reserved
--FK Ref Table		Title	
--FK Ref Column		Title_ID	
--Data Type	Number	Number	Varchar
--Length			15

CREATE TABLE dbo.Title_Copy
(Copy_ID int NOT NULL UNIQUE,
 Title_ID int NOT NULL UNIQUE REFERENCES Title(Title_ID),
 Status varchar(15) NOT NULL CHECK (Status in ('Available', 'Destroyed', 'Rented', 'Reserved')),  
 CONSTRAINT PK_Tcopy PRIMARY KEY (Copy_ID,Title_ID),
 CONSTRAINT FK_Tcopy FOREIGN KEY (Title_ID) REFERENCES dbo.Title(Title_ID)
)

------------------------------------------------------------------------------------------
--4.Rental Table
--
--Column Name	Book_Date	Member_ID	Copy_ID	Act_Ret_Date	Exp_Ret_Date	Title_ID
--Key Type	PK	PK,FK1	PK,FK2			PK,FK2
--Default Value	System Date				System Date+2 days	
--Check			
--			
--FK Ref Table		Member	Title_Copy			Title_Copy
--FK Ref Column		Member_ID	Copy_ID			Title_ID
--Data Type	DateTime	Number	Number	DateTime	DateTime	Number
--Length						


CREATE TABLE dbo.Rental
(
   Book_Date  datetime  DEFAULT (getdate()),
   Member_ID int REFERENCES Member(Member_ID),
   Copy_ID int REFERENCES Title_Copy(Copy_ID),
   Act_Ret_Date  datetime,
   Exp_Ret_Date  datetime DEFAULT (getdate()+2),
   Title_ID int REFERENCES Title_Copy(Title_ID),
   CONSTRAINT PK_rental PRIMARY KEY (Book_Date, Member_ID, Copy_ID, Title_ID),
   CONSTRAINT FK1_rental FOREIGN KEY (Member_ID) REFERENCES dbo.Member(Member_ID),
   CONSTRAINT FK2_rental FOREIGN KEY (Copy_ID,Title_ID) REFERENCES dbo.Title_Copy(Copy_ID,Title_ID)
)
------------------------------------------------------------------------------------------
--5.Reservation Table
--
--Column Name	RES_Date	Member_ID	Title_ID
--Key Type	PK	PK,FK1	PK,FK2
--Null/Unique	NN,U	NN,U	NN
--FK Ref Table		Member	Title
--FK Ref Column		Member_ID	Title_ID
--Data Type	DateTime	Number	Number


CREATE TABLE dbo.Reservation
(
   RES_Date  datetime NOT NULL UNIQUE,   
   Member_ID int NOT NULL UNIQUE REFERENCES Member(Member_ID),
   Title_ID int NOT NULL REFERENCES Title(Title_ID),
   CONSTRAINT PK_res PRIMARY KEY (RES_Date, Member_ID, Title_ID),
   CONSTRAINT FK1_res FOREIGN KEY (Member_ID) REFERENCES dbo.Member(Member_ID),
   CONSTRAINT FK2_res FOREIGN KEY (Title_ID) REFERENCES dbo.Title(Title_ID)
)

------------------------------------------------------------------------------------------
--Exercise4
------------------------------------------------------------------------------------------
--Views
------------------------------------------------------------------------------------------
--1.Create a view called Title_View based on the Title numbers, Title names, and Publishers numbers from the Title table. Change the heading for the title to Books Name .

CREATE VIEW Title_view AS select Title_ID, Title as book_name from dbo.Title

------------------------------------------------------------------------------------------
--2.See the view text from the dictionary.

sp_help Title_view

------------------------------------------------------------------------------------------
--3.Create a view named Pub_City that contains the Title id, title  names, and publishers numbers for all title published by 0877. 

CREATE VIEW Pub_City AS select Title_ID, Title, pubid from dbo.Title where pubid = 0877

------------------------------------------------------------------------------------------

--4.Create a view to display pub number, title, and type for every publishers 
----resides in the country USA

CREATE VIEW PUB_VIEW AS select pubid, Title, type from dbo.Titles where pubid in (select pubid from dbo.publishers where country = 'USA')

------------------------------------------------------------------------------------------
--Exercise5
------------------------------------------------------------------------------------------
--Indexes
------------------------------------------------------------------------------------------
--1.Create a nonunique index on the Pub_ID in the Title table.

CREATE INDEX idx_nu_pubid ON dbo.Titles(pubid)
select o.name as obj_name, i.name as idx_name,i.type_desc,i.is_unique,i.is_primary_key,i.is_unique_constraint
from sys.indexes i,sys.objects o where i.objecTitle_ID = o.objecTitle_ID and o.name in ('Titles','publishers')

------------------------------------------------------------------------------------------
--2.Display the indexes Titles and Publishers table.
EXEC sp_helpindex '[[[dbo.Title]]]'
EXEC sp_helpindex '[[[dbo.Publishers]]]'
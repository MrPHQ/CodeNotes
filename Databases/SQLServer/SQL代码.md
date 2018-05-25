

***

```sql
IF EXISTS(SELECT * FROM sysobjects WHERE name='bbsUser')  
   DROP TABLE bbsUsers    --判断表是否存在  
     
 if EXISTS(SELECT * FROM sysdatabases WHERE name='bbsDB')  
  DROP DATABASE bbsDB   --判断数据库是否存在  
    
--check约束检查  长度  
ALTER TABLE bbsUsers ADD CONSTRAINT CK_Uemail CHECK(Uemail like '%@%')  
  
ALTER TABLE bbsUsers ADD CONSTRAINT CK_Upassword CHECK(LEN(Upassword)>=6)  
--注册日期默认是当前日期  
ALTER TABLE bbsUsers ADD CONSTRAINT DF_Uregdate default(getDate()) for UregDate  
```
****

[My SQL和SQl Server中语句的limit和top的区别](https://blog.csdn.net/leosha/article/details/45932701)

>MYSQL
```sql
select * from tablename limit m, n
```
>SQLServer
```sql
//通用
select top (n-m+1) id from tablename
where id not in (
  select top m-1 id from tablename
)
//查询上述结果中第 7 条到第 9 条记录
select top 3 id from tablename
where id not in (
  select top 6 id from tablename
)
```
****

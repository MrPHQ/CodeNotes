

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

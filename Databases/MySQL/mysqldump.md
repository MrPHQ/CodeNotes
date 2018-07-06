
[Mysqldump参数大全](https://www.cnblogs.com/qq78292959/p/3637135.html)

[MYSQL使用mysqldump导出某个表的部分数据](https://blog.csdn.net/xin_yu_xin/article/details/7574662)

Mysql二进制数据导出和导入(--hex-blob)
***
导出：
mysqldump -hlocalhost -P3306 -uroot -p123456 mydb --hex-blob> "d:\exportdata.sql"

导入：
mysql -hlocalhost -P3306 -uroot -p123456 mydb < d:\exportdata.sql

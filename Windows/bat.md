# 目录

* [命令:FOR](#命令:FOR)
* [读取文件并字符串替换](#读取文件并字符串替换)
* [函数](#函数)
* [判断语句](#判断语句)
* [特殊字符](#特殊字符)

## 命令:FOR

Delims和Tokens总结
****
 
“For /f”常用来解析文本，读取字符串。分工上，delims负责切分字符串，而tokens负责提取字符串。如果把字符串当作蛋糕，Delims像刀子，用来切蛋糕，tokens像叉子，用来取切好的蛋糕。

[链接](http://www.jb51.net/article/17927.htm)
[链接](http://www.jb51.net/article/17928.htm)

例子
****

把以下内容保存为文本文件“歌曲列表.txt”，注意扩展名为“.txt”：

    序号、歌手名-歌曲名.后缀名 
    1、饶天亮-玫瑰爱人.wma 
    2、高一首-我不愿错过.mp3 
    3、黃凱芹-傷感的戀人.MP3 
    4、黄灿-黄玫瑰.lrc 
    5、黎姿-如此这般的爱情故事.mp3 
    
代码1：显示全部内容 
```bat
@echo off 
for /f %%i in (歌曲列表.txt) do echo %%i 
pause>nul
```
运行结果：

    序号、歌手名-歌曲名.后缀名 
    1、饶天亮-玫瑰爱人.wma 
    2、高一首-我不愿错过.mp3 
    3、黃凱芹-傷感的戀人.MP3 
    4、黄灿-黄玫瑰.lrc 
    5、黎姿-如此这般的爱情故事.mp3 

讲解  
如果不使用参数“/f”，运行结果只显示括号里的文字字符“歌曲列表.txt”，而不能读取文本文件“歌曲列表.txt”中的内容。可见，“/f”是解析文本字符串的好工具。 

delims
----
假如只要序号，不要歌手名、歌曲名和后缀名，如何办到？ 

代码2：默认提取第一列 
****
```bar
@echo off 
for /f "delims=、" %%i in (歌曲列表.txt) do echo %%i 
pause>nul 
```
运行结果： 

    序号 
    1 
    2 
    3 
    4 
    5 
    
讲解  
"delims=、"表示定义顿号“、”为分隔符，并用该分隔符“、”切分文本字符串。字符串就是“歌曲列表.txt”里的内容，也就是文件里的文字和标点符号。 该顿号是原文中就有的。除了顿号“、”，原文中还有减号“-”和点号“.”，因此你也可以用它们来做分隔符。 

代码3：用减号“-”做分隔符 
****
```bat
@echo off 
for /f "delims=-" %%i in (歌曲列表.txt) do echo %%i 
pause>nul
```
运行结果： 

    序号、歌手名 
    1、饶天亮 
    2、高一首 
    3、黃凱芹 
    4、黄灿 
    5、黎姿 

讲解  
因为，当减号“-”被用做分隔符时，每行内容被减号“-”分隔成前后两半，默认只显示前半部分，而后半部分连同分隔符减号“-”都被忽略（省略）了。

代码4：用点号“.”做分隔符 
****
```bar
@echo off 
for /f "delims=." %%i in (歌曲列表.txt) do echo %%i 
pause>nul 
```
运行结果： 

    序号、歌手名-歌曲名 
    1、饶天亮-玫瑰爱人 
    2、高一首-我不愿错过 
    3、黃凱芹-傷感的戀人 
    4、黄灿-黄玫瑰 
    5、黎姿-如此这般的爱情故事 

讲解  
默认情况下，单纯使用delims而不用tokens时，只显示第一个分隔符前的内容，第一个分隔符和第一个分隔符后面的内容将被忽略。 

代码5：定义多个分隔符 
****
```bat
@echo off 
for /f "delims=、-." %%i in (歌曲列表.txt) do echo %%i 
pause>nul 
```
运行结果： 

    序号 
    1 
    2 
    3 
    4 
    5 
讲解  
原因是，当定义顿号“、”、减号“-”和点号“.”三个标点符号为分隔符后，原文被分隔成四个部分。   
如第二行“1、饶天亮-玫瑰爱人.wma”将被分隔成“1”、“饶天亮”、“玫瑰爱人”和“wma” 四个部分。   
从第一行到最后一行，每行的每个部分对应下来相当于一个竖列。因此，原文就有“序号”、“歌手名”、“歌曲名”、“后缀名”四列。   
一般情况下，只读取第一列的内容。后面的内容需要用tokens选项提取。  

tokens
----
tokens=x,y,m-n 提取列实现代码。

格式： 
```bat
FOR /F "tokens=x,y,m-n" %%I IN (Command1) DO Command2 
```
用法： 

    一句话总结：提取列。 
    通俗讲，共同提取每一行的第m小节的内容。 
    因此，可以用该命令来指定提取文本信息。 
    tokens=有时表示提取全部。 
    tokens=m表示提取第m列。 
    tokens=m,n表示提取第m列和第n列。 
    tokens=m-n表示提取第m列至第n列。 
    Tokens=*表示删除每行前面的空格。忽略行首的所有空格。 
    tokens=m*提取第m列以后的所有字符，星号表示剩余的字符。 
    tokens=m,*提取第m列以后的所有字符，星号表示剩余的字符

## 读取文件并字符串替换

从foxmail里导出的文件里取出需要的内容, 放入到另一个文件中, 并替换相应的字符为分号, 方便excel直接打开
注意:
1. rem: 为注释当前行
2. ^: 为转义符号
3. %%a: for循环中变量赋值的写法
4. !a!: 程序执行过程中变量的赋值会延迟, 用感叹号以及第二行的 setlocal 指令来消除这种延迟
5. !a:x=y!: 字符串替换的写法, 将变量a中的x替换为y, 如果x是特殊字符需要用^转义, 如果不写y就是将x替换为空
6. 直接输出并追加到文件xxx.log中用文本编辑器打开会有一些乱码, 但是汉字大都没问题,

如果直接用Excel打开中文就可能出现乱码

脚本源代码:
```bat
@echo off 
setlocal EnableDelayedExpansion
rem echo %cd%

for %%s in (*.eml) do (
    rem findstr  "log_user_trade" %%s >> stat.log
    echo %%s
    findstr  "log_user_trade" %%s >tmp.log rem 匹配出需要的行
    set /p line=<tmp.log rem 放入临时文件中
    set a=!line:^^=;! rem 替换字符,将^替换为; ^在bat脚本中是转义字符的意思
    set b=!a:^|=;!
    set c=!b:^@@=;!
    set d=!c:^&quot;=! rem 将字符串&quot;替换为空
    set e=!d:^&gt;=!
    set f=!e:^<td^>=!
    echo !f:^</td^>=! >> stat.log
) 
echo complete
pause
```
[返回目录](#目录)

## 函数
[http://blog.csdn.net/xiaoding133/article/details/39252357](http://blog.csdn.net/xiaoding133/article/details/39252357)

## 判断语句
[https://www.cnblogs.com/DswCnblog/p/5435231.html](https://www.cnblogs.com/DswCnblog/p/5435231.html)

## 特殊字符
* ^

 `^`是批处理中的转义符，用于转义特殊字符为普通字符。
 这个FOR命令是将`'ipconfig^|find "IP Address"'`中间的字符当作命令来执行，而其中的 `|` 不是个普通字符，而是个命令符号，所以需要用转义符号 `^`把 `|` 转义成普通字符，这样 `'ipconfig^|find "IP Address"'`里面就全是普通字符了，`FOR`命令才能正确执行。

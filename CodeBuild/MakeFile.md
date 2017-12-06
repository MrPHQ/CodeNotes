## `wildcard&notdir&patsubst`
[转载](https://www.cnblogs.com/haoxing990/p/4629454.html, "https://www.cnblogs.com/haoxing990/p/4629454.html")  
[转载](http://blog.csdn.net/yuzhihui_no1/article/details/44810357)  
[log4cplus](https://www.cnblogs.com/xiaouisme/archive/2012/07/29/2613908.html)

## 编译动态链接库和静态链接库
[转载](https://www.cnblogs.com/nufangrensheng/p/3578784.html)  
1.生成动态链接库：
```
g++ -m32 hello1.cpp hello2.cpp -fPIC -shared -o ../lib/linux32/libhello.so 
```
-m32为生成32位的动态链接库，-m64位生成64位的动态链接库。

2.生成静态链接库：
```
g++ -m32 hello1.cpp -c -o hello1.o //编译hello1.cpp 生成中间文件hello1.o 
g++ -m32 hello2.cpp -c -o hello2.o //编译hello2.cpp 生成中间文件hello2.o 
ar rcs libhello.a hello2.o hello1.o //将hello1.o和hello2.o添加到静态链接库
```
其中“-m32”参数是编译32位的可执行文件  
3. 除了生成库文件，还可以采用-I参数，引入.o文件。 
```
g++ -m32 hello2.cpp -o hello2 -I./ hello1.o  
```
4.运行时自动加载动态链接库
```
g++ -m32 hello.cpp -o hello -L/lib/linux32/ -lname -Wl,--rpath=/lib/linux32/
```
5. 运行时自动加载静态链接库：
```
g++ -m32 hello2.cpp -o hello2 -I/lib/linux32/  lhello -Wl,--rpath=/lib/linux32/  
```
6.如果不想在运行时链接库文件，那么可以采用export方式，例如：  
```
export LD_LIBRARY_PATH=/lib/linux32/  
```
## 同时使用动态和静态链接
gcc的-static选项可以使链接器执行静态链接。但简单地使用-static显得有些’暴力’，因为他会把命令行中-static后面的所有-l指明的库都静态链接，更主要的是，有些库可能并没有提供静态库（.a），而只提供了动态库（.so）。这样的话，使用-static就会造成链接错误。  
之前的链接选项大致是这样的，
```
CORE_LIBS="$CORE_LIBS -L/usr/lib64/mysql -lmysqlclient -lz -lcrypt -lnsl -lm -L/usr/lib64 -lssl -lcrypto"
```
修改过是这样的，
```
CORE_LIBS="$CORE_LIBS -L/usr/lib64/mysql -Wl,-Bstatic -lmysqlclient \ -Wl,-Bdynamic -lz -lcrypt -lnsl -lm -L/usr/lib64 -lssl -lcrypto"
```
其中用到的两个选项：-Wl,-Bstatic和-Wl,-Bdynamic。这两个选项是gcc的特殊选项，它会将选项的参数传递给链接器，作为链接器的选项。比如-Wl,-Bstatic告诉链接器使用-Bstatic选项，该选项是告诉链接器，对接下来的-l选项使用静态链接；-Wl,-Bdynamic就是告诉链接器对接下来的-l选项使用动态链接。  
值得注意的是对-static的描述：-static和-shared可以同时存在，这样会创建共享库，但该共享库引用的其他库会静态地链接到该共享库中。

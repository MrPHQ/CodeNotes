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

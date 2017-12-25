# 目录

## vector的capacity
[转载](http://blog.csdn.net/u013575812/article/details/51171135)
capacity是指在发生realloc前能允许的最大元素数，即预分配的内存空间。

使用reserve()修改capacity的值，容器内的对象并没有真实的内存空间,此时切记使用[]操作符访问容器内的对象，很可能出现数组越界的问题。

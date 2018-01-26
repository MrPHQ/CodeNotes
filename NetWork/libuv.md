# 目录

[网络库libevent、libev、libuv对比](http://blog.csdn.net/lijinqi1987/article/details/71214974)

[官网](http://libuv.org/)

[链接](http://cnodejs.org/topic/577a6d8777471bfb0555e97e)

## 知识点
三种监视器
****
* uv_prepare_t
* uv_idel_t
* uv_check_t

每次循环迭代都会调用它的回调函数

三种watcher的区别在于： 

    1.在循环迭代中的调用顺序不同： 
    idle（空转）在处理完上个迭代获取的请求之后调用 
    prepare紧接着idle之后调用 
    check在轮询之后调用

    2.idle会影响loop i/o轮询的超时设置，当有idle时，超时时间为0。

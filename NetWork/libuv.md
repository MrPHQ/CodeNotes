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

## 句柄
uv_async_t 
****
Async handle type.

用来从另一个线程与loop所在线程交互，主要是唤醒loop（通过PostQueuedCompletionStatus向iocp端口发送事件）  
uv_run在i/o轮询是会获取到send发送的事件，并将uv_async_t内部的请求添加到loop的pending_reqs_tail列表
```c
typedef struct uv_async_s uv_async_t;
struct uv_async_s 
{
  UV_HANDLE_FIELDS//uv_handle_t的成员，此处不再展开，请参考之前的内容
  //UV_ASYNC_PRIVATE_FIELDS展开如下：
  //请求，内部使用
  struct uv_req_s async_req;
  //回调函数        
  uv_async_cb async_cb;         
  //避免多次发送相同的请求（通过PostQueuedCompletionStatus）
  char volatile async_sent;
};
```
通过char volatile async_sent;成员可以实现多次调用uv_async_send发送同一uv_async_t，在请求被处理之前，内部其实只会发送一次（通过PostQueuedCompletionStatus），也就是回调函数只会被调用一次。

相关接口
```c
int uv_async_init(uv_loop_t* loop, uv_async_t* async, uv_async_cb async_cb) 
在初始化时会与loop联系起来，并在内部初始化一个wakeup类型的请求 
可以看出本函数并非是线程安全的，所以需要在uv_run之前调用或者与uv_run在同一线程调用

int uv_async_send(uv_async_t* async) 
发送请求,唤醒loop以便调用回调函数，线程安全的，可以在其他线程调用
```

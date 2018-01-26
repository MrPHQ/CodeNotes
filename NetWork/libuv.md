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

uv_process_s
****
```c
typedef struct uv_process_s uv_process_t;
struct uv_process_s {
  UV_HANDLE_FIELDS//uv_handle_t的成员，此处不再展开
  uv_exit_cb exit_cb;//回调函数
  int pid;//进程id
  //UV_PROCESS_PRIVATE_FIELDS宏展开：
  struct uv_process_exit_s {
    UV_REQ_FIELDS//uv_req_t的成员，此处不再展开，用来发送调用关闭回调的请求
  } exit_req; 
  BYTE* child_stdio_buffer;//要发送给子进程的文件描述符
  int exit_signal;//退出信号
  HANDLE wait_handle;//监控子进程是否关闭的句柄，不需要closehandle
  HANDLE process_handle;//进程句柄 
  volatile char exit_cb_pending;//进程关闭监控回调是否调用的标记
};
```

```c
typedef struct uv_process_options_s {
  uv_exit_cb exit_cb; //进程退出后的回调
  const char* file;//进程路径  utf8编码

  //命令行参数utf8编码。 args[0]应该是进程路径。windows平台下调用CreateProcess函数，并将args参数
  //转换为字符串，这可能会导致一些奇怪的问题，参考windows_verbatim_arguments
  char** args;
  //设置子进程环境变量 utf8编码
  char** env;
  //工作目录 utf8编码
  const char* cwd;
  //控制uv_spawn函数的标记量
  unsigned int flags;
  //`stdio`成员指向一个uv_stdio_container_t数组，uv_stdio_container_t里面存放将会传递给子进
  //程的文件描述符。一般来说，stdio[0]指向stdin, fd 1是stdout, fd 2 是 stderr.
  //在windows平台下，只有当子进程使用MSVCRT运行时环境时才能支持超过2个的文件描述符
  int stdio_count;
  uv_stdio_container_t* stdio;
  //windows不支持
  uv_uid_t uid;
  uv_gid_t gid;
} uv_process_options_t;
```

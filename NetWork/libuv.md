# 目录

* [知识点](#知识点)
* [句柄](#句柄)
* [线程](#线程)
* [线程池](#线程池)
* [互斥锁](#互斥锁)
* [读写锁](#读写锁)
* [信号量](#信号量)
* [条件变量](#条件变量)
* [Barriers](#Barriers)

[网络库libevent、libev、libuv对比](http://blog.csdn.net/lijinqi1987/article/details/71214974)

[官网](http://libuv.org/)

[链接](http://cnodejs.org/topic/577a6d8777471bfb0555e97e)  
[学习笔记](http://blog.csdn.net/paohui0134/article/category/6266738/1)

[4个特殊句柄](http://www.cnblogs.com/watercoldyi/p/5682344.html)

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

uv_stream_t
****
uv_stream_t提供一个抽象的双工通信通道。uv_stream_t是抽象类型，libuv提供3种流的实现：uv_tcp_t,uv_pipe_t以及uv_tty_t
```c
typedef struct uv_stream_s uv_stream_t;
struct uv_stream_s {
  UV_HANDLE_FIELDS//uv_handle_t成员，此处不再展开
  //UV_STREAM_FIELDS宏展开如下：
  #define UV_STREAM_FIELDS                                                      
  /* number of bytes queued for writing */                                    
  size_t write_queue_size;//需要写入的数据量                                                   
  uv_alloc_cb alloc_cb;//内存分配回调函数                                    
  uv_read_cb read_cb;//读取数据回调函数                                                         
  /* private */                                                               
  //UV_STREAM_PRIVATE_FIELDS宏展开如下：
  unsigned int reqs_pending;                                                 
  int activecnt;//基于此流的活动请求计数                                                            
  uv_read_t read_req;//读操作请求                                                        
  union {                                                                     
    struct 
    {
     unsigned int write_reqs_pending;                                           
     uv_shutdown_t* shutdown_req;
    } conn;                              
    struct   
    { 
      uv_connection_cb connection_cb; 
    } serv;                             
  } stream;
};
```
**相关请求类型**

uv_connect_t，连接请求
```c
struct uv_connect_s {
  UV_REQ_FIELDS//uv_req_t的数据，此处不再展开
  uv_connect_cb cb;//连接回调
  uv_stream_t* handle;//
  //UV_CONNECT_PRIVATE_FIELDS宏为空
};
```
uv_shutdown_t，关闭请求
```c
struct uv_shutdown_s {
  UV_REQ_FIELDS//uv_req_t的数据，此处不再展开
  uv_stream_t* handle;
  uv_shutdown_cb cb;//关闭回调
  //UV_SHUTDOWN_PRIVATE_FIELDS宏为空
};
```
uv_write_t，写操作请求
```c
struct uv_write_s {
  UV_REQ_FIELDS//uv_req_t的数据，此处不再展开
  uv_write_cb cb;//写回调
  uv_stream_t* send_handle;//发送对象
  uv_stream_t* handle;//
  //UV_WRITE_PRIVATE_FIELDS宏展开：
  int ipc_header;                                                             
  uv_buf_t write_buffer;//写内容                                                     
  HANDLE event_handle;                                                       
  HANDLE wait_handle;
};
```
以上三种请求都可以说是uv_req_t的子类，内部都有uv_stream_t对象的指针

uv_tcp_t
****
TCP handle type.
```c
typedef struct uv_tcp_s uv_tcp_t;
struct uv_tcp_s {
  UV_HANDLE_FIELDS//uv_handle_t的成员
  UV_STREAM_FIELDS//stream的成员
  //UV_TCP_PRIVATE_FIELDS展开如下：
  SOCKET socket;                                                              
  int delayed_error;                                                          
  union {                                                                    
    struct {
     uv_tcp_accept_t* accept_reqs;//接受请求列表                                              
     unsigned int processed_accepts;                                           
     uv_tcp_accept_t* pending_accepts;//等待处理的接受请求 
     LPFN_ACCEPTEX func_acceptex;//accetpex的函数指针
    } serv;                                     
    struct {
     uv_buf_t read_buffer; //读取数据的缓存
     LPFN_CONNECTEX func_connectex;//connectex函数指针
    } conn;                                
  } tcp;
};
```
**相关的请求**
```c
  typedef struct uv_tcp_accept_s {                                          
    UV_REQ_FIELDS//uv_req_t的成员                                                        
    SOCKET accept_socket;                                                
    char accept_buffer[sizeof(struct sockaddr_storage) * 2 + 32];        
    HANDLE event_handle;                                                 
    HANDLE wait_handle;                                                  
    struct uv_tcp_accept_s* next_pending;                              
  } uv_tcp_accept_t;
```

uv_fs_event_t 
****
FS Event handle type.
```c
typedef struct uv_fs_event_s uv_fs_event_t;
struct uv_fs_event_s {
  UV_HANDLE_FIELDS//uv_handle_t的成员
  /* private */
  char* path;//路径，utf8编码，由libuv申请、释放
  //UV_FS_EVENT_PRIVATE_FIELDS展开如下：
  struct uv_fs_event_req_s {  
    UV_REQ_FIELDS 
  } req;                 //请求 
  HANDLE dir_handle;//文件夹句柄，通过CreateFileW获取 
  int req_pending;//表计量，判断是否开始监听文件 
  uv_fs_event_cb cb;//回调函数 
  WCHAR* filew;/utf16文件名，由libuv申请、释放  
  WCHAR* short_filew;//utf16编码的短路径文件名，由libuv申请、释放
  WCHAR* dirw;//utf16编码的文件夹路径，由libuv申请、释放                                          
  char* buffer;//存放监控返回的信息，由libuv申请、释放
};
```
uv_fs_event_t提供了对于文件的监控（文件修改、重命名等），可以看出，实际上是监视的文件所在的文件夹。

[返回目录](#目录)
## 线程

## 线程池
libuv提供了一个线程池，可以用来运行用户代码并在循环线程中得到通知。 此线程池在内部用于运行所有文件系统操作，以及getaddrinfo和getnameinfo请求。

其默认大小为4，但可以在启动时通过将`UV_THREADPOOL_SIZE`环境变量设置为任何值（绝对最大值为128）来更改它。

线程池是全局的，并在所有事件循环中共享。 当一个特定的函数使用线程池时（即当使用`uv_queue_work（）`时）libuv预先分配和初始化由`UV_THREADPOOL_SIZE`允许的最大线程数。 这会导致相对较小的内存开销（128个线程约为1MB），但会增加运行时线程的性能。

>请注意，即使使用跨所有事件循环共享的全局线程池，函数也不是线程安全的。

## 互斥锁

## 读写锁

## 信号量

## 条件变量

## Barriers
当某一线程需要等待其他一些线程任务完成之后才能继续运行时，可以使用barrier。 
```cpp
int uv_barrier_wait(uv_barrier_t* barrier) {
  int serial_thread;
  uv_mutex_lock(&barrier->mutex);//进入临界区
  if (++barrier->count == barrier->n) {//最后一个任务
    uv_sem_wait(&barrier->turnstile2);//等待第二个信号量
    uv_sem_post(&barrier->turnstile1);//释放第一个信号量
  }
  uv_mutex_unlock(&barrier->mutex);
  uv_sem_wait(&barrier->turnstile1);//等待第一个信号量
  uv_sem_post(&barrier->turnstile1);//释放第一个信号量
  uv_mutex_lock(&barrier->mutex);//进入临界区
  serial_thread = (--barrier->count == 0);
  if (serial_thread) {//最后一个任务
    uv_sem_wait(&barrier->turnstile1);/等待第一个
    uv_sem_post(&barrier->turnstile2);//释放第二个
  }
  uv_mutex_unlock(&barrier->mutex);

  uv_sem_wait(&barrier->turnstile2);//等待第二个
  uv_sem_post(&barrier->turnstile2);//释放第二个
  return serial_thread;
}
```
流程如下： 
1. 所有的相关线程都调用uv_barrier_wait等待同一个uv_barrier_t，此时除了最后一个，都会在等待第一个信号量的地方阻塞。 
2. 最后一个调用uv_barrier_wait的线程会等待第二个信号量，此时第二个信号量没有资源，然后释放第一个信号量。 
3. 之前阻塞在等待第一个信号量的线程中的一个获取信号量，继续运行，接着释放第一个信号量，这导致所有阻塞的进程都会因此一个一个的继续运行 
4. 接着除了最后一个线程，所有的线程都会阻塞在等待第二个信号量的地方。 
5. 最后一个线程，等待第一个信号量，此时第一个信号量重新变为没有资源，接着释放第二个信号量，激活其他等待的线程 
6. 其他阻塞在等待第二个信号量的线程，一个一个的唤醒，最终第二个信号量的资源为一，所有的线程继续运行

注意，最后一个线程是指逻辑上的最后一个，并不是确定的。 
如果线程数比初始化时设置的任务数少，那么都会阻塞 
如果线程池数比任务数多，那么等待任务数量的线程之后就会继续运行。

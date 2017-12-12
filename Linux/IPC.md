# 目录
  * [本地socket](#本地socket)
  * [共享内存](#共享内存)
  
## 本地socket
[本地socket unix domain socket](http://blog.csdn.net/bingqingsuimeng/article/details/8470029)

## 共享内存
* 创建
```c++
#include <sys/ipc.h>
#include <sys/shm.h>
/*
 * key：SHM 标识
 * size：SHM 大小
 * shmflg：创建或得到的属性，例如 IPC_CREAT
 * return：成功返回 shmid，失败返回 -1，并设置 erron
 */
int shmget(key_t key, size_t size, int shmflg);
```
* 映射
`shmat`将由 `shmget` 返回的 `shmid` 标识的 SHM 映射到进程的地址空间：
```c++
#include <sys/types.h>
#include <sys/shm.h>
/*
 * shmid：SHM ID
 * shmaddr：SHM 内存地址
 * shmflg：SHM 权限
 * return：成功返回 SHM 的地址，失败返回 (void *) -1，并设置 erron
 */
void *shmat(int shmid, const void *shmaddr, int shmflg);
```
其中 shmaddr 参数主要有 2 种情况：  
shmaddr = NULL：系统选择一块合适的内存地址作为映射的起始地址  
shmaddr != NULL：用户自己地址，但是该地址需要符合一定的条件，详情参考 man shmat  
* 分离
shmdt 解除当前进程映射的 SHM  
```c++
#include <sys/types.h>
#include <sys/shm.h>
/*
 * shmaddr：已经映射的 SHM 地址
 * return：成功返回 0，失败返回 -1，并设置 erron
 */
int shmdt(const void *shmaddr);
```
* 共享内存的删除
`shmctl`控制对这块共享内存的使用，包括删除。函数原型如下:  
```cpp
int shmctl(int shmid, int command, struct shmid_ds *buf);  
shmid：共享内存的ID。
command：是控制命令，IPC_STAT（获取共享内存的状态）、IPC_SET（改变共享内存的状态）IPC_RMID（删除共享内存）。
buf：一个结构体指针。Command设置为IPC_STAT的时候，取得的状态放在这个结构体中。如果要改变共享内存的状态，由这个结构体指定。
返回值：成功：0，失败：-1。
```
* 使用常见陷阱与分析
[转载](http://os.51cto.com/art/201311/418977_all.htm)
1. 超过共享内存的大小限制？
	在一个linux服务器上，共享内存的总体大小是有限制的，这个大小通过SHMMAX参数来定义（以字节为单位），您可以通过执行以下命令来确定 SHMMAX 的值： 
	>cat /proc/sys/kernel/shmmax 
2. 多次进行shmat会出现什么问题？  
	一个进程是可以对同一个共享内存多次 shmat进行挂载的，物理内存是指向同一块，如果shmaddr为NULL，则每次返回的线性地址空间都不同。而且指向这块共享内存的引用计数会增加。也就是进程多块线性空间会指向同一块物理地址。这样，如果之前挂载过这块共享内存的进程的线性地址没有被shmdt掉，即申请的线性地址都没有释放，就会一直消耗进程的虚拟内存空间，很有可能会最后导致进程线性空间被使用完而导致下次shmat或者其他操作失败。  
	**解决方法：**  
	可以通过判断需要申请的共享内存指针是否为空来标识是否是第一次挂载共享内存，若是则使用进行挂载，若不是则退出。
	```c++
	void* ptr = NULL; 
	....
	if (NULL != ptr) 
		return; 
	ptr = shmat(shmid,ptr,0666); 
	```
3. shmget创建共享内存，当key相同时，什么情况下会出错？  
	shmget() 用来创建一个共享内存区，或者访问一个已存在的共享内存区,该函数定义在头文件 linux/shm.h中，原型如下：  
	>int shmget(key_t key, size_t size, int shmflg); 

	参数 key是由 ftok() 得到的键值;  
	参数 size 是以字节为单位指定内存的大小;  
	参数 shmflg 是操作标志位，它的一些宏定义如下:  
	`IPC_CREATE` : 调用 `shmget` 时，系统将此值与其他共享内存区的 `key` 进行比较，如果存在相同的 `key` ，说明共享内存区已存在，此时返回该共享内存区的标识符，否则新建一个共享内存区并返回其标识符.  
	`IPC_EXCL` : 该宏必须和 `IPC_CREATE` 一起使用，否则没意义。当 shmflg 取 `IPC_CREATE | IPC_EXCL` 时，表示如果发现内存区已经存在则返回` -1`，错误代码为 `EEXIST`.  
	注意，当创建一个新的共享内存区时，size 的值必须大于 0 ；如果是访问一个已经存在的内存共享区，则置 size 为 0.  
4. 如果创建进程和挂接进程key相同，而对应的size大小不同，是否会shmget失败？  
	已经创建的共享内存的大小是可以调整的，但是已经创建的共享内存的大小只能调小，不能调大.  
	当多个进程都能创建共享内存的时候，如果key出现相同的情况，并且一个进程需要创建的共享内存的大小要比另外一个进程要创建的共享内存小，共享内存大的进程先创建共享内存，共享内存小的进程后创建共享内存，小共享内存的进程就会获取到大的共享内存进程的共享内存， 并修改其共享内存的大小和内容（留意下面的评论补充），从而可能导致大的共享内存进程崩溃.    
	**解决方法：**  
	方法一：  
	在所有的共享内存创建的时候，使用排他性创建，即使用IPC_EXCL标记:  
	```Shmget(key, size,IPC_CREATE|IPC_EXCL); ```  
	在共享内存挂接的时候，先使用排他性创建判断共享内存是否已经创建，如果还没创建则进行出错处理，若已经创建，则挂接:    
	```cpp
	Shmid = Shmget(key, size,IPC_CREATE|IPC_EXCL); 
	If (-1 != shmid) 
	{ 
	Printf("error"); 
	} 
	Shmid = Shmget(key, size,IPC_CREATE); 
	```
5. ftok是否一定会产生唯一的key值？  
	系统建立IPC通讯（如消息队列、共享内存时）必须指定一个ID值。通常情况下，该id值通过ftok函数得到。  
	ftok原型如下：  
	```key_t ftok( char * pathname, int proj_id) ```  
	pathname就时你指定的文件名，proj_id是子序号。
6. 共享内存删除的陷阱？  

[回到顶部](#目录) 

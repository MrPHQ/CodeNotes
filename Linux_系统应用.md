
# 目录
* [系统](#系统)  
    * [启动过程](#启动过程)  
    * [守护进程](#守护进程)  

# 系统
## 启动过程

[转载](https://www.cnblogs.com/sysk/p/4778976.html "https://www.cnblogs.com/sysk/p/4778976.html")
1. 加载BIOS

        你打开计算机电源，计算机会首先加载BIOS信息，BIOS信息是如此的重要，以至于计算机必须在最开始就找到它。
        这是因为BIOS中包含了CPU的相关信息、设备启动顺序信息、硬盘信息、内存信息、时钟信息、PnP特性等等。
        在此之后，计算机心里就有谱了，知道应该去读取哪个硬件设备了。
2. 读取MBR

        硬盘上第0磁道第一个扇区被称为MBR，也就是Master Boot Record，即主引导记录.
        系统找到BIOS所指定的硬盘的MBR后，就会将其复制到0x7c00地址所在的物理内存中。
        其实被复制到物理内存的内容就是Boot Loader，而具体到你的电脑，那就是lilo或者grub了
3. Boot Loader/Grup
        
        Boot Loader 就是在操作系统内核运行之前运行的一段小程序。
        通过这段小程序，我们可以初始化硬件设备、建立内存空间的映射图，
        从而将系统的软硬件环境带到一个合适的状态，以便为最终调用操作系统内核做好一切准备。
        Boot Loader有若干种，其中Grub、Lilo和spfdisk是常见的Loader。
4. 加载内核

        根据grub设定的内核映像所在路径，系统读取内存映像，并进行解压缩操作.
        系统将解压后的内核放置在内存之中，并调用start_kernel()函数来启动一系列的初始化函数并初始化各种设备，完成Linux核心环境的建立。
        至此，Linux内核已经建立起来了，基于Linux的程序应该可以正常运行了。
5. 用户层init依据inittab文件来设定运行等级

        内核被加载后，第一个运行的程序便是/sbin/init，该文件会读取/etc/inittab文件，并依据此文件来进行初始化工作。
        其实/etc/inittab文件最主要的作用就是设定Linux的运行等级，其设定形式是“：id:5:initdefault:”，这就表明Linux需要运行在等级5上。
        
        0：关机
        1：单用户模式
        2：无网络支持的多用户模式
        3：有网络支持的多用户模式
        4：保留，未使用
        5：有网络支持有X-Window支持的多用户模式
        6：重新引导系统，即重启
6. init进程执行rc.sysinit

        在设定了运行等级后，Linux系统执行的第一个用户层文件就是/etc/rc.d/rc.sysinit脚本程序，
        它做的工作非常多，包括设定PATH、设定网络配置（/etc/sysconfig/network）、启动swap分区、设定/proc等等。
7. 启动内核模块

        依据/etc/modules.conf文件或/etc/modules.d目录下的文件来装载内核模块。
8. 执行不同运行级别的脚本程序
        
        根据运行级别的不同，系统会运行rc0.d到rc6.d中的相应的脚本程序，来完成相应的初始化工作和启动相应的服务。
9. 执行/etc/rc.d/rc.local

        rc.local就是在一切初始化工作后，Linux留给用户进行个性化的地方。你可以把你想设置和启动的东西放到这里。
10. 执行/bin/login程序，进入登录状态

[回到顶部](#目录)
## 守护进程
[转载](http://cdeveloper.cn/posts/daemon "http://cdeveloper.cn/posts/daemon")

**什么是守护进程**

        守护进程可以简单的理解为后台的服务进程，很多上层的服务器都是以守护进程为基础开发的。
        例如 Linux 上运行的 Apache 服务器，Android 系统的 Service 服务，它们的底层都由 Linux 的守护进程提供服务。
**编写守护进程的 6 个步骤**

        1. 重新设置 umask(0)
        2. 执行 fork 并脱离父进程
        3. 重启 session 会话
        4. 改变当前工作目录
        5. 关闭文件描述符
        6. 固定文件描述符 0, 1, 2 到 /dev/null
**示例**
```c++
void daemon_init(void) {
 	// 1. 重新设置 umask
	umask(0); 
	
	// 2. 调用 fork 并脱离父进程
	pid_t pid = fork()  ; 
	
	if(pid < 0)
		exit(1); 
	else if(pid > 0)
		exit(0);

	// 3. 重启 session 会话
	setsid();

	// 4. 改变工作目录
	chdir("/"); 

	// 5. 得到并关闭文件描述符
	struct rlimit rl;
	getrlimit(RLIMIT_NOFILE, &rl);
	if (rl.rlim_max == RLIM_INFINITY)
		rl.rlim_max = 1024;
	for(int i = 0; i < rl.rlim_max; i++)	
		close(i); 
	
	// 6. 不接受标准输入，输入，错误
	int fd0 = open("/dev/null", O_RDWR);
	int fd1 = dup(0);
	int fd2 = dup(0);	 
}
```
**让守护进程开机自启动**

每个系统启动级别的守护进程分别在 /etc/rcN.d 下，比如我的图形界面的启动级别是 5，那么在这个启动级别下自动运行和禁止启动守护进程都在 /etc/rc5.d 下.这里我的 ubuntu 系统的守护进程目录是 /etc/rcN.d

知道了守护进程的位置，现在就可以把 printlg 放在 /etc/rc5.d/ 下，并且还要改名称，因为系统需要根据指定的名称来使用 for 循环来启动或者关闭每个程序，命名规则如下：
S[num][name]：启动守护进程 name，例如：S01printlg
K[num][name]：禁止启动守护进程 name，例如：K01printlg
```
ln -s /mnt/my_proj/linux/daemon/printlg ./S01printlg
```
[回到顶部](#目录)     

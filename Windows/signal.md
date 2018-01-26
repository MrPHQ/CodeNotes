Windows下的信号（Signal）

信号是进程在运行过程中，由自身产生或由进程外部发过来的消息。
信号是硬件中断的软件模拟(软中断)。每个信号用一个整型常量宏表示，以SIG开头，比如SIGCHLD、SIGINT等，它们在系统头文件中<signal.h>定义。

来源
****
信号的生成来自内核，让内核生成信号的请求来自3个地方:用户、内核护着进程。
* 用户：用户能够通过输入CTRL+c、Ctrl+，或者是终端驱动程序分配给信号控制字符的其他任何键来请求内核产生信号；
* 内核：当进程执行出错时，内核会给进程发送一个信号，例如非法段存取(内存访问违规)、浮点数溢出等
* 进程：一个进程可以通过系统调用kill给另一个进程发送信号，一个进程可以通过信号和另外一个进程进行通信。
由进程的某个操作产生的信号称为同步信号(synchronous signals),例如除0；由用户击键之类的进程外部事件产生的信号叫做异步信号。(asynchronous signals)。

处理
****
进程接收到信号以后，可以有如下3种选择进行处理：
* 接收默认处理：接收默认处理的进程通常会导致进程本身消亡。例如连接到终端的进程，用户按下CTRL+c，将导致内核向进程发送一个SIGINT的信号，进程如果不对该信号做特殊的处理，系统将采用默认的方式处理该信号，即终止进程的执行；
* 忽略信号：进程可以通过代码，显示地忽略某个信号的处理，例如：signal(SIGINT,SIGDEF)；但是某些信号是不能被忽略的，
* 捕捉信号并处理：进程可以事先注册信号处理函数，当接收到信号时，由信号处理函数自动捕捉并且处理信号。
有两个信号既不能被忽略也不能被捕捉，它们是SIGKILL和SIGSTOP。即进程接收到这两个信号后，只能接受系统的默认处理，即终止线程。

Windows Signal Types
****
```c
// Ctrl-C handler
static int b_ctrl_c = 0;
static int b_exit_on_ctrl_c = 0;

// Signal types
#define SIGINT     2       // interrupt(Ctrl+C中断)
#define SIGILL     4       // illegal instruction - invalid function image(非法指令)
#define SIGFPE     8       // floating point exception(浮点异常)
#define SIGSEGV    11      // segment violation(段错误)
#define SIGTERM    5       // Software termination signal from kill(Kill发出的软件终止)
#define SIGBREAK   21      //Ctrl-Break sequence(Ctrl+Break中断)
#define SIGABRT    22      // abnormal termination triggered by abort call(Abort)
```

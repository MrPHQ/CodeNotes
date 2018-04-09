

## CefApp
***

CefApp: 与进程，命令行参数，代理，资源管理相关的回调类，用于让 `CEF3` 的调用者们定制自己的逻辑。与该类相关的几个函数如下：
```cpp
int CefExecuteProcess(const CefMainArgs& args,
                      CefRefPtr<CefApp> application,
                      void* windows_sandbox_info);
                      
bool CefInitialize(const CefMainArgs& args,
                   const CefSettings& settings,
                   CefRefPtr<CefApp> application,
                   void* windows_sandbox_info);
```

## CefClient
***
CefClient: 回调管理类，该类的对象作为参数可以被传递给`CefCreateBrowser()` 或者 `CefCreateBrowserSync()` 函数。该类的主要接口如下：

>CefContextMenuHandler，回调类，主要用于处理 Context Menu 事件。  
CefDialogHandler，回调类，主要用来处理对话框事件。  
CefDisplayHandler，回调类，处理与页面状态相关的事件，如页面加载情况的变化，地址栏变化，标题变化等事件。  
CefDownloadHandler，回调类，主要用来处理文件下载.  
CefFocusHandler，回调类，主要用来处理焦点事件。  
CefGeolocationHandler，回调类，用于申请 geolocation 权限。  
CefJSDialogHandler，回调类，主要用来处理 JS 对话框事件。  
CefKeyboardHandler，回调类，主要用来处理键盘输入事件。  
CefLifeSpanHandler，回调类，主要用来处理与浏览器生命周期相关的事件，与浏览器对象的创建、销毁以及弹出框的管理。  
CefLoadHandler，回调类，主要用来处理浏览器页面加载状态的变化，如页面加载开始，完成，出错等。  
CefRenderHandler，回调类，主要用来处在在窗口渲染功能被关闭的情况下的事件。  
CefRequestHandler，回调类，主要用来处理与浏览器请求相关的的事件，如资源的的加载，重定向等。  

## CefBrowserHost
***
CefBrowserHost: 该类在浏览器窗口来看代表了 `browser` 进程，同时也暴露了与浏览器窗口相关的接口，该类的方法只能在 `browser` 进程中调用，但可以在 `browser` 进程的任意线程中被调用。该类的主要方法如下：
```cpp
  static bool CreateBrowser(const CefWindowInfo& windowInfo,
                            CefRefPtr<CefClient> client,
                            const CefString& url,
                            const CefBrowserSettings& settings,
                            CefRefPtr<CefRequestContext> request_context);
```
请求关闭浏览器对象。该函数被调用是会触发 JS 'onbeforeunload' 事件，如果参数 force_close为 false，并且提供了 onbeforeunload 事件的回调函数，则提示用户是否关闭浏览器，此时用户可以选取取消操作。如果 force_close为 true，则直接关闭浏览器。
```cpp
public virtual void CloseBrowser(bool force_close)= 0;
```
获取浏览器对象(在 CefBrowser 类中可以通过调用 GetHost() 获取与之对应的 CefBrowserHost)
```cpp
public virtual CefRefPtr< CefBrowser > GetBrowser()= 0;
```
获取 CefClient 对象
```cpp
public virtual CefRefPtr< CefClient > GetClient()= 0;
```
获取该浏览器对象的窗口句柄，如果是弹出窗口，则返回 NULL。
```cpp
public virtual CefWindowHandle GetOpenerWindowHandle()= 0;
```

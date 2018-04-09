

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

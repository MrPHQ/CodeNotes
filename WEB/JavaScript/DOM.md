# 目录

**查找HTML元素**
* 通过 id 找到 HTML 元素
```javascript
var x=document.getElementById("intro");
```
如果找到该元素，则该方法将以对象（在x中）的形式返回该元素。如果未找到该元素，则 x 将包含 `null`。
* 通过标签名找到 HTML 元素
```javascript
var x=document.getElementById("main");
var y=x.getElementsByTagName("p");
```
* 通过类名找到 HTML 元素
```javascript
var x=document.getElementsByClassName("intro");
```

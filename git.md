
##新建/克隆代码库

**git init**
	
	当前目录新建一个Git代码库
**git clone [url]**

	下载一个项目和它的整个代码历史
	如: git clone git@github.com:xx/xx.git

## 添加/删除文件
**git add [f1][f2]...**

	添加指定文件到暂存区
**git add [dir]**

	添加指定目录到暂存区,包括子目录
**git add .**
	
	添加当前目录的所有文件到暂存区

**git rm [f1][f2]...**

	删除工作区文件,并且将这次删除放入暂存区
**git rm --cached [f]**

	停止追踪指定文件,但该文件会保留在工作区
**git mv [f] [f-renamed]**
	
	改名文件,并且将这个改名放入暂存区
##查看日志
**git status**

	显示所有变更文件

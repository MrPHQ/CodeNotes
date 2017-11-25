## 新建/克隆代码库

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
	git add -u -> 将当前已跟踪且已修改文件更新

**git rm [f1][f2]...**

	删除工作区文件,并且将这次删除放入暂存区
**git rm --cached [f]**

	停止追踪指定文件,但该文件会保留在工作区
**git mv [f] [f-renamed]**
	
	改名文件,并且将这个改名放入暂存区

## 代码提交
**git commit -m [msg]**

	提交暂存区所有文件到仓库区,并指定提交说明
	rm file -> git commit -am [msg]**
**git commit [f1] [f2] ... -m [msg]**

**git commit -a**

	提交工作区自上次commit之后的变化,直接到仓库区
## 撤销
**git checkout [file]**

	恢复暂存区的指定文件到工作区（注意区别分支操作中得 checkout 命令）
**git checkout [commit] [file]**

	恢复某个 commit 的指定文件到暂存区和工作区
**git checkout .**

	恢复暂存区的所有文件到工作区
**git reset [file]**
	
	重置暂存区的指定文件，与最新的 commit 保持一致，但工作区不变
**git reset --hard**

	重置暂存区与工作区，与最新的 commit 保持一致
## 远程同步
**git fetch [remote]**
	
	下载远程仓库的所有变动到暂存区
**git remote -v**

	显示所有远程仓库
**git remote show [remote]**
	
	显示某个远程仓库的信息
**git remote add [shortname] [url]**

	增加一个新的远程仓库，并命名
**git pull [remote] [branch]**

	取回远程仓库的变化，并与本地分支合并
**git push [remote] [branch]**

	上传本地指定分支到远程仓库
**git push [remote] --force**

	即使有冲突，强行推送当前分支到远程仓库
## 查看日志
**git status**

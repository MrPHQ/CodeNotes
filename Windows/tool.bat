@echo off
setlocal enabledelayedexpansion

REM 命令类型
SET CMD_TYPE=%1

REM 是否枚举子目录
SET PAR1=%2
SET PAR2=%3
SET PAR3=%4

for %%a in (%*) do set /a _NUM+=1

IF NOT DEFINED _NUM ( call:ECHO_BAT_CMD&GOTO END)
	
REM 枚举当前目录,并拷贝文件到所有枚举到的目录下
IF '%CMD_TYPE%' == '0' (
	IF NOT DEFINED _NUM ( ECHO "请输入3个参数,如:\r\n'tool.bat 0 0 E:\install_file\common\sciter32.dll'"&GOTO END)else (
		IF %_NUM% NEQ 3 ( ECHO.请输入3个参数,如:&ECHO.tool.bat 0 0 E:\install_file\common\sciter32.dll.&ECHO.&GOTO END)
	) 

	REM PAR2:源文件全路径
	REM 命令: tool.bat 0 0 E:\install_file\common\sciter32.dll

	IF "%PAR1%" == "1" (
		for /r /d %%i in (*) do (
			Xcopy %PAR2% %%~fi /y /q /O /e /i
		)
	)ELSE (
		for /d %%i in (*) do (
			Xcopy %PAR2% %%~fi /y /q /O /e /i
		)
	)
	GOTO END
)

REM 枚举当前目录,并拷贝指定目录下到所有文件到目录下
IF '%CMD_TYPE%' == '1' (
	IF NOT DEFINED _NUM ( ECHO "请输入3个参数,如:\r\n'tool.bat 1 0 E:\install_file\common'"&GOTO END)else (
		IF %_NUM% NEQ 3 ( ECHO.请输入3个参数,如:&ECHO.tool.bat 1 0 E:\install_file\common.&ECHO.&GOTO END)
	) 

	REM PAR2:源文件文件夹
	REM 命令: tool.bat 1 0 E:\install_file\common

	IF "%PAR1%" == "1" (
		for /r /d %%i in (*) do (
			for /r %PAR2% %%j in (*) do (
				if exist %%~dpi%%~nxi\%%~nxj (
					Del %%~dpi%%~nxi\%%~nxj /q
				)
				Xcopy %%~dpj%%~nxj %%~dpi%%~nxi /y /q /O /e /i
			)

		)
	)ELSE (
		for /d %%i in (*) do (
			for /r %PAR2% %%j in (*) do (
				if exist %%~dpi%%~nxi\%%~nxj (
					Del %%~dpi%%~nxi\%%~nxj /q
				)
				Xcopy %%~dpj%%~nxj %%~dpi%%~nxi /y /q /O /e /i
			)
		)
	)
	GOTO END
)

REM 枚举当前目录下的所有文件,并拷贝指定目录下替换同名的文件
IF '%CMD_TYPE%' == '2' (
	IF NOT DEFINED _NUM ( ECHO "请输入3个参数,如:\r\n'tool.bat 1 0 E:\install_file\common'"&GOTO END)else (
		IF %_NUM% NEQ 3 ( ECHO.请输入3个参数,如:&ECHO.tool.bat 1 0 E:\install_file\common.&ECHO.&GOTO END)
	) 

	REM PAR2:源文件文件夹
	REM 命令: tool.bat 2 0 E:\install_file\mssdk

	IF "%PAR1%" == "1" (
		
		for /r %PAR2% %%j in (*) do (
			SET V_TMP=*%%~nxj

			rem 枚举当前目录的所有文件.不包括目录. /R--递归.
			for /R %%i in (!V_TMP!) do (
				if exist %%i (
					rem Del %%i /q 不能删除,否则不知道是目录还是文件.
				)
				Xcopy %%~dpj%%~nxj %%i /y /q /O /e /i
				IF '%errorlevel%' NEQ '0' ( 
					ECHO %%~dpj%%~nxj "->" %%i "ERROR".
					pause 
				)
			)
		)

	)ELSE (
		for /r %PAR2% %%j in (*) do (
			SET V_TMP=*%%~nxj

			rem 枚举当前目录的所有文件.不包括目录.
			for %%i in (!V_TMP!) do (
				if exist %%i (
					rem Del %%i /q
				)
				Xcopy %%~dpj%%~nxj %%i /y /q /O /e /i
			)
		)
	)
	GOTO END
)

REM 枚举当前目录下的所有文件,并拷贝指定文件替换同名的文件
IF '%CMD_TYPE%' == '3' (
	IF NOT DEFINED _NUM ( ECHO "请输入4个参数,如:&ECHO.tool.bat 3 0 E:\install_file\mssdk\libaebellClient.dll libaebellClient.dll&ECHO.&GOTO END)else (
		IF %_NUM% NEQ 4 ( ECHO.请输入4个参数,如:&ECHO.tool.bat 1 0 E:\install_file\common.&ECHO.&GOTO END)
	) 

	REM PAR2:源文件全路径
	REM PAR3:过滤条件 如：查找指定文件 xx.dll
	REM 命令: tool.bat 3 0 E:\install_file\mssdk\libaebellClient.dll libaebellClient.dll
	
	SET V_TMP=*%PAR3%
	IF "%PAR1%" == "1" (
		
		rem 枚举当前目录的所有文件.不包括目录. /R--递归.
		for /R %%i in (!V_TMP!) do (
			if exist %%i (
				rem Del %%i /q 不能删除,否则不知道是目录还是文件.
			)
			Xcopy %PAR2% %%i /y /q /O /e /i
			IF '%errorlevel%' NEQ '0' ( 
				ECHO %PAR2% "->" %%i "ERROR".
				pause 
			)
		)

	)ELSE (
		for %%i in (!V_TMP!) do (
			Xcopy %PAR2% %%i /y /q /O /e /i
			IF '%errorlevel%' NEQ '0' ( 
				ECHO %PAR2% "->" %%i "ERROR".
				pause 
			)
		)
	)
	GOTO END
)

::--------------------------------------------------------  
::-- 函数部分开始  
::--------------------------------------------------------  
:ECHO_BAT_CMD    - here starts my function identified by it`s label 
rem ECHO -e "\033[30m 请输入命令,第一个参数为命令类型,如:\033[37m"
ECHO.
ECHO.请输入命令,第一个参数为命令类型,如:\
ECHO.tool.bat 0
ECHO.命令类型 0-枚举当前目录,并拷贝文件到所有枚举到的目录下
ECHO.命令类型 1-枚举当前目录,并拷贝指定目录下到所有文件到目录下
ECHO.
GOTO:EOF  

:END
pause
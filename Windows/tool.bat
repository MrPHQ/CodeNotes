@echo off
setlocal enabledelayedexpansion

REM ��������
SET CMD_TYPE=%1

REM �Ƿ�ö����Ŀ¼
SET PAR1=%2
SET PAR2=%3
SET PAR3=%4

for %%a in (%*) do set /a _NUM+=1

IF NOT DEFINED _NUM ( call:ECHO_BAT_CMD&GOTO END)
	
REM ö�ٵ�ǰĿ¼,�������ļ�������ö�ٵ���Ŀ¼��
IF '%CMD_TYPE%' == '0' (
	IF NOT DEFINED _NUM ( ECHO "������3������,��:\r\n'tool.bat 0 0 E:\install_file\common\sciter32.dll'"&GOTO END)else (
		IF %_NUM% NEQ 3 ( ECHO.������3������,��:&ECHO.tool.bat 0 0 E:\install_file\common\sciter32.dll.&ECHO.&GOTO END)
	) 

	REM PAR2:Դ�ļ�ȫ·��
	REM ����: tool.bat 0 0 E:\install_file\common\sciter32.dll

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

REM ö�ٵ�ǰĿ¼,������ָ��Ŀ¼�µ������ļ���Ŀ¼��
IF '%CMD_TYPE%' == '1' (
	IF NOT DEFINED _NUM ( ECHO "������3������,��:\r\n'tool.bat 1 0 E:\install_file\common'"&GOTO END)else (
		IF %_NUM% NEQ 3 ( ECHO.������3������,��:&ECHO.tool.bat 1 0 E:\install_file\common.&ECHO.&GOTO END)
	) 

	REM PAR2:Դ�ļ��ļ���
	REM ����: tool.bat 1 0 E:\install_file\common

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

REM ö�ٵ�ǰĿ¼�µ������ļ�,������ָ��Ŀ¼���滻ͬ�����ļ�
IF '%CMD_TYPE%' == '2' (
	IF NOT DEFINED _NUM ( ECHO "������3������,��:\r\n'tool.bat 1 0 E:\install_file\common'"&GOTO END)else (
		IF %_NUM% NEQ 3 ( ECHO.������3������,��:&ECHO.tool.bat 1 0 E:\install_file\common.&ECHO.&GOTO END)
	) 

	REM PAR2:Դ�ļ��ļ���
	REM ����: tool.bat 2 0 E:\install_file\mssdk

	IF "%PAR1%" == "1" (
		
		for /r %PAR2% %%j in (*) do (
			SET V_TMP=*%%~nxj

			rem ö�ٵ�ǰĿ¼�������ļ�.������Ŀ¼. /R--�ݹ�.
			for /R %%i in (!V_TMP!) do (
				if exist %%i (
					rem Del %%i /q ����ɾ��,����֪����Ŀ¼�����ļ�.
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

			rem ö�ٵ�ǰĿ¼�������ļ�.������Ŀ¼.
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

REM ö�ٵ�ǰĿ¼�µ������ļ�,������ָ���ļ��滻ͬ�����ļ�
IF '%CMD_TYPE%' == '3' (
	IF NOT DEFINED _NUM ( ECHO "������4������,��:&ECHO.tool.bat 3 0 E:\install_file\mssdk\libaebellClient.dll libaebellClient.dll&ECHO.&GOTO END)else (
		IF %_NUM% NEQ 4 ( ECHO.������4������,��:&ECHO.tool.bat 1 0 E:\install_file\common.&ECHO.&GOTO END)
	) 

	REM PAR2:Դ�ļ�ȫ·��
	REM PAR3:�������� �磺����ָ���ļ� xx.dll
	REM ����: tool.bat 3 0 E:\install_file\mssdk\libaebellClient.dll libaebellClient.dll
	
	SET V_TMP=*%PAR3%
	IF "%PAR1%" == "1" (
		
		rem ö�ٵ�ǰĿ¼�������ļ�.������Ŀ¼. /R--�ݹ�.
		for /R %%i in (!V_TMP!) do (
			if exist %%i (
				rem Del %%i /q ����ɾ��,����֪����Ŀ¼�����ļ�.
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
::-- �������ֿ�ʼ  
::--------------------------------------------------------  
:ECHO_BAT_CMD    - here starts my function identified by it`s label 
rem ECHO -e "\033[30m ����������,��һ������Ϊ��������,��:\033[37m"
ECHO.
ECHO.����������,��һ������Ϊ��������,��:\
ECHO.tool.bat 0
ECHO.�������� 0-ö�ٵ�ǰĿ¼,�������ļ�������ö�ٵ���Ŀ¼��
ECHO.�������� 1-ö�ٵ�ǰĿ¼,������ָ��Ŀ¼�µ������ļ���Ŀ¼��
ECHO.
GOTO:EOF  

:END
pause
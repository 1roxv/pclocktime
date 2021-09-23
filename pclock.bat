title pclock

set workfolder=%appdata%\PCLockTime
if not exist %workfolder%\ mkdir %workfolder%

::pclock
	call :time
	call :tgalert
	if %tgalert% EQU 1 tasklist | find /i "tgalert.exe" || start tgalert.exe

	:loop
		call :date
		if not exist %workfolder%/%date%.txt echo %time% >> %workfolder%/%date%.txt
		call :greptail
		if %greptail% LSS 1 call :lock & goto loop
		timer %greptail% >> %workfolder%/%date%.txt
		timeout 5
		if %greptail% LSS 1 (call :lock & goto loop) else (goto loop)
		

::other
	:date
		for /f %%s in ('PowerShell "$date = Get-Date; $date.ToString('yyyy-MM-dd')"') do set date=%%s
		exit /b

	:time
		for /F %%s in ('grep -oP "(?<=time:)[^;]*" %workfolder%\settings.txt') do set time=%%s
		exit /b

	:greptail
		call :date
		for /F %%s in ('grep -Eo [-0-9]+ %workfolder%/%date%.txt ^| tail -n1') do set greptail=%%s
		if %greptail% LSS 0 set greptail=1
		exit /b
		
	:tgalert
		for /F %%s in ('grep -oP "(?<=tgalert:)[^;]*" %workfolder%\settings.txt') do set tgalert=%%s
		exit /b
	
	:lock
		msg console /time:7 /v "The session will be blocked" & timeout 10
		@rundll32 user32.dll,LockWorkStation
		exit /b

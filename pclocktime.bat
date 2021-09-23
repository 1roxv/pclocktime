@echo off
title PCLockTime

if not exist bc.exe goto error
if not exist curl.exe goto error
if not exist grep.exe goto error
if not exist head.exe goto error
if not exist tail.exe goto error
if not exist pclock.exe goto error
if not exist timer.exe goto error

set workfolder=%appdata%\PCLockTime
if not exist %workfolder%\ mkdir %workfolder%

if exist %workfolder%\settings.txt (goto showtime) else (goto settings)


::settings
	:settingsecurity
		call :enterpassword
		if %enterpassword% EQU %password% (goto settings) else (goto settingsecurity)

	:settings
		cls
		if exist %workfolder%\settings.txt type %workfolder%\settings.txt & @echo.
		CHOICE /C YN /M "Enable notification on Telegram?"
		If %ErrorLevel% EQU 1 call :delsettings
		If %ErrorLevel% EQU 2 call :delsettings & echo tgalert:0; >> %workfolder%\settings.txt & goto settingsgeneral
		echo tgalert:1; >> %workfolder%\settings.txt
		set /p bot_token=Enter bot_token Telegram: 
		echo bot_token:%bot_token%; >> %workfolder%\settings.txt
		set /p chat_id=Enter chat_id Telegram: 
		echo chat_id:%chat_id%; >> %workfolder%\settings.txt
		set /p alert_interval=Enter interval for notifications in Telegram (min): 
		echo alert_interval:%alert_interval%; >> %workfolder%\settings.txt
		
	:settingsgeneral
		taskkill /f /t /fi "imagename eq pclock.exe" | @echo off
		taskkill /f /t /fi "imagename eq tgalert.exe" | @echo off
		set /p time=Enter time for use PC (min): 
		echo time:%time%; >> %workfolder%\settings.txt
		set /p password=Enter new password: 
		echo password:%password%; >> %workfolder%\settings.txt
		CHOICE /C YN /M "Add to Autostart?"
		If %ErrorLevel% EQU 1 powershell "$x=(New-Object -ComObject WScript.Shell).CreateShortcut('%appdata%\Microsoft\Windows\Start Menu\Programs\Startup\PCLockTime.lnk');$x.TargetPath='"%cd%\pclock.exe';$x.WorkingDirectory='%cd%';$x.Save()"
		If %ErrorLevel% EQU 2 del "%appdata%\Microsoft\Windows\Start Menu\Programs\Startup\pclocktime.lnk" > nul 2>nul & goto showtime


::showtime
	:showtime
		@echo off
		call :date
		if not exist %workfolder%\%date%.txt taskkill /f /t /fi "imagename eq pclock.exe" | @echo off
		call :start
		timeout 1 | @echo off
		call :timeleft
		cls
		echo Time Left: %timeleft% hours
		@echo.
		CHOICE /C SAN /T 60 /D N /M "Press S to Settings | Press A for Add time" /n
		If %ErrorLevel% EQU 1 goto settingsecurity
		If %ErrorLevel% EQU 2 goto addtimesecurity
		If %ErrorLevel% EQU 3 goto showtime


::addtime
	:addtimesecurity
		call :enterpassword
		if %enterpassword% EQU %password% (goto addtime) else (goto addtimesecurity)

	:addtime
		call :timeleft
		cls
		echo Time Left: %timeleft% hours
		@echo.
		set /p addtimemin=Add time (min): 
		taskkill /f /t /fi "imagename eq pclock.exe" | @echo off
		taskkill /f /t /fi "imagename eq tgalert.exe" | @echo off
		call :date
		call :greptail
		call :grephead
		del %workfolder%\%date%.txt | @echo off
		echo %grephead% + (%addtimemin%) | bc >> %workfolder%\%date%.txt
		echo %greptail% + (%addtimemin%) | bc >> %workfolder%\%date%.txt
		goto showtime


::other	
	:start
		tasklist | find /i /n "pclock.exe" > nul 2>nul || start pclock.exe
		exit /b
		
	:date
		for /f %%s in ('PowerShell "$date = Get-Date; $date.ToString('yyyy-MM-dd')"') do set date=%%s
		exit /b
	
	:greptail
		call :date
		for /F %%s in ('grep -Eo [-0-9]+ %workfolder%/%date%.txt ^| tail -n1') do set greptail=%%s
		exit /b
	
	:grephead
		call :date
		for /F %%s in ('grep -Eo [-0-9]+ %workfolder%/%date%.txt ^| head -n1') do set grephead=%%s
		exit /b
	
	:timeleft
		call :greptail
		for /F %%s in ('echo %greptail% / 60 ^| bc') do set var1=%%s
		for /F %%s in ('echo %greptail% - %var1% * 60 ^| bc') do set var2=%%s
		for /F %%s in ('echo %var1% + %var2% * 0.01 ^| bc') do set timeleft=%%s
		if %var1% LSS 10 set timeleft=0%timeleft%
		exit /b
		
	:password
		for /F %%s in ('grep -oP "(?<=password:)[^;]*" %workfolder%\settings.txt') do set password=%%s
		exit /b
		
	:enterpassword
		call :password
		set login=Enter password
		set userprompt="%login%"
		set subcommand=powershell "$p = Read-Host %userprompt% -AsSecureString; $p = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($p); $p=[Runtime.InteropServices.Marshal]::PtrToStringAuto($p); echo $p"
		set enterpassword=
		for /f "usebackq delims=" %%p in (`%subcommand%`) do set enterpassword=%%p
		exit /b
	
	:delsettings
		if exist %workfolder%\settings-old.txt del %workfolder%\settings-old.txt
		if exist %workfolder%\settings.txt ren "%workfolder%\settings.txt" settings-old.txt
		exit /b
		
	:error
		echo File required bc.exe
		echo File required curl.exe
		echo File required grep.exe
		echo File required head.exe
		echo File required tail.exe
		echo File required pclock.exe
		echo File required timer.exe
		pause

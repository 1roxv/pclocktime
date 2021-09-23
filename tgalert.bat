title tgalert

setlocal enabledelayedexpansion
set workfolder=%appdata%\PCLockTime
if not exist %workfolder%\ mkdir %workfolder%

call :alert_interval
call :bot_token
call :chat_id
call :date


::tgalert
	:loop
		timer %alert_interval%
		call :tgaddtime
		call :timelater
		call :message_id
		forfiles /p %workfolder% /m "tgsend.txt" /D 0 || goto newday
		curl -k "https://api.telegram.org/%bot_token%/deleteMessage?chat_id=%chat_id%&message_id=%message_id%"
		curl -k -o %workfolder%/tgsend.txt "https://api.telegram.org/%bot_token%/sendMessage?chat_id=%chat_id%&text=%timelater% hours used today"
		goto loop

	:newday
		call :date
		if not exist %workfolder%\%date%.txt call :restart & timer %alert_interval%
		curl -k -o %workfolder%/tgsend.txt "https://api.telegram.org/%bot_token%/sendMessage?chat_id=%chat_id%&text=%timelater% hours used today"
		goto loop


::other
	:alert_interval
		for /F %%s in ('grep -oP "(?<=alert_interval:)[^;]*" %workfolder%\settings.txt') do set alert_interval=%%s
		exit /b

	:bot_token
		for /F %%s in ('grep -oP "(?<=bot_token:)[^;]*" %workfolder%\settings.txt') do set bot_token=%%s
		exit /b

	:chat_id
		for /F %%s in ('grep -oP "(?<=chat_id:)[^;]*" %workfolder%\settings.txt') do set chat_id=%%s
		exit /b

	:message_id
		For /F %%s in ('grep -oP "(?<=message_id..)[^,]*" %workfolder%\tgsend.txt') do set message_id=%%s
		exit /b
		
	:date
		for /f %%s in ('PowerShell "$date = Get-Date; $date.ToString('yyyy-MM-dd')"') do set date=%%s
		exit /b

	:timelater
		call :greptail 
		call :grephead
		for /F %%s in ('echo %grephead% - %greptail% ^| bc') do set var1=%%s
		for /F %%s in ('echo %var1% / 60 ^| bc') do set var2=%%s
		for /F %%s in ('echo %var1% - %var2% * 60 ^| bc') do set var3=%%s
		for /F %%s in ('echo %var2% + %var3% * 0.01 ^| bc') do set timelater=%%s
		if %var2% lss 10 set timelater=0%timelater%
		exit /b
		
	:tgaddtime
		set i=0
		For /F "tokens=1* delims=[]" %%a in ('curl -k "https://api.telegram.org/%bot_token%/getUpdates?offset=-1" ^| grep "\%chat_id%" -B1 ^| grep -ioP "(?<=update_id)[^,]*|(?<=add)[^,]*" ^| grep -Eo [-0-9]+') do (
			set /a i+=1
			set tgaddtime!i!=%%a)
		if not defined tgaddtime2 exit /b
		set /a tgaddtime1=%tgaddtime1% + 1
		call :grephead
		call :greptail
		call :restart
		del  %workfolder%\%date%.txt
		if %tgaddtime2% GEQ 0 call :positivetail
		if %tgaddtime2% LSS 0 call :negativetail
		curl -k "https://api.telegram.org/%bot_token%/sendMessage?chat_id=%chat_id%&text=Addedя%tgaddtime2%яminutes"
		curl -k https://api.telegram.org/%bot_token%/getUpdates?offset=%tgaddtime1%
		set tgaddtime2=
		exit /b
		
	:positivetail
		echo %grephead% + (%tgaddtime2%) | bc >> %workfolder%\%date%.txt
		echo %greptail% + (%tgaddtime2%) | bc >> %workfolder%\%date%.txt
		exit /b
		
	:negativetail
		for /F %%s in ('echo %tgaddtime2% * -1 ^| bc') do set tgaddtime3=%%s
		if %tgaddtime3% LSS %greptail% call :positivetail & exit /b
		echo %grephead% - %greptail% | bc >> %workfolder%\%date%.txt
		echo %greptail% - %greptail% | bc >> %workfolder%\%date%.txt
		exit /b
		
	:grephead
		call :date
		for /F %%s in ('grep -Eo [-0-9]+ %workfolder%/%date%.txt ^| head -n1') do set grephead=%%s
		exit /b

	:greptail
		call :date
		For /F %%s in ('grep -Eo [-0-9]+ %workfolder%/%date%.txt ^| tail -n1') do set greptail=%%s
		exit /b
	
	:restart
		taskkill /f /t /fi "imagename eq timer.exe"
		exit /b

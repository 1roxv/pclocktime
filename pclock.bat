::[Bat To Exe Converter]
::
::YAwzoRdxOk+EWAnk
::fBw5plQjdG8=
::YAwzuBVtJxjWCl3EqQJgSA==
::ZR4luwNxJguZRRnk
::Yhs/ulQjdF+5
::cxAkpRVqdFKZSTk=
::cBs/ulQjdF+5
::ZR41oxFsdFKZSDk=
::eBoioBt6dFKZSDk=
::cRo6pxp7LAbNWATEpCI=
::egkzugNsPRvcWATEpCI=
::dAsiuh18IRvcCxnZtBJQ
::cRYluBh/LU+EWAnk
::YxY4rhs+aU+JeA==
::cxY6rQJ7JhzQF1fEqQJQ
::ZQ05rAF9IBncCkqN+0xwdVs0
::ZQ05rAF9IAHYFVzEqQJQ
::eg0/rx1wNQPfEVWB+kM9LVsJDGQ=
::fBEirQZwNQPfEVWB+kM9LVsJDGQ=
::cRolqwZ3JBvQF1fEqQJQ
::dhA7uBVwLU+EWDk=
::YQ03rBFzNR3SWATElA==
::dhAmsQZ3MwfNWATElA==
::ZQ0/vhVqMQ3MEVWAtB9wSA==
::Zg8zqx1/OA3MEVWAtB9wSA==
::dhA7pRFwIByZRRnk
::Zh4grVQjdCqDJGyX8VAMDB5HRxCNLFeOL5g5qdTr7OaIoUZTUfo6GA==
::YB416Ek+ZG8=
::
::
::978f952a14a936cc963da21a135fa983
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
		if %greptail% EQU 0 call :lock & goto loop
		timer %greptail% >> %workfolder%/%date%.txt
		timeout 5
		if %greptail% EQU 0 (call :lock & goto loop) else (goto loop)
		

::other
	:date
		for /f %%s in ('PowerShell "$date = Get-Date; $date.ToString('yyyy-MM-dd')"') do set date=%%s
		exit /b

	:time
		for /F %%s in ('grep -oP "(?<=time:)[^;]*" %workfolder%\settings.txt') do set time=%%s
		exit /b

	:greptail
		call :date
		for /F %%s in ('grep -Eo [0-9]+ %workfolder%/%date%.txt ^| tail -n1') do set greptail=%%s
		exit /b
		
	:tgalert
		for /F %%s in ('grep -oP "(?<=tgalert:)[^;]*" %workfolder%\settings.txt') do set tgalert=%%s
		exit /b
	
	:lock
		msg console /time:7 /v "The session will be blocked" & timeout 10
		@rundll32 user32.dll,LockWorkStation
		exit /b
@rem AUTHOR: Miguel Diaz
@rem DESCRIPTION: This batch script takes a text file with imaged host's names separated by newlines
@rem as an argument and connects to each host via tightvnc
@echo off

set toWipe=%1

tasklist | find "tvnserver.exe" > NUL
if errorlevel 1 tvnserver -start -silent

for /f %%h in (%toWipe%) do (
  echo Connecting to %%h ...
  powershell -command "$hostIP = [System.Net.Dns]::GetHostAddresses('%%h').IPAddressToString[0]; ping -n 1 $hostIP > $NULL; if (($? -imatch 'True')) { Start-Process tvnviewer $hostIP -Wait }"
)

@rem AUTHOR: Miguel Diaz
@rem Description: Downloads HP's bios configuration command-line utility to 
@rem disable secure boot and boot into a USB device
@echo off

set downloadDir=C:\Users\%USERNAME%\Downloads
set downloadLink="https://ftp.hp.com/pub/softpaq/sp143501-144000/sp143621.exe"
set configExe="sp143621.exe"
set configDir="sp143621"

for /f "tokens=*" %%i in ('wmic bios get manufacturer ^| find /I "hp"') do set hostMake=%%i

if %ERRORLEVEL% neq 0 (
  echo Not an HP computer. Exiting.
  ping -n ::1 > NUL
) ^
else (
  curl --output-dir %downloadDir% -LO %downloadLink%
  cd %downloadDir%
  .\%configExe%

  powershell -Command ^
    Get-Content config.txt -replace '\*Legacy Support Disable and Secure Boot Enable', 'Legacy Support Disable and Secure Boot Enable'; ^
    Get-Content config.txt -replace '\Legacy Support Disable and Secure Boot Disable', '*Legacy Support Disable and Secure Boot Disable'; ^
    Get-Content config.txt 'HDD:M.2:1', 'HDD:USB:1' ^| Out-File -FilePath C:\SWSetup\%configDir%\config.txt
    shutdown /r /t 3
)

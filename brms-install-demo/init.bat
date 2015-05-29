@ECHO OFF
setlocal

set PROJECT_HOME=%~dp0
set DEMO=Install Demo
set AUTHORS=Andrew Block, Eric D. Schabell
set PROJECT=git@github.com:jbossdemocentral/brms-install-demo.git
set PRODUCT=JBoss BRMS
set JBOSS_HOME=%PROJECT_HOME%\target\jboss-eap-6.4
set SERVER_DIR=%JBOSS_HOME%\standalone\deployments\
set SERVER_CONF=%JBOSS_HOME%\standalone\configuration\
set SERVER_BIN=%JBOSS_HOME%\bin
set SRC_DIR=%PROJECT_HOME%installs
set SUPPORT_DIR=%PROJECT_HOME%\support
set PRJ_DIR=%PROJECT_HOME%\projects
set BRMS=jboss-brms-6.1.0.GA-installer.jar
set EAP=jboss-eap-6.4.0-installer.jar
set VERSION=6.1

REM wipe screen.
cls

echo.
echo #################################################################
echo ##                                                             ##   
echo ##  Setting up the %DEMO%                                ##
echo ##                                                             ##   
echo ##                                                             ##   
echo ##     ####  ####   #   #   ###    #####                       ##
echo ##     #   # #   # # # # # #       #                           ##
echo ##     ####  ####  #  #  #  ##     #####                       ##
echo ##     #   # # #   #     #    #    #   #                       ##
echo ##     ####  #  #  #     # ###     #####                       ##
echo ##                                                             ##   
echo ##                                                             ##   
echo ##  brought to you by,                                         ##   
echo ##             %AUTHORS%                  ##
echo ##                                                             ##   
echo ##  %PROJECT%      ##
echo ##                                                             ##   
echo #################################################################
echo.

REM make some checks first before proceeding.	
if exist %SRC_DIR%\%EAP% (
        echo Product sources are present...
        echo.
) else (
        echo Need to download %EAP% package from the Customer Support Portal
        echo and place it in the %SRC_DIR% directory to proceed...
        echo.
        GOTO :EOF
)

if exist %SRC_DIR%\%BRMS% (
        echo Product sources are present...
        echo.
) else (
        echo Need to download %BRMS% package from the Customer Support Portal
        echo and place it in the %SRC_DIR% directory to proceed...
        echo.
        GOTO :EOF
)

REM Remove the old JBoss instance, if it exists.
if exist %JBOSS_HOME% (
         echo - removing existing JBoss product install...
         echo.
        
         rmdir /s /q "%JBOSS_HOME%"
 )


REM Run installers.
echo EAP installer running now...
echo.
call java -jar %SRC_DIR%/%EAP% %SUPPORT_DIR%\installation-eap -variablefile %SUPPORT_DIR%\installation-eap.variables


if not "%ERRORLEVEL%" == "0" (
  echo.
	echo Error Occurred During JBoss EAP Installation!
	echo.
	GOTO :EOF
)

echo JBoss BRMS installer running now...
echo.
call java -jar %SRC_DIR%/%BRMS% %SUPPORT_DIR%\installation-brms -variablefile %SUPPORT_DIR%\installation-brms.variables

if not "%ERRORLEVEL%" == "0" (
	echo Error Occurred During %PRODUCT% Installation!
	echo.
	GOTO :EOF
)

echo - enabling demo accounts role setup in application-roles.properties file...
echo.
xcopy /Y /Q "%SUPPORT_DIR%\application-roles.properties" "%SERVER_CONF%"
echo. 

echo - setting up standalone.xml configuration adjustments...
echo.
xcopy /Y /Q "%SUPPORT_DIR%\standalone.xml" "%SERVER_CONF%"
echo.

echo - setup email task notification users...
echo.
xcopy "%SUPPORT_DIR%\userinfo.properties" "%SERVER_DIR%\business-central.war\WEB-INF\classes\"

echo - install JBoss BRMS Cool Stor online retail web shopping cart application...
echo.
xcopy "%SUPPORT_DIR%\brms-coolstore-demo.war" "%SERVER_DIR%"

echo.
echo You can now start the %PRODUCT% with %SERVER_BIN%\standalone.bat
echo.
echo You can open business central in browser at:
echo.
echo  localhost:8080/business-central 
echo.
echo and login as user: erics and password: jbossbrms1!
echo.
echo %PRODUCT% %VERSION% %DEMO% Setup Complete.
echo.
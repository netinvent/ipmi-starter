::@echo off

:: Basic javaws loader for IRMC / KVM / iLo / IMM etc that use have sh*tty support and don't work with elder java versions
:: Usage: javaws "c:\path\to\your\viewer.jnlp" [version]

:: 2022-10-07: Initial version

set curdir=%~dp0
set curdir=%curdir:~0,-1%


:: JRE / JDK & IcedTea sources


:: JavaWS implementation, download at https://github.com/AdoptOpenJDK/IcedTea-Web/releases/download/icedtea-web-1.8.8/icedtea-web-1.8.8.portable.bin.zip
:: Icedtea needs to be unzipped into .\icedtea-web-image
SET ICEDTEA=icedtea-web-image

:: Java JRE 1.6, see Oracle archives at https://www.oracle.com/java/technologies/downloads/archive/
:: Needed file is with MD5 checksum jre-6u45-windows-i586.zip with MD5 checksum BADF6A8A2A4E8D6D8A9354CCCE29FC50
SET JRE16=jre1.6.0_45

:: Java JRE 1.7, download at https://javadl.sun.com/webapps/download/AutoDL?BundleId=76860
:: Needed file is jre-7u80-windows-i586.exe with MD5 checksum f2fd417b6d5c7ffc501c7632cc811c3e, see https://www.oracle.com/webfolder/s/digest/7u80checksum.html
:: When using an exe file instead of a zip file, one needs to transform the pack files in the lib directory to jar files, see jre_exe_to_portable.cmd
SET JRE17=jre1.7.0_21

:: OpenJDK 1.8, download at https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u345-b01/OpenJDK8U-jdk_x86-32_windows_hotspot_8u345b01.zip (or https://adoptium.net/download)
SET JDK18=jdk8u345-b01


:MENU
IF /I "%2"=="JRE16" GOTO JAVA16
IF /I "%2"=="JRE17" GOTO JAVA17
GOTO JDK18

:JAVA16
SET JAVA_HOME=%curdir%\%JRE16%
SET JAVAWS_DIR=%JRE16%\bin
GOTO JAVAWS

:JAVA17
SET JAVA_HOME=%curdir%\%JRE17%
SET JAVAWS_DIR=%JRE17%\bin
GOTO JAVAWS

:JDK18
SET JAVA_HOME=%curdir%\%JDK18%
SET JAVAWS_DIR=%ICEDTEA%\bin
GOTO JAVAWS



:JAVAWS
:: If no file argument was given, ask for the path for the jnlp file here
IF NOT %1=="" SET JNLP_PATH=%1
IF %1=="" SET /P JNLP_PATH=Please give the full path to your jnlp file: 

:: Launching javaws with given jnlp file argument
:: We don't specify javaws.exe or .bat since it depends on java implementation
:: -verbose is required for java 1.7 to show it's security warning
"%JAVAWS_DIR%\javaws" -verbose %JNLP_PATH%
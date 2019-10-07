
@SET POWER_SELL_EXE=%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe
@SET POWER_SHELL_COMMAND=-NoProfile -InputFormat None -ExecutionPolicy Bypass -Command

::RUN APK

@SET APK=%1
@SET APK=###%APK%###
@SET APK=%APK:"###=%
@SET APK=%APK:###"=%
@SET APK=%APK:###=%

@echo %APK%
::@SET APK="C:\workspace\magic-crush\AgeOfGemsMatch3Game.apk"
@SET DUMP_FILE=%APK%.dump

::CLEAR
@IF EXIST "%DUMP_FILE%" (del "%DUMP_FILE%")

::MAKE DUMP
@aapt dump badging "%APK%" > "%DUMP_FILE%"

@echo === GET PRODUCT ===
:: BEGIN GET PACKAGE
@SET TEMP_PS1="%DUMP_FILE%.PS1"
@echo $DUMP_FILE=[System.IO.File]::ReadAllText($args[0]);  > %TEMP_PS1%
@echo $DUMP_STR = (New-Object -TypeName String $DUMP_FILE); >> %TEMP_PS1%
@echo $SEARCH = "package: name='"; >> %TEMP_PS1%
@echo $START_PACKAGE_INDEX = $DUMP_STR.IndexOf($SEARCH) + $SEARCH.Length; >> %TEMP_PS1%
@echo $END_PACKAGE_INDEX = $DUMP_STR.IndexOf("'", $START_PACKAGE_INDEX); >> %TEMP_PS1%
@echo $LEN=($END_PACKAGE_INDEX - $START_PACKAGE_INDEX); >> %TEMP_PS1%
@echo $PACKAGE = $DUMP_STR.Substring($START_PACKAGE_INDEX, $LEN); >> %TEMP_PS1%
@echo Write-Output $PACKAGE; >> %TEMP_PS1%
:: END GET PACKAGE

powershell -executionpolicy bypass -File %TEMP_PS1% "%DUMP_FILE%" > "%DUMP_FILE%.product"

SET /p PRODUCT=<"%DUMP_FILE%.product"

@IF EXIST %TEMP_PS1% (del %TEMP_PS1%)
@IF EXIST "%DUMP_FILE%.product" (del "%DUMP_FILE%.product")

@echo PRODUCT: %PRODUCT%
@echo ===================
@echo 

@echo === GET LAUNCH_ACTIVITY ===
:: BEGIN GET LAUNCH_ACTIVITY
@SET TEMP_PS1="%DUMP_FILE%.PS1"
@echo $DUMP_FILE=[System.IO.File]::ReadAllText($args[0]);  > %TEMP_PS1%
@echo $DUMP_STR = (New-Object -TypeName String $DUMP_FILE); >> %TEMP_PS1%
@echo $SEARCH = "launchable-activity: name='"; >> %TEMP_PS1%
@echo $START_PACKAGE_INDEX = $DUMP_STR.IndexOf($SEARCH) + $SEARCH.Length; >> %TEMP_PS1%
@echo $END_PACKAGE_INDEX = $DUMP_STR.IndexOf("'", $START_PACKAGE_INDEX); >> %TEMP_PS1%
@echo $LEN=($END_PACKAGE_INDEX - $START_PACKAGE_INDEX); >> %TEMP_PS1%
@echo $PACKAGE = $DUMP_STR.Substring($START_PACKAGE_INDEX, $LEN); >> %TEMP_PS1%
@echo Write-Output $PACKAGE; >> %TEMP_PS1%
:: END GET LAUNCH_ACTIVITY

powershell -executionpolicy bypass -File %TEMP_PS1% "%DUMP_FILE%" > "%DUMP_FILE%.la"

SET /p LAUNCH_ACTIVITY=<"%DUMP_FILE%.la"

@IF EXIST %TEMP_PS1% (del %TEMP_PS1%)
@IF EXIST "%DUMP_FILE%.la" (del "%DUMP_FILE%.la")

@echo LAUNCH_ACTIVITY: %LAUNCH_ACTIVITY%
@echo ===================
@echo 

adb shell am start -n %PRODUCT%/%LAUNCH_ACTIVITY%

::DELETE dump file
@IF EXIST "%DUMP_FILE%" (del "%DUMP_FILE%")
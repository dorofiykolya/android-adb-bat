::RUN APK

@SET APK=%1
@SET APK=###%APK%###
@SET APK=%APK:"###=%
@SET APK=%APK:###"=%
@SET APK=%APK:###=%

@echo %APK%
@SET DUMP_FILE=%APK%.dump

::CLEAR
@IF EXIST "%DUMP_FILE%" (del "%DUMP_FILE%")

::MAKE DUMP
@aapt dump badging "%APK%" > "%DUMP_FILE%"
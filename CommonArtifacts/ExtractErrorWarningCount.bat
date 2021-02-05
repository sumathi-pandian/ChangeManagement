@echo off
Setlocal EnableDelayedExpansion

rem set fileName=NoErr.html
set fileName=eslint.result.html
rem set fileName=lintres.html


rem Extract the line where ESLint Report and error warning count is generated 
for /f "tokens=* delims= " %%i in ('FINDSTR /N "<h1>ESLint Report</h1>" !fileName!') do (
set line=%%i
echo ESLint Line = !line!
set lineNum=!line:~0,5!
)

rem Extract the line number 
FOR /F "tokens=1,2 delims=:" %%j in ("!LineNum!") do (
  set lineNumber=%%j
  echo Line Number=!lineNumber!
)
set /a newLine=lineNumber+1
echo New Line=!newLine!

rem Extract the line where error and warnings counts are available 
for /F "skip=%newLine% delims=" %%k in (!fileName!) do (
set finalline=%%k
echo ErrWarLine =!finalline!
goto :out
)


:out
set _string=!finalline!
rem Split the line to extract errors and warnings 
for /f "tokens=2 delims=>" %%a in ("%_string%") do (
  set tempMidStr1=%%a
)
echo TempMidleString1=!tempMidStr1!  

set _string=!tempMidStr1!
for /f "tokens=1 delims=<" %%a in ("%_string%") do (
  set tempMidStr2=%%a
)
echo TempMidleString2=!tempMidStr2!  

rem If there are no errors or warnings just exit gracefully 
if "!tempMidStr2!" == "0 problems" (
  echo No Errors YAY 
  goto :end
)

rem Else extract the actual counts 
set _string=!tempMidStr2!
for /f "tokens=1,2 delims=," %%a in ("%_string%") do (
  set tempWarStr3=%%b
  set tempMidStr4=%%a
)
echo TempWarningString3=!tempWarStr3!
echo TempMidleString4=!tempMidStr4!


FOR /F "tokens=1,2 delims=(" %%l in ("%tempMidStr4%") do (
  set tempErrStr5=%%m
  set tempErrStr6=%%l
)

rem Extract the count of errors  
FOR /F "tokens=1,2 delims= " %%l in ("%tempErrStr5%") do (
  set errCnt=%%l
  set tempErrStr7=%%m
)

rem Extract the count of warnings 
FOR /F "tokens=1,2 delims= " %%n in ("%tempWarStr3%") do (
  set warnCnt=%%n
  set tempErrStr8=%%o
)

echo Error Count is=%errCnt%
echo %tempErrStr5%
echo Warning Count is=%warnCnt%
echo %tempErrStr8%



rem STOP processing the build if the count of errors is more than 0 
rem STOP processing the build if the count of warnings is more than 10 
if %errCnt% GTR 0 echo 1
if %warnCnt% GTR 10 echo 1


  
:end
@echo on

@echo off
setlocal EnableDelayedExpansion
setlocal EnableExtensions

set arch=C:\tmp\archive
set exc=C:\tmp\Exceptions

:: Setting up logfiles
set _logfile=C:\tmp\logs
set newdate=%DATE%
set logmonth=%newdate:~7,2%
set logyear=%newdate:~-4%
set logdate=%newdate:~-10%
set _logfile=%_logfile%\clf-%logyear%-%logmonth%.log
echo %logdate%, %time%: Entering script. >> "!_logfile!"
set sizelim=2097152

REM this is actually the quickest way - only have to wait for the one dir command to finish, then we process the output
for /f "skip=4 tokens=1,2,3,4,*" %%a in ('dir /s /a-d /-c "%arch%"') do (
  REM grab the parent directory as we process the files
  if %%a==Directory (
    set parent=
    set parent=%%c %%d %%e
    REM this just removes any trailing spaces - if %e isn't equivalent to anything it will just strip these out
    for /l %%x in (1,1,100) do if "!parent:~-1!"==" " set parent=!parent:~0,-1!
  ) else (
    REM the dir /s method has this drawback, it lists *every line* including the summary, this skips it
    if NOT %%d==bytes (
      REM here we do the size comparison, and if its over ... move it to exceptions.
      if %%d GEQ %sizelim% (
        echo %logdate%, %time%: Oversize file found ^(%%d^ - %%e). Moving.>>"!_logfile!"
        move "!parent!\%%e" "!exc!"
      )
    )
  )
)



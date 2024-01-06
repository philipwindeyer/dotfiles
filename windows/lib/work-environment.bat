@echo off

setlocal
set ELECTRON_NO_ATTACH_CONSOLE=true

START "Visual Studio Code" "C:\Users\phili\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Visual Studio Code\Visual Studio Code.lnk"
START "Sublime Text" "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Sublime Text.lnk"
START "Notion" "C:\Users\phili\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Notion.lnk"
START "Google Chrome" "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Google Chrome.lnk"
START "ClickUp" "C:\Users\phili\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\ClickUp.lnk"
START "KeeWeb" "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\KeeWeb\KeeWeb.lnk"
@REM Terminal
wt

@REM TODO: Supplemental (not in regular use currently):
@REM START "Slack" "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Slack Technologies Inc\Slack.lnk"
@REM MySQLWorkbench
@REM Trello

@REM TODO: After I install dedicated app containers:
@REM Gmail
@REM Calendar
@REM Google Meet

endlocal

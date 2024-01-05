@REM TODO Generate a work-environment shortcut to this and move to home directory (so it can be searched and triggered from Start Menu)
@REM TODO: Start these all as indepedent parent processes (i.e. should not be tied to whatever shell session this is started in)

@REM Visual Studio Code
START /B "" "C:\Users\phili\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Visual Studio Code\Visual Studio Code.lnk"

@REM Sublime Text
START /B "" "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Sublime Text.lnk"

@REM Terminal
wt

@REM Notion
START /B "" "C:\Users\phili\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Notion.lnk"

@REM Google Chrome
START /B "" "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Google Chrome.lnk"


@REM ClickUp
START /B "C:\Users\phili\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\ClickUp.lnk"



@REM KeeWeb
START /B "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\KeeWeb\KeeWeb.lnk"

@REM TODO: Supplemental (not in regular use currently):
@REM Slack
@REM START /B "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Slack Technologies Inc\Slack.lnk"

@REM MySQLWorkbench
@REM Trello


@REM TODO: After I install dedicated app containers:
@REM Gmail
@REM Calendar
@REM Google Meet

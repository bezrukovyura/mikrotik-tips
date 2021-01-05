# How use
# System -> scheduler -> add 
# Name -> "Email after reload"
# Start date -> "Jan/05/2021"
# Start time -> "startup"
# interval -> "00:00:00"

:while ( [/system ntp client get status]!="synchronized" ) do={ :delay 10s }
:delay 10s
/log info "time updated; uptime: $[/system resource get uptime]"
:local es "$[/system identity get name] rebooted on $[/system clock get date] $[/system clock get time] uptime $[/system resource get uptime]"
:delay 90s
:local eb "Log contents (with 90 seconds delay):\r\n"

:foreach le in=[/log print as-value] do={
  :set eb ($eb.[:tostr [($le->"time")]]." ".[:tostr [($le->"topics")]].": ".[:tostr [($le->"message")]]."\r\n")
}
/tool e-mail send to="bezrukov-yra@mail.ru" subject=$es body=$eb
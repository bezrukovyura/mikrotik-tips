# How use
# System -> scheduler -> add 
# Name -> "reboot after 5 min 95% cpu usage"
# Start date -> "Jan/05/2021"
# Start time -> "startup"
# interval -> "00:00:10"

:local cpuload 0
:global cpuarray
:local arraylen 0
:local arraypos 0
:local arraytot 0
:global avgcpuload 0
:global highavgcpuload

# arraysize is the number of cpu-Load samples to keep
# Experiment with this value to incease or decrease the number of samples
# The greater the value the longer the time that the cpu-load average is calculated for.
:local arraysize 12

# Get cpu-load samples, limit cpuarray to array size
:set cpuload [/system resource get cpu-load]
:set cpuarray ( [:toarray $cpuload] + $cpuarray )
:set cpuarray [:pick $cpuarray 0 $arraysize]

# add up all values in array
:set arraypos 0
:set arraylen [:len $cpuarray]
:while ($arraypos < $arraylen) do={
:set arraytot ($arraytot + [:pick $cpuarray $arraypos] );
:set arraypos ($arraypos +1)}

# divide sum of array values by the number of values in cpuarray
:set avgcpuload ($arraytot / [:len $cpuarray])
:if ([:len $highavgcpuload] = 0) do={:set highavgcpuload $avgcpuload}
:if ([$highavgcpuload] < [$avgcpuload]) do={:set highavgcpuload $avgcpuload}


:if ($avgcpuload >= 60)  do={
# Display results in Terminal window
:log info ("CPU Load - Avg: $avgcpuload High: $highavgcpuload")
:log info $cpuarray
}

:if ($avgcpuload >= 97)  do={ /system reboot; }
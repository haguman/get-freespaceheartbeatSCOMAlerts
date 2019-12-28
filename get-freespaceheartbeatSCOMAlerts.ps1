$LogicalDiskalerts = @()
$heartbeatfailures = @()
$alerts = @()
$SCOMServer = "SCOM_Server.fqdn.com"

New-SCOMManagementGroupConnection -ComputerName $SCOMServer
$SCOMSession = get-SCOMManagementGroupConnection -ComputerName $SCOMServer
$alerts = Get-SCOMAlert -ResolutionState (0..254) -SCSession $SCOMSession | select *
$LogicalDiskalerts += $alerts | ?{$_.Name -like "*Logical Disk*Free Space*" -and $_.MonitoringObjectInMaintenanceMode -eq $false} | sort TimeRaised |select MonitoringObjectDisplayName,TimeRaised,Priority,IsMonitorAlert,MonitoringObjectHealthState,MonitoringObjectInMaintenanceMode,Description, TicketID
$heartbeatfailures += $alerts | ? {$_.Name -like "*Heartbeat*" -and $_.MonitoringObjectInMaintenanceMode -eq $false} | sort TimeRaised |select MonitoringObjectDisplayName,TimeRaised,Priority,IsMonitorAlert,MonitoringObjectHealthState,MonitoringObjectInMaintenanceMode,Description, TicketID
Get-SCOMManagementGroupConnection | Remove-SCOMManagementGroupConnection

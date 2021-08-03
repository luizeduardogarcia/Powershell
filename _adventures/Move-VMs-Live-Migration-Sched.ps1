## type host node name bellow
$server  = 'SOME-CLUSTER-NODE'

## define a simple log control file
$control = "C:\Infra\Logs\live-migration-control-$server.txt"

## get all clustered VMs in that host node
$vms = Get-VM -ComputerName $server | where { $_.IsClustered -eq $true }

## output all VMs names to that log control file
$vms | foreach { Add-Content $control -Value $_.Name }

## Pause that node with Drain Roles
Suspend-ClusterNode -Name $server -Drain -ForceDrain

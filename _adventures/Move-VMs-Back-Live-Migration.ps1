## type host node name bellow
$server  = 'SOME-CLUSTER-NODE'

## in order to prevent errors, let's check if the node is paused
## Resume that node with fail back
if ((Get-ClusterNode -Name $server).State -eq 'Paused') {
    Resume-ClusterNode -Name $server -Failback Immediate
}

## after resume the node, wait until live migrations are finish
## will check within 60 seconds interval if still exists VMs migrating or in the migration queue
while (Get-VM -ComputerName (Get-ClusterNode -Cluster 'SOME-CLUSTER') | where { $_.IsClustered -and $_.Status -ne 'Operating normally' }) {
    Start-Sleep -Seconds 60
}

## remember our simple log control file?
$control = "C:\Infra\Logs\live-migration-control-$server.txt"

## getting it's content, that mean, our VMs on that host node
$vms = Get-Content $control

#let's check if they went back properlly
foreach ($vmName in $vms) {
    ## get the VM as a cluster role/group
    $vm = Get-ClusterGroup -Name $vmName.ToString()
    $on = $vm.OwnerNode.Name
    $st = $vm.State

    if ($vm.OwnerNode.Name -ne $server) {
        ## if the VM is online, the move type will be Live, otherwise Quick
        $mt = if ($vm.State -eq 'Online') { 'Live' } else { 'Quick' }
        
        ## move it!
        Move-ClusterVirtualMachineRole -Name $vm.Name -Node $server -MigrationType $mt -Wait 0
    }
}

## empty the log control file
Clear-Content $control

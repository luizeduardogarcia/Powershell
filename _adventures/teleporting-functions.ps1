# if the given ip address ($ipaddr) is not found on the interface 'Internet', then add it.
function Test-IPAddress {
    param ($ipaddr)

    $return = @{success = $true}

    if ((Get-NetIPAddress -InterfaceAlias 'Internet' -AddressFamily IPv4).IPAddress -notcontains $ipaddr) {
        try {
            New-NetIPAddress -IPAddress $ipaddr -InterfaceAlias 'Internet' -AddressFamily IPv4 -PrefixLength 22 -ErrorAction Continue -Confirm:$false
        }
        catch {
            $return.success = $false
            $return.Add('message',$_)
        }
    }

    return $return
}

# if the given ip address ($ipaddr) is found on the interface 'Internet', then remove it.
function Remove-IPAddress {
    param ($ipaddr)

    $return = @{success = $true}

    if ((Get-NetIPAddress -InterfaceAlias 'Internet' -AddressFamily IPv4).IPAddress -contains $ipaddr) {
        try {
            Remove-NetIPAddress -IPAddress $ipaddr -InterfaceAlias 'Internet' -AddressFamily IPv4 -PrefixLength 22 -ErrorAction Continue -Confirm:$false
        }
        catch {
            $return.success = $false
            $return.Add('message',$_)
        }
    }

    return $return
}

# save the code of function Test-IPAddress on the $fn_testip variable
$code_fn_testip = "function Test-IPAddress { ${function:Test-IPAddress} }"

# save the code of function Remove-IPAddress on the $fn_remip variable
$code_fn_remip  = "function Remove-IPAddress { ${function:Remove-IPAddress} }"

# define the servers that we want to execute our functions
$servers   = @('ServerA','ServerB','ServerWE')

foreach ($server in $servers) {
    Invoke-Command -ComputerName $server -ScriptBlock {
        param(
            $fn_testip,
            $fn_remip,
            $ip_to_remove,
            $ip_to_add
        )

        # this will list the assigned ipv4 ip addresses to the interface
        filter ListIPAddress { (Get-NetIPAddress | where { $_.AddressFamily -eq 'IPv4' -and $_.InterfaceAlias -eq 'Internet' }).IPAddress }

        # declaring our functions: test-ipaddress, remove-ipaddress (note the dot-sourcing at the startof the line)
        . ([ScriptBlock]::Create($fn_testip))
        . ([ScriptBlock]::Create($fn_remip))

        # some visual guidance of which server we are
        Write-Host $env:computername -ForegroundColor Yellow

        # let´s try to remove it
        Write-Host "Trying to remove the IP $ip_to_remove" -ForegroundColor Yellow
        $remove_exec = Remove-IPAddress($ip_to_remove)

        if ($remove_exec.success) {
            Write-Host "We did it! The IP Address $ip_to_remove was successefully removed." -ForegroundColor Green
        } else {
            Write-Host "Something went wrong, check it out... $($remove_exec.message)" -ForegroundColor Red
        }

        # now, let´s try to add the another one
        Write-Host "Trying to add the IP $ip_to_add" -ForegroundColor Yellow
        $add_exec = Test-IPAddress($ip_to_add)

        if ($add_exec.success) {
            Write-Host "We did it! The IP Address $ip_to_add was successefully removed." -ForegroundColor Green
        } else {
            Write-Host "Something went wrong, check it out... $($add_exec.message)" -ForegroundColor Red
        }

        # finally, list the ip address on the interface
        Write-Host (ListIPAddress) -ForegroundColor Green
    } -ArgumentList ($code_fn_testip,$code_fn_remip,'172.1.2.123','172.1.2.99')
}
# note that our local copy of the functions goesthrough argument list as simple variables!
 

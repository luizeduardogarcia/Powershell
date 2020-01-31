<#
.Synopsis
   Convert a Json output to Powershell Hashtable object, and return it
.DESCRIPTION
   Convert a Json output from a Json file, web-request from an API, etc., to Powershell Hashtable object, and return it   
.PARAMETER InputObject
   The Json output from a file, api result, etc.
.EXAMPLE
    #defining the json file content
    $json = "{`"$($env:COMPUTERNAME)`":{`"Description`":`"This is an exemple`"}}"

    #writing it to a file
    Set-Content "$($env:USERPROFILE)\Documents\config.json" -Value $json

    #get the json file content as a hashtable
    $configJson = Get-Content "$($env:USERPROFILE)\Documents\config.json" | ConvertFrom-Json | ConvertTo-Hashtable

    #using it
    $configJson[$env:COMPUTERNAME].Description   
#>
function ConvertTo-Hashtable
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([hashtable])]
    Param
    (
        [Parameter(
            Mandatory=$true,
            ValueFromPipeline=$true,
            Position=0
            )
        ]
        $InputObject
    )

    Process
    {
        if ($null -eq $InputObject)
        {
            return $null
        }

        if ($InputObject -is [System.Collections.IEnumerable] -and $InputObject -isnot [string])
        {
            $collection = @(
                foreach ($object in $InputObject)
                {
                    ConvertTo-Hashtable -InputObject $object
                }
            )
 
            Write-Output -NoEnumerate $collection
        }
        elseif ($InputObject -is [psobject])
        {
            $hash = @{}
            foreach ($property in $InputObject.PSObject.Properties)
            {
                $hash[$property.Name] = ConvertTo-Hashtable -InputObject $property.Value
            }
            
            $hash
        }
        else
        {
            $InputObject
        }
    }
}

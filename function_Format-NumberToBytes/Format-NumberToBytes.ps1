<#
.Synopsis
   Convert a given number out to Bytes, KBytes, MBytes and GBytes
.DESCRIPTION
   Convert a given number out to Bytes, KBytes, MBytes and GBytes, rounding it with 2 decimal digits, returning a string with the resumed unit with it
.PARAMETER Number
   The number to be formated
.EXAMPLE
   Format-NumberToBytes -Number 12345678
.EXAMPLE
   (123456789,456789123,789456123) | Format-NumberToBytes
#>
function Format-NumberToBytes
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([string])]
    Param
    (
        # Number to be formated
        [Parameter(
            Mandatory=$true,
            ValueFromPipeline=$true,
            Position=0
            )
        ]
        [long]
        $Number
    )

    Process
    {
        switch ($true)
        {
            ($Number -gt 1073741823) { "$([math]::Round(($Number/1Gb),2)) Gb"; break }
            ($Number -gt 1048575)    { "$([math]::Round(($Number/1Mb),2)) Mb"; break }
            ($Number -gt 1023)       { "$([math]::Round(($Number/1Kb),2)) Kb"; break }
            ($Number -le 1023)       { "$([math]::Round(($Number),2)) b" }
        }
    }
}


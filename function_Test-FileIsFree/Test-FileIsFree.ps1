<#
.Synopsis
   Tests if the file is open or in use
.DESCRIPTION
   Returns TRUE or FALSE whatever the file by it´s path is open or in use.
   As the name says:
   - return FALSE when the file is in use or open by a program/application
   - return TRUE when the file is free (not in use or not open by a program/application)
.PARAMETER File
   The full path of the file to test
.EXAMPLE
   Test-FileIsFree -File "$($env:USERPROFILE)\Documents\some_file.docx"
.EXAMPLE
   Test-FileIsFree -File "E:\Intepub\config\applicationhost.config"
#>
function Test-FileIsFree
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([boolean])]
    Param
    (
        # file path to be checked
        [Parameter(
            Mandatory=$true,
            ValueFromPipelineByPropertyName=$true,
            Position=0
            )
        ]
        [string]
        $File
    )

    Process
    {
        try
        {
            [IO.File]::OpenWrite($File).Close();
            return $true
        }
        catch
        {
            return $false
        }
    }
}

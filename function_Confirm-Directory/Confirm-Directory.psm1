function Confirm-Directory {
    param (
        [string]$directory
    )

    if (-not(Test-Path $directory -PathType Container)) {
        New-Item $directory -ItemType Directory | Out-Null
    }

    return $directory
}

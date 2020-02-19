Import-Module '..\scripts\modules\Confirm-Directory.psm1'

class TextLog {
    hidden [string]$logFolder
    hidden [string]$logFile
    hidden [string[]]$columns

    [boolean]$debug
    [hashtable]$csvValues
    
    #constructor for CSV
    TextLog ([string]$logFolder,[string]$logFile,[string[]]$columns,[boolean]$debug) {
        $this.debug     = $debug
        $this.logFolder = Confirm-Directory $logFolder
        $this.logFile   = Join-Path $this.logFolder $logFile
        $this.columns   = $columns
        $this.csvValues = [hashtable]::new()

        if (-not(Test-Path $this.logFile -PathType Leaf)) {
            try {
                Set-Content $this.logFile -Value ($columns -join "`t")
            }
            catch {
                throw $_
            }

            foreach($column in $columns) {
                $this.csvValues.Add($column,'')
            }
        }

        if ($debug) {
            Write-Host ("Arquivo de log {0} criado com sucesso" -f $this.logFile)
            Write-Host ("Colunas do CSV: {0}" -f ($columns -join ', '))
        }
    }

    #constructor for TXT
    TextLog ([string]$logFolder,[string]$logFile,[boolean]$debug) {
        $this.debug     = $debug
        $this.logFolder = Confirm-Directory $logFolder
        $this.logFile   = Join-Path $this.logFolder $logFile

        if (-not(Test-Path $this.logFile -PathType Leaf)) {
            try {
                New-Item $this.logFile -ItemType File -ErrorAction Continue | Out-Null
            }
            catch {
                throw $_
            }

            if ($debug) {
                Write-Host ("Arquivo de log {0} criado com sucesso" -f $this.logFile)
            }
        }
    }

    #writeValue for TXT
    [void]writeLine($content) {
        Add-Content $this.logFile -Value $content

        if ($this.debug) {
            Write-Host $content
        }
    }

    #writeValue for CSV
    [void]writeValue($column,$value) {
        $this.csvValues.$column = $value

        if ($this.debug) {
            Write-Host ("{0} {1}" -f $column.PadRight(20,' '), $value)
        }
    }

    #writeValue with timestamp
    [void]writeTimestampLine($content) {
        Add-Content $this.logFile -Value ("{0} {1}" -f (get-date -format G), $content)

        if ($this.debug) {
            Write-Host $content
        }
    }

    #write new line to CSV
    [void]writeLine () {
        $line = @()

        foreach ($column in $this.columns) {
            $line += $this.csvValues.$column
        
            if ($this.debug) {
                Write-Host ("{0} {1}" -f $column.PadRight(20,' '), $this.csvValues.$column)
            }
        }
        
        Add-Content $this.logFile -Value ($line -join "`t")
    }
}

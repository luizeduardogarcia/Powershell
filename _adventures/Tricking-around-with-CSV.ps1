# define the server to get the sites
$server = 'SOME-IIS-HOST'

# first attempt, it will fail!!!
$sitesAppProd = Invoke-Command -ComputerName $server -ScriptBlock {
    Import-Module WebAdministration

    Get-Website
}
# only execute if you want to get the error
$sitesAppProd

# this is the working one!
$sitesAppProd = Invoke-Command -ComputerName $server -ScriptBlock {
    Import-Module WebAdministration

    Get-Website | Select name, id, state, physicalPath | Sort id | ConvertTo-Csv

} | ConvertFrom-Csv 

# here you got all the websites on the host
$sitesAppProd

# defining some folder (part of physical path) to serach for
$folder_to_find = 'framework'

# use where to serach for it!
$sitesAppProd | Where { $_.physicalPath -like "*$folder_to_find*" }

# defining some site name (or part of it) to serach for
$site_to_find = 'auto'

# use where to serach for it!
$sitesAppProd | Where { $_.name -like "*$site_to_find*" }

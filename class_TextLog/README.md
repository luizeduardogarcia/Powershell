# class TextLog

Simple class to save log interactions through your script execution. Choose between CSV or TXT format on creation of the object. Save some time showing the content output on the console - like a debug mode!

### Requeriment Note:
This class uses an user function `Confirm-Directory` in order to validate whatever the destination folder exists or not. You can access this function [here](https://github.com/luizeduardogarcia/Powershell/tree/master/function_Confirm-Directory).

## CSV Usage

1. Declare a object with the type `[TextLog]`, passing to it´s constructor the file path, the file name, the columns, and a boolean to define if the debug mode is on (true) or not (false):
```powershell
[TextLog]$csvLog = [TextLog]::new('some_path_to_the_file','some_file_name',@('Column1','Column2','Column3'),$true)
```
2. Once the object is created, you just have to pass the column x value data:
```powershell
$csvLog.writeValue('Column1',(Get-Date -Format G))
# some code may goes here...
$csvLog.writeValue('Column2','step 1')
# doing something now
# and this is done
$csvLog.writeValue('Column3','success')
```
> Tip: It´s also possible to write value direct to the column, using the property csvValues and referencing the column name:
```powershell
$csvLog.csvValues.Column2 = 'some other value'
```
3. After all columns have been filled, just write the line to the CSV file:
```powershell
$csvLog.writeLine()
```
That´s it! And as the debug mode is on, after each writeValue and writeLine method it will display on the console the column and the value that have been passed to it.

## TXT Usage

 1. Declare a object with the type `[TextLog]`, passing to it´s constructor the file path, the file name, and a boolean to define if the debug mode is on (true) or not (false):
```powershell
[TextLog]$txtLog = [TextLog]::new('some_path_to_the_file','some_file_name',$true)
```

 2. Once the object is created, there are two options for write lines to the log text file:
 - `writeLine('content goes here')` just write the value passed
 - `writeTimestampLine('content goes here')` a timestamp (get-date -format G) before the value passed
```powershell
# start with a timestamp line
$txtLog.writeTimestampLine('this is the beginning of the text log')
# some code may goes here...
$txtLog.writeLine('step 1 was done!')
# doing something now
$txtLog.writeLine('step 2, success!')
# and finish it with timestamp as well
$txtLog.writeLine('and the work is done!')
```

Again, as the debug mode is on, after each writeLine method it will display on the console the content that have been passed to it.

It´s also possible the control the debug mode in run time:
```powershell
# this will turn off the debug mode:
$txtLog.debug = $false
# this will turn it back on again:
$txtLog.debug = $true
```

To get the full list of the geters and seters for the class:
```powershell
$txtLog | Get-Member -force
```

Hope you have fun coding with it!

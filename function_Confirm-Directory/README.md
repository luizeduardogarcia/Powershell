# Function Confirm-Directory

Use it for check whatever a directory exists or not. If the directory donot exists, then it will be created.

## Usage

```powershell
# define some variable for some path, receiving the result of the function:
$some_path = Confirm-Directory('full_path_of_the_directory')
# and then combine it with file name, or destination folder for copy files, or anything you need to do with a directory path
$file_full_path = Join-Path $some_path 'some_file_name.whv'
```

That´s it! Hope you have fun coding with it!

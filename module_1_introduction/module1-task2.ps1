[CmdletBinding()]
Param(
    [Int32]$PasswordLength = 12,    # By default
    [String]$CharactersSet = '1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'   # By default
)

$random = 1..$PasswordLength | ForEach-Object { Get-Random -Maximum $CharactersSet.length } 
$private:ofs="" 
[String]$CharactersSet[$random]


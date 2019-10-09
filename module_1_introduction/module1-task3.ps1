[CmdletBinding()]
Param(
    [String]$JsonFilePath='module1-task3.json',
    [String]$XmlFilePath
)
# Parameters for API
$key = 'trnsl.1.1.20191008T104230Z.f180ae6bc7346493.30ea1ff46dc5fdbaca0e42c7052a14414681e6bb'
$lang = "ru-en"

$translatedArray = @()      # Array for translated paragraphs

$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path     # Directory of our script
$HashArguments = @{
    Path = "$($ScriptDir)\module1-task3.txt"
    Encoding = "UTF8"
}
$text = Get-Content @HashArguments
$textArray = $text.Split("`n")    # Array of paragraphs

$icount = @()    # Array for counting indexes of strings with latin characters

for($i=0; $i -lt $textArray.Length; $i++) {
    if($textArray[$i] -notmatch "[a-z][A-Z]") {
        $str = $textArray[$i]   # One paragraph
        $translatedParagraph = Invoke-RestMethod -Method 'Post' -Uri "https://translate.yandex.net/api/v1.5/tr.json/translate?key=$key&lang=$lang&text=$str"
        $translatedArray += $translatedParagraph.text
    }
    else {
        $icount += $i   # Count indexes of strings with latin characters
    }
}

$textLatinless = @()    # Array for all original strings exclude strings with latin characters
for($i=0; $i -lt $textArray.Length; $i++){
    if($icount -notcontains $i){
        $textLatinless += $textArray[$i]
    }
}

$paragraphsArray = @()      # Assign empty array

for($i=0; $i -lt $textLatinless.Length; $i++){
    $itable = [ordered]@{'original'=$textLatinless[$i]; 'translated'=$translatedArray[$i]}
    $paragraphsArray += @{"$($i+1)"=$itable}
}

$resultHash = @{"text"=@{"paragraphs"=$paragraphsArray}}        # Form result hash table and futher convert it to appropriate serial type

$resultHash | ConvertTo-Json -Depth 10 | foreach { [System.Text.RegularExpressions.Regex]::Unescape($_) } | Out-File $JsonFilePath
 
if ($XmlFilePath) {
    ConvertTo-Xml -As String -InputObject ($resultHash) -Depth 10 -NoTypeInformation | Out-File $XmlFilePath
}

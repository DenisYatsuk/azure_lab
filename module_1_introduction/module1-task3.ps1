[CmdletBinding()]
Param(
    [String]$JsonFilePath,
    [String]$XmlFilePath 
)
# Parameters for API
$key = 'trnsl.1.1.20191008T104230Z.f180ae6bc7346493.30ea1ff46dc5fdbaca0e42c7052a14414681e6bb'
$lang = "ru-en"

$translatedArray = @()
$text = Get-Content -Encoding "UTF8" 'module1-task3.txt'
$textArray = $text.Split("`n")    # Array of paragraphs

for($i=0; $i -lt $textArray.Length; $i++) {
    $str = $textArray[$i]    # One paragraph
    $translatedParagraph = Invoke-WebRequest "https://translate.yandex.net/api/v1.5/tr.json/translate?key=$key&text=$str&lang=$lang&format=plain" | ConvertFrom-Json
    $translatedArray += $translatedParagraph.text
}

$paragraphsArray = @()      # Assign empty array

for($i=0; $i -lt $textArray.Length; $i++){
    $itable = @{'original'=$textArray[$i]; 'translated'=$translatedArray[$i]}
    $paragraphsArray += @{"$i"=@{}}
    $paragraphsArray[$i] = @{"$($i+1)"=$itable}
}

$resultHash = @{"text"=@{"paragraphs"=$paragraphsArray}}

if ($JsonFilePath){
    $resultHash | ConvertTo-Json -Depth 10 | Out-File $JsonFilePath
}
 
if ($XmlFilePath) {
    ConvertTo-Xml -As "Document" -InputObject ($resultHash) -Depth 10 | Out-File $XmlFilePath
}

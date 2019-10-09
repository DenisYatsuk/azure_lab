$table1 = @{a = 1; c = 3; r = 6; d = 7}
$table2 = @{c = 3; b = 4; d = 7; s = 9}
function Merge-Hashtables {
    $Output = @{}
    ForEach ($Hashtable in ($Input + $Args)) {
        If ($Hashtable -is [Hashtable]) {
            ForEach ($Key in $Hashtable.Keys) {$Output.$Key = $Hashtable.$Key}
        }
    }
    $Output.GetEnumerator() | Sort-Object -Property Name
}

$table1, $table2 | Merge-Hashtables


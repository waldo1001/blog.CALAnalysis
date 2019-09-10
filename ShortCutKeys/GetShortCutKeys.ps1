$alFolder = 'C:\ProgramData\NavContainerHelper\Extensions\Original-15.0.35903.0-be-al\'
$resultFile = join-path $PSScriptRoot '15.0.35903.0.csv'

$regex = "ShortCutKey = \'(.+)\';"
$regexAction = "action\((.+)\)"
$alfiles = Get-ChildItem $alFolder -Filter '*.al' -Recurse

$AllShortcutKeys = @()

foreach ($FileSearched in $alfiles) {
    $file = New-Object System.IO.StreamReader($FileSearched.FullName)

    while (-not $file.EndOfStream) {
        $text = $file.ReadLine()

        $match = ([regex]$regexAction).Match($text)
        if ($match.Groups[1].Value) {
            $CurrentAction = $match.Groups[1].Value 
        }

        foreach ($match in ([regex]$regex).Matches($text)) {   
            # "$($FileSearched.BaseName) - $($CurrentAction) - $($match.Groups[1].Value)"
            $AllShortcutKeys += [PSCustomObject]@{
                File        = $FileSearched.BaseName
                Action      = $CurrentAction
                ShortCutKey = $match.Groups[1].Value
            }
        }
    }
    $file.close();  
}  

$AllShortcutKeys | Export-Csv -Path $resultFile



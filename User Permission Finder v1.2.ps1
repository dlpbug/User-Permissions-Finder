$Start = Read-Host -prompt "where is the file location?"
try {CD $start -ErrorAction stop}
catch {
    Write-Host "File location $Start could not be found"
    break
}
$End = Read-Host -prompt "where will the files be recorded?"
try {Test-path -Path "$End" -ErrorAction stop}
catch {
    Write-Host "File location $End could not be found"
    break
}
Write-Progress -Activity "Getting files now"
$FileLocal = get-childitem "$Start" -Directory -recurse | % {$_.FullName} -ErrorAction Ignore
$Max = $FileLocal.Length
$Count = 0
Remove-Item -Path "$End\User Permission Files v1.2"
$DocumentFile = New-Item -ItemType directory -Path "$End\User Permission Files v1.2"
While($Count -lt $Max){
    $File = $FileLocal[$Count]
    $ID = (get-acl "$File").access | select IdentityReference | where-object {$_.IdentityReference -like "GRAY*" -and $_.IdentityReference -notlike "*SG"}
    $SubCount = 0
    $SubMax = @($ID).Count
    While($SubCount -lt $SubMax){
        $User = $ID[$SubCount]
        $Pattern = '[\\]'
        $User = $User -replace $Pattern, ' '
        $User = $User -replace "@{IdentityReference=GRAY ", '' -replace "}", ''
        if (-Not (Test-path -Path "$DocumentFile\$User\$User.cvs")){
            New-Item -ItemType directory -Path "$DocumentFile\$User"
            New-Item -ItemType File -Path "$DocumentFile\$User\$User.cvs"
        }
        $FileContent = Import-csv "$DocumentFile\$User\$User.cvs" -header File
        $FileContentLess = $FileContent -replace $Pattern, ''
        $FileContentLess = $FileContentLess -replace "@{File=", '' -replace "}", ''
        $FileLess = $File -replace $Pattern, ''
        if ($FileContentLess[0] -eq $null){
            "$file" | add-content -path "$DocumentFile\$User\$User.cvs"
        }
        else {
        foreach ($Item in $FileContentLess) {if ("$FileLess" -match $Item) {$Test = $true}}
            if (-not($Test)) {
                "$File" | add-content -path "$DocumentFile\$User\$User.cvs"
            }
        $Test = $false
        }
    $Check = 0
    $SubCount++
    $SubPercentDone = [math]::Round(100*($SubCount/$SubMax),2)
    Write-Progress -Id 1 -Activity "Documenting User" -Status "$SubPercentDone %" -PercentComplete $SubPercentDone -CurrentOperation "$User"
    }
$count++
$PercentDone = [math]::Round(100*($Count/$Max),2)
Write-Progress -ParentId 1 -Activity "Documenting File" -Status "$Count out of $Max Files documented | $PercentDone %" -PercentComplete $PercentDone -CurrentOperation "$File"
}
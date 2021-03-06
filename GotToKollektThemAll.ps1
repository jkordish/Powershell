$Path      = "E:\Adobe\ftp.adobe.com\pub\adobe\reader\win"
$Kollektor = "E:\Kollektor_Release\kollektor.exe"
$Extracted = "E:\extracted\"
$Completed = "E:\completed\"

Get-Childitem $Path -Recurse -Include * | ForEach-Object {
$Error.Clear()
    If ($_.extension -eq ".cab") {
     $baseName = $_.basename
     $fullName = $_.fullname
     $extractDir = "$($Completed)$($baseName)\"
     Write-Host -ForegroundColor DarkYellow "Processing CAB file $($curName)"
     New-Item -Force -Path $Completed -Name $baseName -Type directory | Out-Null
     cd $extractDir

     & "C:\Program Files\7-Zip\7z.exe" "x" $_.fullname "-o$($extractDir)" "-y" "-mmt" "-aou" | Out-Null
        Get-ChildItem $extractDir -Recurse -Include *.msp,*.msi,*.msm,*.pcp | ForEach-Object {
            Write-Host -ForegroundColor DarkRed "     => Extracting $($_)"
            & "C:\Program Files\7-Zip\7z.exe" "x" $_.fullname "-o*" "-y" "-mmt" "-aou" | Out-Null
           }
        Get-ChildItem $extractDir -Recurse -Include *.cab | ForEach-Object {
            Write-Host -ForegroundColor DarkRed "     => Extracting $($_)"
            & "C:\Program Files\7-Zip\7z.exe" "x" $_.fullname "-o*" "-y" "-mmt" "-aou" | Out-Null
           }

    cd $extractDir
    write-host -ForegroundColor Red "Kollektor'ing => $($fullName)"
    & $Kollektor -F -C -z $extractDir  | Out-Null
    Write-Host -ForegroundColor DarkGreen "Processed     => $($fullName)"
    Move-Item -Path "$($extractDir)92d-cawgv2w660g.xml.gz"  -Destination "$($extractDir)$($baseName).xml.gz"
    $Error.Clear()
     }

     If ($_.extension -eq ".exe") {
     $baseName = $_.basename
     $fullName = $_.fullname
     $extractDir = "$($Completed)$($baseName)\"
     Write-Host -ForegroundColor DarkYellow "Processing EXE file $($fullName)"
     New-Item -Force -Path $Completed -Name $baseName -Type directory | Out-Null
     cd $extractDir
     & "C:\Program Files\7-Zip\7z.exe" "x" $_.fullname "-o$($extractDir)"  "-y" "-mmt" "-aou"  | Out-Null
        Get-ChildItem $extractDir -Recurse -Include *.msp,*.msi,*.msm,*.pcp | ForEach-Object {
            Write-Host -ForegroundColor DarkRed "     => Extracting $($_)"
           & "C:\Program Files\7-Zip\7z.exe" "x" $_.fullname "-o*"  "-y" "-mmt" "-aou" | Out-Null
           }
        Get-ChildItem $extractDir -Recurse -Include *.cab | ForEach-Object {
            Write-Host -ForegroundColor DarkRed "     => Extracting $($_)"
            & "C:\Program Files\7-Zip\7z.exe" "x" $_.fullname "-o*"  "-y" "-mmt" "-aou" | Out-Null
           }

    cd $extractDir
    write-host -ForegroundColor Red "Kollektor'ing => $($baseName)"
    & $Kollektor -F -C -z $extractDir | Out-Null
    Write-Host -ForegroundColor DarkGreen "Processed     => $($fullName)"
    Move-Item -Path   "$($extractDir)92d-cawgv2w660g.xml.gz"  -Destination "$($extractDir)$($baseName).xml.gz"
    $Error.Clear()
     }
}

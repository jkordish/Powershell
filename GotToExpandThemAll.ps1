$Path      = "E:\mirror\ftp.dell.com\network"
$Extracted = "E:\extracted\"
$Completed = "E:\completed\"
$sha1deep  = "E:\md5deep\sha1deep.exe"

Get-Childitem $Path -Recurse -Include * | ForEach-Object {
$Error.Clear()
    If ($_.extension -eq ".cab" -or $_.extension -eq ".exe" -or $_.extension -eq ".msi" -or $_.extension -eq ".zip"  ) {
     $baseName = $_.basename
     $fullName = $_.fullname
     $extractDir = "$($Extracted)$($baseName)\"
     Write-Host -ForegroundColor Yellow -BackgroundColor Black "Processing file $($fullName)"
     New-Item -Force -Path $Extracted -Name $baseName -Type directory | Out-Null
     cd $extractDir

     & "C:\Program Files\7-Zip\7z.exe" "x" $_.fullname "-o$($extractDir)" "-y" "-r" "-mmt" "-aoa" | Out-Null
        Get-ChildItem $extractDir -Recurse -Include *.msp,*.msi,*.msm,*.pcp,*.cab,*.exe | ForEach-Object {
            Write-Host -ForegroundColor DarkRed -BackgroundColor Black "   =>>> Extracting $($_)"
            & "C:\Program Files\7-Zip\7z.exe" "x" $_.fullname "-o*" "-y" "-r" "-mmt" "-aoa" | Out-Null
           }
        Get-ChildItem $extractDir -Recurse -Include *.msp,*.msi,*.msm,*.pcp,*.cab,*.exe | ForEach-Object {
            Write-Host -ForegroundColor DarkRed -BackgroundColor Black "   =>>> Extracting $($_)"
            & "C:\Program Files\7-Zip\7z.exe" "x" $_.fullname "-o*" "-y" "-r" "-mmt" "-aos" | Out-Null
           }
    $Error.Clear()

     Write-Host -ForegroundColor DarkGreen -BackgroundColor Black "    =>> sha1deep on $($extractDir)"
     & "E:\md5deep\sha1deep.exe" "-slr" "-o f" "$($extractDir)" >> "$($Completed)Dell_Network_Drivers.txt" | out-null
     cd $Extracted
     Remove-Item -Force -Recurse $extractDir
     Write-Host -ForegroundColor White -BackgroundColor Black "     => Completed $($fullName)"
     Write-Host ""
     }

}

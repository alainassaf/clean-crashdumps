<#
.SYNOPSIS
	Iterates though a list of servers and reports on crashdumps.
.DESCRIPTION
	Iterates though a list of servers and reports on crashdumps.
.PARAMETER CrashDumpDir
    Optional Parameter. Additional directory to search for crashdumps.
.PARAMETER Outputfolder
    Optional Parameter. Defaults to current folder location.
    Enter a path to output the file.
.PARAMETER Computer
    Optional Parameter. Defaults to localhost. Can be a list or array of systems.
.PARAMETER UseAD
    Switch Parameter. If present, gets list of servers from active directory OU noted in ServerOU variable.
.PARAMETER Delete
    Switch Parameter. If present, deletes the crashdumps.
.EXAMPLE
	PS C:\PSScript > .\clean-crashdumps.ps1
	
	Will use all default values. Will look under c:\windows and c:\windows\minidump for crashdumps on local system
.EXAMPLE
	PS C:\PSScript > .\clean-crashdumps.ps1 -CrashDumpDir d:\logs\crashdumps
	
	Will look under c:\windows, c:\windows\minidump, and d:\logs\crashdumps for crashdumps	on local system
.EXAMPLE
	PS C:\PSScript > .\clean-crashdumps.ps1 -CrashDumpDir d:\logs\crashdumps -computer SOMEPC
	
	Will look under c:\windows, c:\windows\minidump, and d:\logs\crashdumps for crashdumps	on SOMEPC
.EXAMPLE
	PS C:\PSScript > .\clean-crashdumps.ps1 -CrashDumpDir d:\logs\crashdumps -usead
	
	Will look under c:\windows, c:\windows\minidump, and d:\logs\crashdumps for crashdumps on all systems under $serverOU
.EXAMPLE
	PS C:\PSScript > .\clean-crashdumps.ps1 -CrashDumpDir d:\logs\crashdumps -usead -delete
	
	Will look under c:\windows, c:\windows\minidump, and d:\logs\crashdumps for crashdumps on all systems under $serverOU and delete them.
.INPUTS
	None.  You cannot pipe objects to this script.
.OUTPUTS
	No objects are output from this script.
.NOTES
	NAME        :  clean-crashdumps
    VERSION     :  1.05
    LAST UPDATED:  4/26/2017
    AUTHOR      :  Alain Assaf
    CHANGE LOG - Version - When - What - Who
    1.00 - 04/24/2017 - Initial script, clone of count-usrprof - Alain Assaf
    1.01 - 04/24/2017 - Added some foreach loops to better collect dump info - Alain Assaf
    1.02 - 04/24/2017 - Added more checks to bypass servers that are not reachable or dirs that do not exist - Alain Assaf
    1.03 - 04/25/2017 - Added file time and date - Alain Assaf
    1.04 - 04/25/2017 - Added delete swtich and lines to remove files - Alain Assaf
    1.05 - 04/26/2017 - Fixed computer countdown - Alain Assaf
.LINK
    http://tasteofpowershell.blogspot.com/2009/09/regular-expression-cheat-sheet-for.html
    http://stackoverflow.com/questions/11725610/powershell-invoke-command-remove-item-remote-server
    http://www.linkedin.com/in/alainassaf/
    https://wagthereal.com
#>
Param(
    [parameter(Position = 0, Mandatory=$False )] 	
    [ValidateNotNullOrEmpty()]
	[string]$CrashDumpDir,
    
    [parameter(Position = 1, Mandatory=$False )] 
    [ValidateNotNullOrEmpty()]	
    [string]$Outputfolder=".\",
    
    [parameter(Position = 2, Mandatory=$False )] 
    [ValidateNotNullOrEmpty()]	
    $Computer = "localhost",
    
    [parameter(Position = 3, Mandatory=$False )] 
    [ValidateNotNullOrEmpty()]	
    [switch]$useAD,
    
    [parameter(Position = 4, Mandatory=$False )] 
    [ValidateNotNullOrEmpty()]	
    [switch]$Delete

)

Import-Module ctxModules

Get-MyModule activedirectory

$crashdumps = New-Object System.Collections.ArrayList
$dumpdir = New-Object System.Collections.ArrayList
$serverOU = "OU=Citrix,OU=Servers,DC=DOMAIN,DC=local"

$crashdumpcount = 0

#Add directories to search for memory dumps
$dumpdir += "c:\windows"
$dumpdir += "C:\Windows\Minidump"
$dumpdir += $CrashDumpDir

if ($useAD) {
    try {
        $computer = (Get-ADComputer -Filter * -SearchBase $serverOU -Properties *).name
        $compcount = $Computer.count
    } catch {
        Write-Warning "Failed to retreive list of servers from active directory. Confirm $serverOU is correct"
    }
}

foreach ($comp in $Computer) {
    if (test-port $comp) {
        foreach ($dir in $dumpdir) {
            #$files = gci $dir | where {$_.name -like "*DMP*"}
            if (Invoke-Command -ComputerName $comp -ScriptBlock { param($remotedir) test-path $remotedir} -args $dir) {
                $files = invoke-command -ComputerName $comp  { param($remotedir) get-childitem $remotedir | where {$_.name -like "*DMP" }} -ArgumentList $dir
                if ($files -ne "") {
                    foreach ($file in $files) {
                        $obj = New-Object PSObject    
                        $obj | Add-Member -MemberType NoteProperty -Name “ComputerName” -Value $comp
                        $obj | Add-Member -MemberType NoteProperty -Name “Directory” -Value $file.Directory
                        $obj | Add-Member -MemberType NoteProperty -Name “Filename” -Value $file.Name
                        $obj | Add-Member -MemberType NoteProperty -Name “Date” -Value ($file.creationtime).toshortdatestring()
                        $obj | Add-Member -MemberType NoteProperty -Name “Time” -Value ($file.creationtime).toshorttimestring()
                        $crashdumps += $obj
                        $obj = ""
                        $crashdumpcount++
                        if ($Delete) {
                            try {
                                $deletefile = $file.DirectoryName + "\" + $file.name
                                Invoke-Command -ComputerName $comp {param ($remotefile) remove-item $remotefile -force} -ArgumentList $deletefile
                            } catch {
                                write-warning "Failed to delete $file on $comp"
                            }
                        }
                    }
                }
            }
        }
        write-verbose "$compcount servers to go"
        $compcount--
    } else {
        $compcount--
    }
}


#Write report to CSV file
$LogFileName = "CtxCrashdumps" + $datetime + ".csv"
$LogFile = $Outputfolder + $LogFilename
if (test-path $LogFile) {
    Remove-Item $LogFile -Force
}
if ($crashdumpcount -eq 0) {
    write-host "No crash dumps found"
} else {
    $crashdumps | Export-Csv -Path $LogFile -Append
    write-host "$crashdumpcount crash dumps found"
}
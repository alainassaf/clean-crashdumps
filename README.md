# clean-crashdumps
Iterates though a list of servers and reports on crashdumps.

# Contributions to this script
I'd like to highlight the posts that helped me write this scrip below.
* http://tasteofpowershell.blogspot.com/2009/09/regular-expression-cheat-sheet-for.html
* http://stackoverflow.com/questions/11725610/powershell-invoke-command-remove-item-remote-server

# $ get-help .\clean-crashdumps.ps1 -Full

NAME<br>
    clean-crashdumps.ps1
    
SYNOPSIS<br>
    Iterates though a list of servers and reports on crashdumps.
    
    
SYNTAX<br>
    \\pfil9903\users\s26246d\Codevault\github\clean-crashdumps\clean-crashdumps.ps1 [[-CrashDumpDir] <String>] [[-Outputfolder] <String>] [[-Computer] <Object>] [[-useAD]] [[-Delete]] [<CommonParameters>]
    
    
DESCRIPTION<br>
    Iterates though a list of servers and reports on crashdumps.
    

PARAMETERS<br>

    -CrashDumpDir <String>
        Optional Parameter. Additional directory to search for crashdumps.
        
        Required?                    false
        Position?                    1
        Default value                
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -Outputfolder <String>
        Optional Parameter. Defaults to current folder location.
        Enter a path to output the file.
        
        Required?                    false
        Position?                    2
        Default value                .\
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -Computer <Object>
        Optional Parameter. Defaults to localhost. Can be a list or array of 
        systems.
        
        Required?                    false
        Position?                    3
        Default value                localhost
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -useAD [<SwitchParameter>]
        Switch Parameter. If present, gets list of servers from active 
        directory OU noted in ServerOU variable.
        
        Required?                    false
        Position?                    4
        Default value                False
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -Delete [<SwitchParameter>]
        Switch Parameter. If present, deletes the crashdumps.
        
        Required?                    false
        Position?                    5
        Default value                False
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, 
        see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
INPUTS<br>
    None.  You cannot pipe objects to this script.
    
    
OUTPUTS<br>
    No objects are output from this script.
    
    
NOTES<br>
    
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
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\PSScript >.\clean-crashdumps.ps1
    
    Will use all default values. Will look under c:\windows and 
    c:\windows\minidump for crashdumps on local system
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS C:\PSScript >.\clean-crashdumps.ps1 -CrashDumpDir d:\logs\crashdumps
    
    Will look under c:\windows, c:\windows\minidump, and d:\logs\crashdumps 
    for crashdumps	on local system
    
    -------------------------- EXAMPLE 3 --------------------------
    
    PS C:\PSScript >.\clean-crashdumps.ps1 -CrashDumpDir d:\logs\crashdumps 
    -computer SOMEPC
    
    Will look under c:\windows, c:\windows\minidump, and d:\logs\crashdumps 
    for crashdumps	on SOMEPC
    
    -------------------------- EXAMPLE 4 --------------------------
    
    PS C:\PSScript >.\clean-crashdumps.ps1 -CrashDumpDir d:\logs\crashdumps 
    -usead
    
    Will look under c:\windows, c:\windows\minidump, and d:\logs\crashdumps 
    for crashdumps on all systems under $serverOU
    
    -------------------------- EXAMPLE 5 --------------------------
    
    PS C:\PSScript >.\clean-crashdumps.ps1 -CrashDumpDir d:\logs\crashdumps 
    -usead -delete
    
    Will look under c:\windows, c:\windows\minidump, and d:\logs\crashdumps 
    for crashdumps on all systems under $serverOU and delete them.
    
# Legal and Licensing
The clean-crashdumps.ps1 script is licensed under the [MIT license][].

[MIT license]: LICENSE.md

# Want to connect?
* LinkedIn - https://www.linkedin.com/in/alainassaf
* Twitter - http://twitter.com/alainassaf
* Wag the Real - my blog - https://wagthereal.com
* Edgesightunderthehood - my other - blog https://edgesightunderthehood.com

# Help
I welcome any feedback, ideas or contributors.

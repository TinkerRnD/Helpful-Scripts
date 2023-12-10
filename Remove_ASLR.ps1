# Author:       me ( GitHub.com/TinkerRnD )
# Copyright:   "UnLicensed"  
#              (Do "Whatever [Changes] You Want" with This Code;
#               Just do NOT go and say that I am the "Author" Afterwards...)
#
# Target: Git/Cygwin/Msys2 for Windows
#
#
#   Do EDIT this next "$installPath" variable definition to the Path of Your "Msys2/Git Bash/ or Cygwen for Windows" (currently configured for Msys2)
# ROOT Installation Folder like the Pre-Filled "Default Path" already written there.
# [Note that it MUST have a "usr\bin" "Folder\SubFolder" Structure right in that Path]
# (It should also be pretty Obvious if "You're Doing it Wrong" since PowerShell WILL Display a
#  RED-Colored ERROR Message containing something along the lines of "it does NOT exist"...)

$installPath = "C:\msys64\usr\"

#   This Next Section is My "Homemade" Default and
# Generic "Admin Self-Elevation Prompt" Section for "PowerShell Scripts" that need it...

# Admin Prompt Section
#  ====  START  ==== 

if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
    Write-Host ""
    Write-Host -BackgroundColor Black -ForegroundColor Red "  ======  MUST  READ!!!.  ======  "
    Write-Host "
  
  Not Elevated / in `"Administrator Mode`"!.
  (Must be `"Admin`" to use this Script)
  
  Re-Launching with Elevation Prompt...
  (You MUST Confirm/Allow `"Elevation`" in the Upcoming `"UAC Prompt`" for PowerShell)
  
    "
    Write-Host -BackgroundColor Black -ForegroundColor Red " ALWAYS Remember to READ ALL the `"Commands`" being EXECUTED as Admin/Elevated!!!. "
    Write-Host -BackgroundColor Black -ForegroundColor DarkGray " (PRESS `"Show more details`" or Your System-Language Equivalent in the UAC Prompt) "
    Write-Host "

    "
    Pause

    Write-Host "

Launching...
    "

    if ($args.Count.Equals(0))
    {
        Start-Process "$PSHOME\powershell.exe" "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Wait -Verb RunAs -Verbose
    }
    else
    {
        Start-Process "$PSHOME\powershell.exe" "-ExecutionPolicy Bypass -File `"$PSCommandPath`" `"$args`"" -Wait -Verb RunAs -Verbose
    }

    Write-Host ""
    Write-Host -BackgroundColor Black -ForegroundColor Green " EVERYTHING DONE!. "
    Write-Host "
(This `"Script`" instance WILL END the next time You `"Press Enter`"...)

    "
    Pause

    Write-Host "

Exiting...

    "
    Exit

}

# Admin Prompt Section
#  ====  END  ==== 

# Script Proper  (from here onwards)

Write-Host "
Getting List of `".exe`" files to Force-Disable the 
 `"Mandatory ASLR & BottomUp ASLR`" Mitigation...  

"

#   Get List of ".exe" files in the "$installPath\usr\bin" Folder ("DIR"-Like Output Style/Format),
# Convert the List into just "Full Path"s ("C:\[...].exe" Style)(Removes unwanted info like "File Size", etc.),
# and Save/Put it as a "StringArray" (AKA "String[]") into the "$files" Variable.
$files = (Get-ChildItem "$installPath\bin\*.exe").FullName

Write-Host ("
Executing the Forced `"OFF`" State for the 
 `"Mandatory ASLR & BottomUp ASLR`" Mitigation on " + $files.Count + " `".exe`" files...  

")

#   Run "Set-ProcessMitigation -Disable ForceRelocateImages" (Forcing "Mandatory ASLR" to "OFF") on each
# "String" of the "StringArray" Variable "$files".  -->  each "String" is a ".exe" file's "Full Path".
#   This Effectively Runs the Command on Every Known Relevant ".exe" files.
# [NOTE: There is a (Very) Remote Chance that there are a few ".exe" files in that Folder that needn't be
#  "UnBlocked" (Added to these "Exceptions") (from what I've seen => "Not Really...") but this is the Safer,
#  "Sure Way" Option;    At Least,  "For Now"...  ]
if (!($files.Count.Equals(0)))
{
    $files.ForEach({Set-ProcessMitigation -Verbose $_ -Disable ForceRelocateImages})
    $files.ForEach({Set-ProcessMitigation -Verbose $_ -Disable BottomUp})
}
else
{
    Write-Host "
 There  is  LITERALLY  `"NOTHING`"  to  DO  Here!...  

(Wrong `" Installation Path`" Maybe?...  
 Check the Value of the `"`$installPath`" Variable near the top of
 THIS `"PowerShell Script`" You're Running RIGHT NOW! ...
 Currently:
 `$installPath = $installPath

 If this is WRONG, Go and EDIT this `"Script`" File Now and
 put in the Correct Installation Path...)

"
}

Write-Host ""
Write-Host -BackgroundColor Black -ForegroundColor Green " EVERYTHING DONE!. "
Write-Host "
(This `"Script`" instance WILL END the next time You `"Press Enter`"...)

"

Pause

Write-Host "

Exiting...

"

Exit


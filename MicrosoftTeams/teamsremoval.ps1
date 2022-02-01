#Function to generate a timestamp that is added to the log file
function Get-TimeStamp {
  return "[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date)   
  }
  
  #Function to generate a log file
  if ((Test-Path -Path "$ENV:SystemDrive\Scripts" -PathType Container) -ne $true ) {mkdir "$ENV:SystemDrive\Scripts" | Out-Null}
  $LogFile = "$ENV:SystemDrive\Scripts\Logs.log"
  Function LogWrite
  {
    Param ([string]$logstring)
    Add-content $Logfile -value "$(Get-Timestamp) $logstring"
  }
#Silent uninstall command to run against Teams
$arguments = '-uninstall -s'
#Searches for all user installed versions of Teams and filters them so only versions less than the one specified after Product Version shows up. Change the number to be the version required. https://community.chocolatey.org/packages/microsoft-teams#versionhistory - nice way to keep track
Get-ChildItem -Path C:\users\*\appdata\local\Microsoft\Teams\current\Teams.exe -Recurse -Force | Select-Object -ExpandProperty VersionInfo | where-object ProductVersion -lt '1.4.00.32771' | Select-Object -ExpandProperty FileName -OutVariable 'uninstallpath'
#The uninstall command has to be run against a different file so this apends the path for the command
$remove = $uninstallpath.replace('\current\Teams.exe','\update.exe')
#This runs the below command for every file found in the above filter. It takes the path from the search and the arguments from the Arguments variable. 
$remove.ForEach( {

try {

LogWrite $_
Start-Process -FilePath $_ -PassThru -Argumentlist $arguments
}


catch {
LogWrite 'failed'
}

} 
)

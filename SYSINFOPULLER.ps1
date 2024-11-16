Set-ExecutionPolicy -ExecutionPolicy Undefined -Scope CurrentUser
$buildToVersion = @{
    "19045" = "22H2"
    "19044" = "21H2"
    "19043" = "21H1"
    "19042" = "20H2"
    "19041" = "20H1"
    "18363" = "1909"

}

$CustomInputCSV = Read-Host "Please enter the location of your PC list csv. Ex: C:\Users\YourUserName\Downloads\PC_List.csv"
$RemoteDeviceList = @(Get-Content $CustomInputCSV)
$DynamicResultsCSVPath = Join-Path -Path $env:USERPROFILE -ChildPath 'Downloads\OutPut.csv'
$results = @()

foreach ($Computer in $RemoteDeviceList ){
    try{
        Write-Host "Currently on $Computer"
        $os = Get-WmiObject Win32_OperatingSystem -ComputerName $Computer
        $versionName = $buildToVersion[$os.BuildNumber]
	$totalRAM = Get-WmiObject Win32_PhysicalMemory -ComputerName $Computer | Measure-Object -Property Capacity -Sum
        $ramGB = [math]::Round(($totalRAM.Sum / 1GB), 2)

        $results += $os | Select PSComputerName, Caption, Version, @{Name="WindowsVersion"; Expression={$versionName}}, @{Name="RAM_GB"; Expression={$ramGB}}
    }
    catch {
        Write-Host "Unable to gather for $Computer"
        $results += New-Object PSObject -Property @{
            PSComputerName = $Computer
            Caption = "offline"
            Version = "offline"
            WindowsVersion = "offline"
            RAM_GB = "offline"
        }
    }
}

Write-Host "Completed Run."
$results | Export-Csv -Path $DynamicResultsCSVPath -NoTypeInformation
PAUSE
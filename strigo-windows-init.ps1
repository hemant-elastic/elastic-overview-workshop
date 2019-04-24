set-executionpolicy -Force remotesigned -s currentuser; [System.Net.ServicePointManager]::SecurityProtocol= 3072 -bor 768 -bor 192 -bor 48;
$downloadPath = "C:\Users\Administrator\Downloads\"
$workshopPath = "C:\Users\Administrator\Desktop\workshop-content"
$git_url = 'https://github.com/git-for-windows/git/releases/download/v2.21.0.windows.1/Git-2.21.0-64-bit.exe'
function Install-Git()
{

	$webClient = New-Object System.Net.WebClient
	$fileName = Split-Path $git_url -Leaf
	$destinationPath = $downloadPath + "\" + $fileName
	$Arguments = ' /VERYSILENT /SUPPRESSMSGBOXES'
	Write-Output "Downloading" $fileName" to "$destinationPath
	$webClient.DownloadFile($git_url, $destinationPath)
	Write-Output "Installing" $fileName
	Invoke-Expression -Command "$destinationPath $Arguments"
	Start-Sleep -Seconds 90

}

function Update-Path()
{
    Write-Output "Updating git in the path variable"
    $AddedLocation ="C:\Program Files\Git\bin"
    $CurrentPath = (Get-Itemproperty -path 'hklm:\system\currentcontrolset\control\session manager\environment' -Name Path).Path
    $NewPath = $CurrentPath + ";" + $AddedLocation
    Write-Output "New Path = $NewPath"
    Set-ItemProperty -path 'hklm:\system\currentcontrolset\control\session manager\environment' -Name Path -Value $NewPath
}

Install-Git
Update-Path
New-Item -Path $workshopPath -ItemType "directory"
Set-Location -Path $downloadPath
Invoke-Expression -Command "git clone https://github.com/hemant-elastic/observability-workshop.git"
Set-Location -Path observability-workshop
Invoke-Expression -Command ".\win-prereqs-setup.ps1"
Copy-Item  "C:\ProgramData\Amazon\EC2-Windows\Launch\Log\UserdataExecution.log" -Destination "C:\Users\Administrator\Desktop\"
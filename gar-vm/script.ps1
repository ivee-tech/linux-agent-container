$subscriptionId = '2ef01a24-f9c4-4a9f-bca8-7d0ca8fe11fa'
$rgName = 'gar-auea-rg'
$location = 'AustraliaEast'
$spName = "gar-sp"
$roleName = 'Contributor'


$imageType = 'Windows2022' # Windows2022, Windows2019, Ubuntu2004, Ubuntu1804

# Configure the secure password for the service principal
Import-Module Az.Resources # Imports the PSADPasswordCredential object
$password = [guid]::NewGuid().Guid
$secpassw = New-Object Microsoft.Azure.Commands.ActiveDirectory.PSADPasswordCredential -Property @{ StartDate=Get-Date; EndDate=Get-Date -Year 2024; Password=$password}

# Create the service principal
$sp = New-AzADServicePrincipal -DisplayName $spName -PasswordCredential $secpassw

Start-Sleep 30

# Assign the role to the service principal.
$role = New-AzRoleAssignment -ObjectId $sp.Id -RoleDefinitionName $roleName -Scope "/subscriptions/$subscriptionId"
$role

# create resource group
New-AzResourceGroup -Name $rgName -Location $location

# install packer to build the VM image (Run as Administrator)
choco install packer

# install git
choco install git -params '"/GitAndUnixToolsOnPath"'

# install Az PowerSehll module
Install-Module -Name Az -Repository PSGallery -Force

# install az CLI
Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'; rm .\AzureCLI.msi

# download runner images repo
Set-Location c:\tools
git clone https://github.com/actions/runner-images.git

# import and run GenerateResourcesAndImage cmdlet

# added after error issues
Import-Module Az.Storage -Force

Set-Location C:\tools\runner-images
Import-Module .\helpers\GenerateResourcesAndImage.ps1
GenerateResourcesAndImage -SubscriptionId $subscriptionId -ResourceGroupName $rgName -ImageGenerationRepositoryRoot "$pwd" -ImageType $imageType -AzureLocation $location

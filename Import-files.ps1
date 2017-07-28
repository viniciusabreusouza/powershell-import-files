
#Specify tenant admin and site URL

#Add references to SharePoint client assemblies and authenticate to Office 365 site - required for CSOM
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\15\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\15\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"
$User = Read-Host -Prompt "Please enter your UserName" -AsSecureString
$Password = Read-Host -Prompt "Please enter Password" -AsSecureString

$SiteURL = Read-Host -Prompt "Please enter Site Url" 
$Folder = Read-Host -Prompt "Please enter Folder Path" 
$DocLibName = Read-Host -Prompt "Please enter Document Library internal name to upload files" -AsSecureString

#Bind to site collection
$Context = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
$Creds = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($User,$Password)
$Context.Credentials = $Creds

#Retrieve list
$List = $Context.Web.Lists.GetByTitle($DocLibName)
$Context.Load($List)
$Context.ExecuteQuery()
Write-Output "Document Library " + $DocLibName + " loaded"

#Upload file - Upload all files to Document Library
Foreach ($File in (dir $Folder))
{
	$FileStream = New-Object IO.FileStream($File.FullName,[System.IO.FileMode]::Open)
	$FileLine = FileStream
	$FileCreationInfo = New-Object Microsoft.SharePoint.Client.FileCreationInformation
	$FileCreationInfo.Overwrite = $true
	$FileCreationInfo.ContentStream = $FileStream
	$FileCreationInfo.URL = $File
	$Upload = $List.RootFolder.Files.Add($FileCreationInfo)
	$Context.Load($Upload)
	$Context.ExecuteQuery()
}


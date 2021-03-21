#                              
# 1password online vault backup tool (** can set to automatically run by adding as a task via windows task scheduler)
#
#------------------------------------
#
# PRE-REQS                     
#
# * download op cli (url here) and add to PATH
#
# * use op cli to manually log into 1password via cli for the first time (you won't have to do this again)
#   
#    . run the following without quotes: 'op signin my.1password.com email@domain.com'
#    . this will add your account to the windows cache; from this point on, you can execute this shorthand to sign in: 'op signin'

 param (
    [string]$email    = "",
    [string]$password = "",
    [string]$aeskey   = ""
 )


# load dependencies
$scriptRoot = $PSScriptRoot;
if ($psISE)
{
	$scriptRoot = Split-Path -Path $psISE.CurrentFile.FullPath        
}
$aesModulePath = $scriptRoot + "\dependencies\PowershellAes.ps1"
. $aesModulePath


# exit if missing credentials and aes key
if ($email -eq "" -and $password -eq "" -and $aeskey -eq "") {
    echo ""
	echo "   !!! ERROR: E-mail and/or password missing; exiting script without running !!!"
}
else {
    # login to 1password account and set auth token as temporary PATH var
	Invoke-Expression $($password | op signin)

    # scrape vault items for all items uuids via regex
    $allItems = op list items;
    $uuids = [regex]::Matches($allItems, '"uuid":([^"]*"[^"]*)')

    # get item details for each item
    $itemDetails = [System.Collections.ArrayList]@()
    foreach ($match in $uuids)
    {
        
       $itemDetail = op get item $match.Groups[1].Value;
        $itemDetails.Add($itemDetail);
    }
    $rawOutput = $itemDetails  | & {"$input"}	# flattens $itemDetails array to string

    # encrypt with aes sha 256 if key is provided
    if ($aeskey -ne $null) {
        $finalizedOutput = Encrypt-String $aeskey $rawOutput
	}
    else {
        $finalizedOutput = $itemDetails
    }

    $finalizedOutput > $PSScriptRoot\online.vault.backup.txt
}

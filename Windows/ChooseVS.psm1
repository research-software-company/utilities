<#
 .Synopsis
 Sets the environment for using the Visual Studio compilers

 .Description
 Activates a Python Virtual Environment without changing the prompt.
 If you want to add the Visual Studio version to your prompt, call Write-VSPrompt from your prompt function
  

 .Parameter $version
 Visual Studio version. Can be 2010, 2012, 2013 or 2015.

 .Parameter $platform
 Can be x86 or x64. Default is x64


 .Example
  ChooseVS 2015 x64
  Sets the environment for using the 64-bit version of Visual Studio 2015

  ChooseVS 2013 x86
  Sets the environment for using the 32-bit version of Visual Studio 2013
#>

function ChooseVS
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,
                   HelpMessage="Choose Visual Studio version")]
        [ValidateSet("2010", "2012", "2013", "2015")]
        [String]
        $version,

        [Parameter(Mandatory=$false,
                   HelpMessage="Choose Platform - x64 or x86, default is x64")]
        [ValidateSet("x64", "x86")]
        [String]
        $platform = "x64"
    )

    $batchfile = GetBatchCommand $version $platform
    CallBatch $batchfile
    Write-Host ("Visual Studio " + $version + " " + $platform + " set")
}

function GetVersionNumber($version)
{
    $versions = @{
        "2010"= "10.0";
        "2012"= "11.0";
        "2013"= "12.0";
        "2015"= "14.0"
    }

    $versions.Get_Item($version)
}

function GetVersion($VersionNumber)
{
    $VersionNumbers = @{
        "10.0" = "2010";
        "11.0" = "2012";
        "12.0" = "2013";
        "14.0" = "2015";
    }

    $VersionNumbers.Get_Item($VersionNumber)
}

function GetVSPath($version)
{
    $VersionNum = GetVersionNumber($version)
    $path = [io.path]::Combine(${env:ProgramFiles(x86)}, ("Microsoft Visual Studio " + $VersionNum), "vc", "vcvarsall.bat")
    $path
}

function GetBatchCommand($version, $platform)
{
    $path = GetVSPath $version
    $cmd = ('"' + $path + '"')
    if($platform -eq "x64")
    {
        $cmd = $cmd + " x64"
    }

    $cmd
}

function CallBatch($cmd)
{
    # Calls the batch file and copies the environment, as explained here: http://stackoverflow.com/a/2124759/871910
    cmd /c ("$cmd" + "&set") |
    foreach {
        if ($_ -match "=") {
            $v = $_.split("="); set-item -force -path "ENV:\$($v[0])"  -value "$($v[1])"
        }
    }
}

function GetCLVersion
{
    $cl = (Get-Command cl).Source
    if($cl.Contains("amd64"))
    {
        $platform = "x64"
    }
    else
    {
        $platform = "x86"
    }

    $idx = $cl.IndexOf("Microsoft Visual Studio")
    $VersionNumber = $cl.Substring($idx+24, 4)
    $version = GetVersion($VersionNumber)

    $version
    $platform
}

function Write-VSPrompt($color = "cyan")
{
    try
    {
        $result = GetCLVersion
        $version = $result[0]
        $platform = $result[1]
    }
    catch
    {
        return
    }

    Write-Host ("(VS " + $version + " " + $platform + ") ") -ForegroundColor $color -NoNewline
}

Export-ModuleMember ChooseVS
Export-ModuleMember Write-VSPrompt
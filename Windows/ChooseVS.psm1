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
        [ValidateSet("2010", "2012", "2013", "2015", "2017")]
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
        "2015"= "14.0";
		"2017"= "15.0";
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
		"15.0" = "2017";
    }

    $DecodedVersion = $VersionNumbers.Get_Item($VersionNumber)
    if ($DecodedVersion) 
    {
        $DecodedVersion
    }
    else
    {
        $VersionNumber    
    }
}

function GetVSEditionPath($VSpath)
{
    # Looks for a Visual Studio edition directly under $VSpath. Edition can be Community, Professional or Enterprise
    $edition = [io.path]::Combine($VSpath, "Enterprise", "VC")
    if(!(Test-Path -Path $edition))
    {
        $edition = [io.path]::Combine($VSpath, "Professional", "VC")
        if(!(Test-Path -Path $edition))
        {
            $edition = [io.path]::Combine($VSpath, "Community", "VC")
        }
    }
    $edition
}


function GetVSPath($version)
{
    if($version -ge 2017)
    {
        # Located here: "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat"
        # 'Community' may be 'Professional' or 'Enterprise', depending on the edition.
        $VSpath = [io.path]::Combine(${env:ProgramFiles(x86)}, "Microsoft Visual Studio", $version)
        $VSpath = GetVSEditionPath($VSpath)  # Adds the edition
        $VSpath = [io.path]::Combine($VSpath, "Auxiliary", "Build", "vcvarsall.bat")
    }
    else
    {
        $VersionNum = GetVersionNumber($version)
        $VSpath = [io.path]::Combine(${env:ProgramFiles(x86)}, ("Microsoft Visual Studio " + $VersionNum), "vc", "vcvarsall.bat")
    }

    if(!(Test-Path $VSpath))
    {
        Throw "Can't locate Visual Studio " + $version + " in " + $VSpath
    }
    $VSpath
}

function GetBatchCommand($version, $platform)
{
    $VSpath = GetVSPath $version
    $cmd = ('"' + $VSpath + '"')
    if($platform -eq "x64")
    {
        $cmd = $cmd + " x64"
    }
	if($version -eq "2015")
	{
		# Fix the problem causing RC.EXE not to be found (https://stackoverflow.com/a/46166632/871910)
		$cmd = $cmd + " 8.1"
	}

    $cmd
}

function CallBatch($cmd)
{
    # Calls the batch file and copies the environment, as explained here: http://stackoverflow.com/a/2124759/871910
    cmd /c ("$cmd" + "&set") |
    ForEach-Object {
        if ($_ -match "=") {
            $v = $_.split("="); set-item -force -path "ENV:\$($v[0])"  -value "$($v[1])"
        }
    }
}

function GetCLVersion
{
    $cl = (Get-Command cl).Source
    if($cl.Contains("amd64") -or $cl.Contains("x64"))
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
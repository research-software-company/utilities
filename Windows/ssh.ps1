function ssh
{
	[CmdletBinding()]
	Param( 
		[Parameter(Mandatory=$True, Position=0)]
		[string] $Address,
		[string] $Identity,
		[string] $Title = "SSH " + $Address,
        [string] $Background = [console]::BackgroundColor,
        [string] $Foreground = [console]::ForegroundColor
	)
    
    Write-Verbose("Changing console features")
    $oldForeground = [console]::ForegroundColor
    $oldBackground = [console]::BackgroundColor
	$oldTitle = $host.ui.RawUI.WindowTitle

    try
    {
	    $host.ui.RawUI.WindowTitle = $Title
        [console]::ForegroundColor = $Foreground
        [console]::BackgroundColor = $Background
        $host.ui.RawUI.BackgroundColor = $Background
	
        Clear-Host
	    Write-Host("Connecting to " + $Address + "...")
	    if($identity)
	    {
		    & ssh.exe $Address -i $Identity
	    }
	    else
	    {
		    & ssh.exe $Address
	    }
    }
    finally
    {
        Write-Verbose "Cleaning up"
    	$host.ui.RawUI.WindowTitle = $oldTitle
        [console]::ForegroundColor = $oldForeground
        [console]::BackgroundColor = $oldBackground
        $host.ui.RawUI.BackgroundColor = $oldBackground
    }

    # Outside the finally block because we don't want to clear the console of the SSH session crashed
    Clear-Host
    Write-Host "SSH Session ended"
}

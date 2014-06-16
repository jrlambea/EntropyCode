<#
    Script para normalizar los ficheros de ondas para OpenMPT
    2014/06/16
#>


<#
.SYNOPSIS
Set OffSet of a wave to center extrema.

.DESCRIPTION
∪∈(a,b) += 128 - ( Σ(a,b)/2 )


.PARAMETER File
File to modify.

.EXAMPLE
Set-OffsetCenter.ps1 -File example.txt

#>

[CmdletBinding()]

Param(
    [parameter( Mandatory = $true, Position = 0, valueFromPipeline = $true )]
    [alias( "f" )]
    [string]$File
)

# Test if the input file exists, if not exits with code 4
If ( !( Test-Path "$File" ) )
{
    "[e] Error file doesn't exist."; Exit 4

} else {
    $File = ( Get-ChildItem $File ).FullName

}

# Know the highest byte
function Get-Highest()
{
    [System.IO.BinaryReader]$br = [System.IO.File]::Open( $File, 3 )
    
    while ( ($br.PeekChar() -ne -1) )
    {
        $c = $br.ReadByte()
        if ( $c -gt $h ) { $h = $c }
    }
    
    $br.Close()
    
    Return $h
}

# Know the lowest byte
function Get-Lowest()
{
    $l = 512
    
    [System.IO.BinaryReader]$br = [System.IO.File]::Open( $File, 3 )
    
    while ( ($br.PeekChar() -ne -1) )
    {
        $c = $br.ReadByte()
        if ( $c -lt $l ) { $l = $c }
    }
    
    $br.Close()
    
    Return $l
}

# Write new file
function Write-File()
{

    [System.IO.BinaryReader]$br = [System.IO.File]::Open( $File, 3 )
    [System.IO.BinaryWriter]$bw = [System.IO.File]::Open( $File+".mod", 2 )
    
    while ( ($br.PeekChar() -ne -1) )
    {
        $c = $br.ReadByte()
        $bw.BaseStream.WriteByte( $c + $diff )
    }
    
    $br.Close()
    $bw.Close()

}

# Set all variables
$highest  = Get-Highest
$lowest   = Get-Lowest
$midpoint = [int](($highest + $lowest)/2)
$diff     = 128 - $midpoint

# Print some data
"The highest byte is "+$highest
"The lowest byte is "+$lowest
"The midpoint between both is "+$midpoint
"The difference between $midpoint and 128 is "+$diff
"Let's go!"
"Writing file to "+$File+".mod"
Write-File
"Done"

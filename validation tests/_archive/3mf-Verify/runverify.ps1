<#

.DESCRIPTION
Script will run 3mfverify.exe tool on all 3MF files within a specified folder, with possible recursion. The tool takes in two parameters -d (the directory: defaults to current) and -r (recursive option: defaults to 0)

.EXAMPLE
./runverify.ps1
./runverify.ps1 MYFOLDER
./runverify.ps1 MYFOLDER -r 1

.NOTES
The recursive parameter is a powershell bool, which can hold the values of $True, $False, 1, or 0.

The 3MFVerify tool shows links to the appropriate erros in the core and material specs whenever relevant and possible. The links are currently to HTML files since they have not been made public yet.

#>

Param
(
	[string]$d = '.\',
	[bool]$r = $false
)

function verify ($dir)
{
	IF($r) 
	{
		$dirs =(Get-ChildItem $dir -directory -recurse)
	}
	ELSE
	{
			$dirs =(Get-ChildItem $dir -directory)
	}
	
	Foreach($mdir in $dirs)
	{
		helper($mdir)
	}
}

function helper ($mdir)
{
			$files = (Get-ChildItem ($mdir.FullName +'\*.3mf')).Fullname
			IF (Test-Path ($mdir.name + '_verify.txt'))
			{
				Remove-Item ($mdir.name + '_verify.txt')
			}
			Foreach($file in $files) 
			{
				./3mfverify.exe ($file) core.xsd material.xsd >> ($mdir.name + '_verify.txt')
			}
}

verify((get-item $d))

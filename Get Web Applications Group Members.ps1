Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue

$outputFile = "C:\Temp\FullSecurityScan.txt"

Remove-Item $outputFile -Force -ErrorAction SilentlyContinue

$sites = Get-SPSite -WebApplication https://intranet.company.com -Limit All

foreach ($site in $sites)
{
    $rootWeb = $site.RootWeb

    Write-Output $rootWeb.Url
    $rootWeb.Url | Out-File $outputFile -Append

    foreach ($group in $rootWeb.SiteGroups)
    {
		$text = "`t" + $group.Name
        Write-Output $group.Name
		$text | Out-File $outputFile -Append

        foreach ($user in $group.Users)
        {
            if ($user.LoginName -notin "c:0(.s|true","c:0!.s|windows")
            {
                $loginName = $user.LoginName.Replace("i:0#.w|", "").Replace("i:0#.f|sql_membership|", "") # handles any FBA legacy
                $text = "`t`t $loginName ($($user.Email))"
                Write-Output $text
                $text | Out-File $outputFile -Append
			}
        }
    }

    Write-Output ""
    "" | Out-File $outputFile -Append
}

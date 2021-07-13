Add-PSSnapin Microsoft.SharePoint.PowerShell

function Get-SPSiteInventory {
Param(
[string]$Url,
[switch]$SiteCollection,
[switch]$WebApplication,
[string]$CSVExport
)

Remove-Item $CSVExport -ErrorAction SilentlyContinue

Start-SPAssignment -Global
    if ($SiteCollection) {
        $site = Get-SPSite $Url
        $allWebs = $site.allwebs
        foreach ($spweb in $allWebs) {
            " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - "
            $spweb.Url
            $spweb.Lists | Select ParentWebUrl, Title, BaseType, EnableVersioning, HasUniqueRoleAssignments, ItemCount, Created, Author | Export-CSV $CSVExport -NoTypeInformation -Append #-Delimiter ";"
            $spweb.dispose()
        }
        $site.dispose()
    } 
    elseif ($WebApplication) {
        $wa = Get-SPWebApplication $Url
        $allSites = $wa | Get-SPSite -Limit all
        foreach ($spsite in $allSites) {
            $allWebs = $spsite.allwebs
            foreach ($spweb in $allWebs) {
            " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - "
            $spweb
            $spweb.Lists | Select ParentWebUrl, Title, BaseType, EnableVersioning, HasUniqueRoleAssignments, ItemCount, Created, Author | Export-CSV $CSVExport -NoTypeInformation -Append #-Delimiter ";"
            $spweb.dispose()
            }
        }
    }
Stop-SPAssignment -Global
}


Get-SPSiteInventory -Url https://intranet.company.com -WebApplication -CSVExport "C:\Temp\LibraryIA.csv"

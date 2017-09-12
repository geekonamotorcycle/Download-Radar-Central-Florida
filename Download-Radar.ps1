$date = Read-Host "Enter the date YYYYMMDD:" $
$date = ("http://thredds.ucar.edu/thredds/catalog/nexrad/level3/DTA/TBW/" + $date + "/" + "catalog.xml")
#$date = "20170911"

[string]$basePath = "http://thredds.ucar.edu/thredds/fileServer/";
Invoke-WebRequest -Uri $date -OutFile "newcatalog.xml";
$catalog = [xml] (Get-Content -Path ./newcatalog.xml);

foreach ($location in $catalog.catalog.dataset.dataset) {
    $name = $location.name
    $outpath = ("./nids/" + $name);
    $dPath = ($basePath + $location.urlPath);
    Write-Host "Downloading to $outpath";
    Invoke-WebRequest -Uri $dPath -OutFile $outpath;
}
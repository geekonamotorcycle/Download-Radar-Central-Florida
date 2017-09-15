
# Download-Radar.ps1
# Version 0.9
# Designed for powershell 6.0 Beta 7 for Linux
# Copyright 2017 - Joshua Porrata
# Not for business use without an inexpensive license, contact
# Localbeautytampabay@gmail.com for questions about a license 
# there is no warranty, this might destroy everything it touches. 

function checkURI ([string]$date) {
    $testURI = (Invoke-WebRequest -Uri $date).StatusCode;
    #$testURI;
    if ($testURI -ne "200") {
        Write-Host "I tested the connection to `n$date`nUnfortunately either you have no internet connection or the date you entered is not available." -ForegroundColor Red;
        Exit;
    };
    Write-Host "`nTested`n$date`nStatus: Passed`n" -ForegroundColor Green
};
Function Copyright {
    Write-Host "`n***********************************************" -BackgroundColor Black -ForegroundColor DarkGreen
    Write-Host "***Copyright 2017, Joshua Porrata**************" -BackgroundColor Black -ForegroundColor DarkGreen
    Write-Host "***This program is not free for business use***" -BackgroundColor Black -ForegroundColor DarkGreen
    Write-Host "***Contact me at localbeautytampabay@gmail.com*" -BackgroundColor Black -ForegroundColor DarkGreen
    Write-Host "***for a cheap business license****************" -BackgroundColor Black -ForegroundColor DarkGreen
    Write-Host "***Donations are wholeheartedly accepted ******" -BackgroundColor Black -ForegroundColor Red
    Write-Host "***accepted @ www.paypal.me/lbtpa**************" -BackgroundColor Black -ForegroundColor Red
    Write-Host "***********************************************`n" -BackgroundColor Black -ForegroundColor DarkGreen
}

Clear-Host

copyright
Write-Host "This Software will Download Datasets for EAST-CONUS and NEXRAD3 out of TampaBay." -ForegroundColor Green
$sensor = Read-Host "Enter 's' for satelite or 'r' for radar ";
switch ($sensor) {
    s {
        Write-Host "You have selected Satellite";
        $sensor = "s";
    };
    r {
        Write-Host "You have selected Radar";
        $sensor = "r";
    };
    Default { 
        Write-Host "Defaulted to Local Radar";
        $sensor = "r";
    };
};

$date = Read-Host "Enter the date YYYYMMDD ";
if ($sensor.toLower().Contains("r")) {
    $outDir = ("./nids/DTA/TBW/" + $date + "/");
    $date = ("http://thredds.ucar.edu/thredds/catalog/nexrad/level3/DTA/TBW/" + $date + "/" + "catalog.xml");
    checkURI -date $date
 
};
if ($sensor.toLower().Contains("s")) {
    $outDir = ("./nids/WV/EAST-CONUS/" + $date + "/");
    $date = ("http://thredds.ucar.edu/thredds/catalog/satellite/WV/EAST-CONUS_4km/" + $date + "/" + "catalog.xml");
    checkURI -date $date
};
[string]$basePath = "http://thredds.ucar.edu/thredds/fileServer/";
Invoke-WebRequest -Uri $date -OutFile "newcatalog.xml";
$catalog = [xml] (Get-Content -Path ./newcatalog.xml);

foreach ($location in $catalog.catalog.dataset.dataset) {
    $name = $location.name;
    $outpath = ($outDir + $name);
    $dirTest = Test-Path -Path $outDir
    if (-not $dirTest) {
        New-Item $outDir -ItemType Directory
    };
    $dPath = ($basePath + $location.urlPath);
    Write-Host "Downloading to $outpath";
    Invoke-WebRequest -Uri $dPath -OutFile $outpath;
};

Copyright
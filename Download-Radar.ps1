[string]$basePath = "http://thredds.ucar.edu/thredds/fileServer/";
$catalog = [xml] (Get-Content -Path ./newcatalog.xml);
Invoke-WebRequest -Uri "http://thredds.ucar.edu/thredds/catalog/nexrad/level3/DTA/TBW/20170910/catalog.xml" -OutFile "newcatalog.xml";
$catalog = [xml] (Get-Content -Path ./newcatalog.xml);
$nidPath = $catalog.catalog.dataset.dataset.urlPath[0];
$dPath = ($basePath + $nidPath);
$dPath;
$outpath = ("./nids/" + $catalog.catalog.dataset.dataset.name[0])
Invoke-WebRequest -uri $dpath -OutFile $outpath;

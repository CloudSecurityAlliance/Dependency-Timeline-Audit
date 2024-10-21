<?php

// Function to parse dependencies from composer.json
function parseDependencies($filePath) {
    $composerJsonPath = dirname($filePath) . '/composer.json';
    $dependencies = [];
    
    if (file_exists($composerJsonPath)) {
        $composerJson = json_decode(file_get_contents($composerJsonPath), true);
        if (isset($composerJson['require'])) {
            $dependencies = array_keys($composerJson['require']);
        }
    }
    
    return array_unique($dependencies);
}

// Function to get package info from ecosyste.ms API
function getPackageInfo($packageName) {
    $url = "https://packages.ecosyste.ms/api/v1/registries/packagist.org/packages/" . urlencode($packageName);
    $response = @file_get_contents($url);
    if ($response === false) {
        return null;
    }
    return json_decode($response, true);
}

// Function to get package dependencies
function getPackageDependencies($packageName, $version) {
    $url = "https://packages.ecosyste.ms/api/v1/registries/packagist.org/packages/" . urlencode($packageName) . "/versions/" . urlencode($version);
    $response = @file_get_contents($url);
    if ($response === false) {
        return [];
    }
    $packageData = json_decode($response, true);
    return isset($packageData['dependencies']) ? array_column($packageData['dependencies'], 'package_name') : [];
}

// Function to write data to cache
function writeToCache($cacheDir, $packageName, $data) {
    $timestamp = date('YmdHis');
    $parts = explode('/', $packageName);
    
    if (count($parts) > 1) {
        // For vendor/package format
        $dirPath = $cacheDir . '/ecosyste.ms/packagist.org/' . $parts[0];
        $fileName = $parts[1] . '-' . $timestamp . '.json';
    } else {
        // For packages without vendor (should be rare)
        $dirPath = $cacheDir . '/ecosyste.ms/packagist.org';
        $fileName = $packageName . '-' . $timestamp . '.json';
    }
    
    if (!is_dir($dirPath)) {
        mkdir($dirPath, 0777, true);
    }
    
    $filePath = $dirPath . '/' . $fileName;
    file_put_contents($filePath, json_encode($data, JSON_PRETTY_PRINT));
}

// Main function
function main($checkFile, $cacheDir) {
    $dependencies = parseDependencies($checkFile);
    $checkedPackages = [];
    
    foreach ($dependencies as $packageName) {
        checkPackage($packageName, $checkedPackages, $cacheDir);
    }
}

function checkPackage($packageName, &$checkedPackages, $cacheDir) {
    if (in_array($packageName, $checkedPackages)) {
        return;
    }
    
    $checkedPackages[] = $packageName;
    
    echo "Checking package: $packageName\n";
    $packageInfo = getPackageInfo($packageName);
    
    if ($packageInfo) {
        writeToCache($cacheDir, $packageName, $packageInfo);
        
        $latestVersion = $packageInfo['latest_release_number'];
        if ($latestVersion) {
            $dependencies = getPackageDependencies($packageName, $latestVersion);
            foreach ($dependencies as $dep) {
                checkPackage($dep, $checkedPackages, $cacheDir);
            }
        }
    } else {
        echo "Package not found: $packageName\n";
    }
    
    // Rate limiting
    sleep(1);
}

// Parse command line arguments
$options = getopt("", ["check-file:", "cache-dir:"]);

if (!isset($options['check-file']) || !isset($options['cache-dir'])) {
    echo "Usage: php script.php --check-file=<file> --cache-dir=<dir>\n";
    exit(1);
}

$checkFile = $options['check-file'];
$cacheDir = $options['cache-dir'];

main($checkFile, $cacheDir);

?>

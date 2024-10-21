const fs = require('fs');
const path = require('path');
const https = require('https');
const { promisify } = require('util');
const readFile = promisify(fs.readFile);
const writeFile = promisify(fs.writeFile);
const mkdir = promisify(fs.mkdir);

// Function to parse imports from a JavaScript file
function parseImports(content) {
  const importRegex = /(?:import|require)\s*\(?['"]([^'"]+)['"]\)?/g;
  const imports = new Set();
  let match;
  while ((match = importRegex.exec(content)) !== null) {
    const packageName = match[1].split('/')[0];
    if (!packageName.startsWith('.')) {
      imports.add(packageName);
    }
  }
  return Array.from(imports);
}

// Function to get package info from ecosyste.ms API
function getPackageInfo(packageName) {
  return new Promise((resolve, reject) => {
    const url = `https://packages.ecosyste.ms/api/v1/registries/npmjs.org/packages/${packageName}`;
    https.get(url, (res) => {
      let data = '';
      res.on('data', (chunk) => data += chunk);
      res.on('end', () => {
        if (res.statusCode === 200) {
          resolve(JSON.parse(data));
        } else {
          resolve(null);
        }
      });
    }).on('error', reject);
  });
}

// Function to get package dependencies
function getPackageDependencies(packageName, version) {
  return new Promise((resolve, reject) => {
    const url = `https://packages.ecosyste.ms/api/v1/registries/npmjs.org/packages/${packageName}/versions/${version}`;
    https.get(url, (res) => {
      let data = '';
      res.on('data', (chunk) => data += chunk);
      res.on('end', () => {
        if (res.statusCode === 200) {
          const packageData = JSON.parse(data);
          if (packageData && packageData.dependencies && Array.isArray(packageData.dependencies)) {
            resolve(packageData.dependencies.map(dep => dep.package_name));
          } else {
            resolve([]);
          }
        } else {
          resolve([]);
        }
      });
    }).on('error', reject);
  });
}

// Function to write data to cache
async function writeToCache(cacheDir, packageName, data) {
  const timestamp = new Date().toISOString().replace(/[:.]/g, '');
  let fileName, dirPath;

  if (packageName.startsWith('@')) {
    // For namespaced packages
    const [namespace, name] = packageName.split('/');
    dirPath = path.join(cacheDir, 'ecosyste.ms', 'npmjs.org', namespace);
    fileName = `${name}-${timestamp}.json`;
  } else {
    // For non-namespaced packages
    dirPath = path.join(cacheDir, 'ecosyste.ms', 'npmjs.org');
    fileName = `${packageName}-${timestamp}.json`;
  }

  const filePath = path.join(dirPath, fileName);
  
  await mkdir(dirPath, { recursive: true });
  await writeFile(filePath, JSON.stringify(data, null, 2));
}

// Main function
async function main(checkFile, cacheDir) {
  const content = await readFile(checkFile, 'utf8');
  const imports = parseImports(content);
  const checkedPackages = new Set();

  async function checkPackage(packageName) {
    if (checkedPackages.has(packageName)) return;
    checkedPackages.add(packageName);

    console.log(`Checking package: ${packageName}`);
    const packageInfo = await getPackageInfo(packageName);

    if (packageInfo) {
      await writeToCache(cacheDir, packageName, packageInfo);

      const latestVersion = packageInfo.latest_release_number;
      if (latestVersion) {
        const dependencies = await getPackageDependencies(packageName, latestVersion);
        for (const dep of dependencies) {
          await checkPackage(dep);
        }
      }
    } else {
      console.log(`Package not found: ${packageName}`);
    }

    // Rate limiting
    await new Promise(resolve => setTimeout(resolve, 1000));
  }

  for (const packageName of imports) {
    await checkPackage(packageName);
  }
}

// Parse command line arguments
const args = process.argv.slice(2);
const checkFile = args.find(arg => arg.startsWith('--check-file=')).split('=')[1];
const cacheDir = args.find(arg => arg.startsWith('--cache-dir=')).split('=')[1];

if (!checkFile || !cacheDir) {
  console.error('Usage: node script.js --check-file=<file> --cache-dir=<dir>');
  process.exit(1);
}

main(checkFile, cacheDir).catch(console.error);

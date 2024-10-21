#!/usr/bin/env python3

import argparse
import os
import re
import json
import time
import requests
import yaml
from datetime import datetime

def parse_imports(file_path):
    with open(file_path, 'r') as file:
        content = file.read()
    
    # More specific regex patterns
    import_pattern = re.compile(r'^\s*import\s+([\w.]+)(?:\s+as\s+\w+)?(?:\s*,\s*([\w.]+)(?:\s+as\s+\w+)?)*', re.MULTILINE)
    from_import_pattern = re.compile(r'^\s*from\s+([\w.]+)\s+import', re.MULTILINE)
    
    imports = set()
    
    # Process 'import' statements
    for match in import_pattern.finditer(content):
        imports.update(name.split('.')[0] for name in match.groups() if name)
    
    # Process 'from ... import' statements
    for match in from_import_pattern.finditer(content):
        imports.add(match.group(1).split('.')[0])
    
    return list(imports)

def get_package_info(package_name):
    url = f"https://packages.ecosyste.ms/api/v1/registries/pypi.org/packages/{package_name}"
    response = requests.get(url)
    if response.status_code == 200:
        return yaml.safe_load(response.text)
    return None

def get_package_dependencies(package_name, version):
    url = f"https://packages.ecosyste.ms/api/v1/registries/pypi.org/packages/{package_name}/versions/{version}"
    response = requests.get(url)
    if response.status_code == 200:
        data = yaml.safe_load(response.text)
        return [dep['package_name'] for dep in data.get('dependencies', [])]
    return []

def write_to_cache(cache_dir, package_name, data):
    timestamp = datetime.now().strftime("%Y%m%d%H%M%S")
    file_name = f"{package_name}-{timestamp}.json"
    file_path = os.path.join(cache_dir, "ecosyste.ms", "pypi.org", file_name)
    
    os.makedirs(os.path.dirname(file_path), exist_ok=True)
    
    with open(file_path, 'w') as file:
        json.dump(data, file, indent=2)

def main(check_file, cache_dir):
    imports = parse_imports(check_file)
    checked_packages = set()
    
    def check_package(package_name):
        if package_name in checked_packages:
            return
        
        checked_packages.add(package_name)
        
        print(f"Checking package: {package_name}")
        package_info = get_package_info(package_name)
        
        if package_info:
            write_to_cache(cache_dir, package_name, package_info)
            
            latest_version = package_info.get('latest_release_number')
            if latest_version:
                dependencies = get_package_dependencies(package_name, latest_version)
                for dep in dependencies:
                    check_package(dep)
        else:
            print(f"Package not found: {package_name}")
        
        # Rate limiting
        time.sleep(1)
    
    for package in imports:
        check_package(package)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Check dependencies using ecosyste.ms API")
    parser.add_argument("--check-file", required=True, help="File to check for imports")
    parser.add_argument("--cache-dir", required=True, help="Directory to cache results")
    args = parser.parse_args()
    
    main(args.check_file, args.cache_dir)
    

#!/usr/bin/env python3

import argparse
import os
import requests
import json
from datetime import datetime

def list_ecosystem_names():
    url = "https://packages.ecosyste.ms/api/v1/registries"
    response = requests.get(url)
    if response.status_code == 200:
        registries = response.json()
        ecosystem_names = {registry['name'] for registry in registries}
        for name in sorted(ecosystem_names):
            print(name)
    else:
        print(f"Failed to fetch ecosystem names: {response.status_code}")
        print("Response content:", response.content)  # Debugging line

def get_registry_name(ecosystem_name):
    url = "https://packages.ecosyste.ms/api/v1/registries"
    response = requests.get(url)
    if response.status_code == 200:
        registries = response.json()
        for registry in registries:
            if registry['name'] == ecosystem_name:
                return registry['name']
    return None

def get_package_dependents(ecosystem_name, package_name, number=10, cache_dir=None):
    registry_name = get_registry_name(ecosystem_name)
    if not registry_name:
        print(f"Ecosystem '{ecosystem_name}' not found.")
        return

    page = 1
    fetched = 0
    while fetched < number:
        url = f"https://packages.ecosyste.ms/api/v1/registries/{registry_name}/packages/{package_name}/dependent_packages"
        params = {'page': page, 'per_page': 10}
        response = requests.get(url, params=params)
        if response.status_code == 200:
            dependents = response.json()
            if not dependents:
                print(f"No more dependents found for package '{package_name}' in ecosystem '{ecosystem_name}'.")
                break
            print(f"Page {page} results:")
            print(dependents)  # Print raw JSON response

            if cache_dir:
                timestamp = datetime.now().strftime("%Y%m%d%H%M%S")
                for dependent in dependents:
                    dependent_name = dependent['name']
                    cache_path = os.path.join(cache_dir, "ecosyste.ms", ecosystem_name, f"{dependent_name}-{timestamp}.json")
                    os.makedirs(os.path.dirname(cache_path), exist_ok=True)
                    with open(cache_path, 'w') as f:
                        json.dump(dependent, f, indent=2)

            fetched += len(dependents)
            page += 1
        elif response.status_code == 404:
            print(f"Package '{package_name}' or ecosystem '{ecosystem_name}' not found.")
            break
        else:
            print(f"Failed to fetch dependents for package '{package_name}' in ecosystem '{ecosystem_name}': {response.status_code}")
            print("Response content:", response.content)  # Debugging line
            break

def main():
    parser = argparse.ArgumentParser(description="Ecosyste.ms API client")
    parser.add_argument('--list-ecosystem-names', action='store_true', help='List all ecosystem names')
    parser.add_argument('--use-ecosystem-name', type=str, help='Specify the ecosystem name to use')
    parser.add_argument('--get-package-dependents', type=str, help='Get dependents of the specified package')
    parser.add_argument('--get-package-dependents-number', type=int, default=10, help='Number of dependents to fetch (default: 10)')
    parser.add_argument('--cache-dir', type=str, help='Specify the cache directory')
    args = parser.parse_args()

    if not any(vars(args).values()):
        parser.print_help()
    elif args.list_ecosystem_names:
        list_ecosystem_names()
    elif args.use_ecosystem_name and args.get_package_dependents:
        get_package_dependents(args.use_ecosystem_name, args.get_package_dependents, args.get_package_dependents_number, args.cache_dir)
    else:
        parser.print_help()

if __name__ == "__main__":
    main()


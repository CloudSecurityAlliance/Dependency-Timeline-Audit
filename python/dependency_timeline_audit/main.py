import sys
import os
import argparse
from dependency_timeline_audit import audit
import subprocess
import json

def check_installed_from_pip():
    try:
        # Determine whether to use pip or pip3
        python_version = sys.version_info.major
        pip_command = "pip3" if python_version == 3 else "pip"

        # Run pip list --format json
        result = subprocess.run([pip_command, "list", "--format", "json"], stdout=subprocess.PIPE, text=True)
        installed_packages = json.loads(result.stdout)

        print("Installed packages from pip:")
        for package in installed_packages:
            package_name = package['name']
            version = package['version']
            release_date = audit.get_pypi_release_date(package_name, version)
            print(f"{package_name}: Version {version}, released on {release_date}")

    except Exception as e:
        print(f"Error checking installed packages: {str(e)}")


def check_file(file_path):
    if not os.path.isfile(file_path):
        print(f"Error: {file_path} not found.")
        sys.exit(1)

    all_imports = audit.process_imports(file_path)

    print(f"Imports found in {file_path}:")
    for imp in all_imports:
        version = audit.get_package_version(imp)
        print(f"{imp}: {version}")


def main():
    parser = argparse.ArgumentParser(description="Dependency Timeline Audit")
    parser.add_argument("--check-installed-from-pip", action="store_true", help="Check versions installed via pip")
    parser.add_argument("--check-file", help="Check imports in a specific Python file")

    args = parser.parse_args()

    if args.check_installed_from_pip:
        check_installed_from_pip()
    elif args.check_file:
        check_file(args.check_file)
    else:
        print("No command provided. Use --help for options.")

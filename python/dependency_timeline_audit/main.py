import sys
import os
from dependency_timeline_audit import audit

def main():
    if len(sys.argv) != 2:
        print("Usage: dependency_timeline_audit <python_file>")
        sys.exit(1)

    python_file = sys.argv[1]

    if not os.path.isfile(python_file):
        print(f"Error: {python_file} not found.")
        sys.exit(1)

    all_imports = audit.process_imports(python_file)

    print(f"Imports found in {python_file}:")
    for imp in all_imports:
        version = audit.get_package_version(imp)
        print(f"{imp}: {version}")

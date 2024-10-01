import ast
import importlib_metadata
import importlib.util
import sys
import requests

# List of special modules to exclude
EXCLUDED_MODULES = {"__main__", "__init__", "__name__", "__file__", "__package__"}

def get_pypi_release_date(package_name, version):
    try:
        # Fetch release data from PyPI
        response = requests.get(f"https://pypi.org/pypi/{package_name}/json")
        if response.status_code == 200:
            data = response.json()
            if 'releases' in data and version in data['releases']:
                release_info = data['releases'][version]
                if release_info and 'upload_time' in release_info[0]:
                    release_date = release_info[0]['upload_time']
                    return release_date.split("T")[0]  # Just the date part
                else:
                    return "Release info not available"
            else:
                return f"Version {version} not found on PyPI"
        else:
            return "Error fetching release data from PyPI"
    except Exception as e:
        return f"Error fetching release date: {str(e)}"

def get_package_version(package_name):
    if package_name in EXCLUDED_MODULES:
        return f"Special module ({package_name})"

    try:
        # First, try to get the version for installed third-party packages
        dist = importlib_metadata.distribution(package_name)
        version = dist.version
        release_date = get_pypi_release_date(package_name, version)
        return f"Version {version} installed in {dist.locate_file('')}, released on {release_date}"
        
    except importlib_metadata.PackageNotFoundError:
        # If the package is not found, check if it's part of the standard library or built-in
        if package_name in sys.builtin_module_names:
            return f"Python built-in (Python version {sys.version.split()[0]})"
        
        # Check if it's part of the standard library
        spec = importlib.util.find_spec(package_name)
        if spec is not None and spec.origin and 'python' in spec.origin:
            return f"Standard library (Python version {sys.version.split()[0]})"
        else:
            return f"{package_name} not installed."
    
    except ValueError:
        return f"{package_name} has no spec available"
    except ModuleNotFoundError:
        return f"{package_name} not found."

def extract_imports(file_path):
    with open(file_path, 'r') as file:
        tree = ast.parse(file.read(), filename=file_path)
    imports = []
    for node in ast.walk(tree):
        if isinstance(node, ast.Import):
            for alias in node.names:
                imports.append(alias.name.split('.')[0])
        elif isinstance(node, ast.ImportFrom):
            imports.append(node.module.split('.')[0])
    return imports

def process_imports(file_path, processed_files=set()):
    imports = extract_imports(file_path)
    all_imports = set(imports)

    # Recursively process imports from imported files
    for module in imports:
        try:
            module_path = importlib.util.find_spec(module).origin
            if module_path and module_path.endswith('.py') and module_path not in processed_files:
                processed_files.add(module_path)
                all_imports.update(process_imports(module_path, processed_files))
        except Exception:
            continue  # Skip built-in modules or modules not found

    return all_imports


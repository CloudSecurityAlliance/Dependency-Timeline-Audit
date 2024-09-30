from setuptools import setup, find_packages

setup(
    name='dependency_timeline_audit',
    version='0.1.12',
    packages=find_packages(),
    install_requires=[
        'importlib-metadata',
    ],
    entry_points={
        'console_scripts': [
            'dependency_timeline_audit=dependency_timeline_audit.main:main',
        ],
    },
    author='Your Name',
    description='A tool to audit Python project dependencies and their versions.',
    url='https://github.com/yourusername/dependency_timeline_audit',
)

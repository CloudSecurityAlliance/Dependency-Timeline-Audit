# Dependency Timeline Audit

Traditional software audits check what versions of software you are using and if they have known vulnerabilities. Dependency Timeline Audit goes further by checking when your software dependencies were released because even the latest version might be many years old. This tool provides a new dimension to dependency risk management by revealing not just outdated software, but also potentially unmaintained ones. Dependency Timeline Audit helps development teams make more informed decisions about their software supply chain by offering insights into the age of your dependencies, regardless of version numbers. This approach enables better risk assessment, helps prioritize updates, and supports long-term project health by identifying dependencies that may pose hidden risks due to a lack of active maintenance.

## Process

Dependency Timeline Audit follows these steps to provide a comprehensive timeline view of your project's dependencies:

1. Software Inventory: Create an inventory of all software dependencies used in the project, including versions when possible. Please note these are proof of concept tools, the ultimate goal is to embed support for this process into SBOM and other auditing tools that are already a part of peoples toolchains.
2. System Version Check: If needed, inventory the specific versions of dependencies installed on the system running the audit, or within the virtuualenv, or the remote system and so on.
3. Release Date Query: Query the appropriate language-specific package database to find:
   - The release date of the specific version you're using
   - The latest version available and its release date
   - Cache these results and also update the latest release as needed
4. Exceptions / information database
   - We are looking to provide a database of information, e.g. in Python the importlib-metadata has some weird verisoning issues and older versions are ok, basically we want to reduce the incidence of false positives
   - We also want to allow people to flag and log their own exceptions so that they can reduce false positives and focus on what actually matters.
5. Reporting: Generate a report that includes:
   - Detailed data on each dependency, including current version, release date, latest version, and latest release date
   - A simple CLI GUI tool to visualize and interact with the timeline data
   - Options for human readable output and JSON formatted output

This process ensures a thorough examination of your project's dependency timeline, providing valuable insights for risk management and maintenance planning.

## Future plans include 

* This functionality can be integrated into SBOM tools like Syft and vulnerability scanning tools like Grype
* CI/CD compatible tooling so these checks can be easily integrated into build pipelines
* Exceptions database (e.g. some old/unmaintained software is "done" and doesn't pose any significant risk
* Language support:
  * Ruby on Rails
  * Python
  * NPM
  * Rust
  * Go
  * PHP
  * Java
  * Swift
  * Perl
  * Docker images
  * Other image formats

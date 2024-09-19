# Dependency Timeline Audit

Traditional software audits check what versions of software you are using and if they have known vulnerabilities. Dependency Timeline Audit goes further by checking when your software dependencies were released because even the latest version might be many years old. This tool provides a new dimension to dependency risk management by revealing not just outdated software, but also potentially unmaintained ones. Dependency Timeline Audit helps development teams make more informed decisions about their software supply chain by offering insights into the age of your dependencies, regardless of version numbers. This approach enables better risk assessment, helps prioritize updates, and supports long-term project health by identifying dependencies that may pose hidden risks due to a lack of active maintenance.

## Process

Dependency Timeline Audit follows these steps to provide a comprehensive timeline view of your project's dependencies:

1. Software Inventory: Create an inventory of all software dependencies used in the project, including versions when possible. 
2. System Version Check: If needed, inventory the specific versions of dependencies installed on the system running the audit.
3. Release Date Query: Query the appropriate language-specific package database to find:
   - The release date of the specific version you're using
   - The latest version available and its release date
4. Reporting: Generate a report that includes:
   - Detailed data on each dependency, including current version, release date, latest version, and latest release date
   - A simple CLI GUI tool to visualize and interact with the timeline data

This process ensures a thorough examination of your project's dependency timeline, providing valuable insights for risk management and maintenance planning.

Future plans include integrating this functionality into SBOM tools like Syft, and vulnerability scanning tools like Grype.

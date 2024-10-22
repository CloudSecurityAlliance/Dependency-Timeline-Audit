# Dependency Timeline Audit

Traditional software audits check what versions of software you are using and if they have known vulnerabilities. Dependency Timeline Audit goes further by checking when your software dependencies were released because even the latest version might be many years old. This tool provides a new dimension to dependency risk management by revealing not just outdated software, but also potentially unmaintained ones. Dependency Timeline Audit helps development teams make more informed decisions about their software supply chain by offering insights into the age of your dependencies, regardless of version numbers. This approach enables better risk assessment, helps prioritize updates, and supports long-term project health by identifying dependencies that may pose hidden risks due to a lack of active maintenance.

## Process

### 1. Software Inventory

Create a comprehensive inventory of all software dependencies used in the project. This inventory can be generated in the following ways:

- An explicit list of packages (simple text file or command line argument)
- Scan project files for dependencies using regex-based import scanning
- Scan project files for dependencies using imports and loading (e.g. Python ast)
- Scan SBOM file (SPDX, CycloneDX)
- Lock files (e.g., `package-lock.json`, `Pipfile.lock`).

Goal: Embed support for SBOM and other auditing tools already integrated into project toolchains, making the process seamless.

### 2. System Version Check

Once the inventory of dependencies is gathered, check the specific versions of packages installed on:
- The system running the audit.
- Virtual environments (if applicable).
- Remote systems (as needed).

Goal: Create an actual baseline of what is installed and used. Do not require the use of third party tools, but we want to support third party tools.

## 3. Get Package Information

Query relevant package ecosystems (via APIs or scraping language-specific package repositories) to gather detailed package information and compare it to the versions installed on the system:

- Data sources:
  - ecosyste.ms API for package metadata.
  - Libraries.io API for ecosystem-wide package data.
  - Snyk API for security and package health insights.
  - Language-specific databases (e.g., `pypi.org` for Python).
- Gather:
  - The latest available version in the ecosystem.
  - Dependency relationships, license information, security vulnerabilities, etc.
- Cache results for future comparisons and periodically update them to ensure accuracy.

Goal: get a blended set of data that is useful and easy, it also must be free.

## 4. Exceptions / Information Database
Maintain a custom database to manage exceptions and reduce false positives:
- Custom Exceptions: Allow users to flag certain dependency versions or known issues (e.g., older versions of `importlib-metadata` causing issues).
- False Positive Mitigation: Store exceptions to avoid unnecessary warnings and focus the audit on critical updates or issues.
- Known problems, e.g. youtube-downloader should be replaced with yt-dlp

Goal: allow people to easily contribute, once they research a problem they should be able to submit their analysis easily.

## 5. Analyzing data

Analyze data:
  - Version Comparison: Compare the installed version against the latest available version from the ecosystem, and flag any discrepancies.
  - Check if the URLs listed work
  - Check how active the package maintainers are

GFoal: allow people to create new ways to analyze the data.

## 6. Reporting
Generate comprehensive reports with detailed data on each dependency, including:
- **Detailed Dependency Data**:
  - Current version installed on the system.
  - Specified version in the project or SBOM.
  - Latest available version in the ecosystem.
  - Release dates, dependency relationships, license information, and potential vulnerabilities.
  - Highlight discrepancies between installed versions and the latest versions available.
- **Interactive Visualization**:
  - A simple CLI GUI tool to visualize and interact with the dependency timeline data, providing an intuitive view of the project’s dependencies and any version mismatches.
- **Output Options**:
  - Human-readable output for easier review by developers or project managers.
  - JSON-formatted output for automated integration into CI/CD pipelines or auditing tools.

This process ensures a thorough examination of your project's dependency timeline, providing valuable insights for risk management and maintenance planning.

## Example of easy to measure and potentially useful data

- [ ] Who is the primary contributor for each of your dependencies?
- [ ] Does one person maintain a significant percentage of your dependencies?
- [ ] Does the project have a public repo/website/etc?
- [ ] When was a package _first_ released?
- [ ] Packages that were released in the last few days/hours? (potential typosquat/hallucination attack)
- [ ] Orphan URLs and domains

## Future plans include 

* This functionality can be integrated into SBOM tools like Syft and vulnerability scanning tools like Grype
* CI/CD compatible tooling so these checks can be easily integrated into build pipelines
* Exceptions database (e.g. some old/unmaintained software is "done" and doesn't pose any significant risk)
* Data support:
  * Ecosyste.ms (https://packages.ecosyste.ms/)
  * Libraries.io (https://libraries.io/)
  * Snyk (https://snyk.io/advisor/)
* Language support:
  * .NET (C#, F#, VB.NET) (NuGet)
  * C++ (Conan, Vcpkg)
  * Clojure (Clojars)
  * Dart (Pub)
  * Elixir (Hex)
  * Go (Go Modules,)
  * Haskell (Hackage)
  * Java (Maven Central, JCenter)
  * JavaScript/Node.js (NPM)
  * Julia (Julia General Registry)
  * Lua (LuaRocks)
  * Objective-C (CocoaPods, Carthage)
  * PHP (Packagist)
  * Perl (CPAN)
  * Python (PyPi)
  * R (CRAN - Comprehensive R Archive Network)
  * Ruby on Rails (rubygems)
  * Rust (crates.io)
  * Scala (Maven Central, Ivy, Bintray JCenter)
  * Swift (Swift Package Index, CocoaPods)
* Containers and VM support:
  * App Container Image (appc) used by rkt
  * Flatpak
  * Linux Containers (LXC) used by Incus
  * OVA/OVF: Open standard for virtual appliance packaging.
  * Open Container Initiative (OCI) used by Docker, Podman
  * QCOW2: Common with QEMU and KVM, supports advanced features.
  * Singularity (now Apptainer)
  * Snap
  * Systemd-nspawn
  * VDI: VirtualBox’s native format, convertible to other formats.
  * VHD/VHDX: Microsoft’s formats, used in Hyper-V and Azure.
  * VMDK: VMware’s format, also used in other hypervisors like VirtualBox.
* Software scanning tools:
  * Anchore Grype: https://github.com/anchore/grype
  * Clair: https://github.com/quay/clair
  * CycloneDX: https://github.com/CycloneDX/cyclonedx-cli
  * FOSSA CLI: https://github.com/fossas/fossa-cli
  * OWASP Dependency-Check: https://owasp.org/www-project-dependency-check/
  * Safety: https://github.com/pyupio/safety
  * ScanCode Toolkit: https://github.com/nexB/scancode-toolkit
  * Snyk: https://snyk.io
  * Trivy: https://github.com/aquasecurity/trivy
  * VulnDB: https://github.com/vulndb/data
* SBOM generation tools (possible integrations):
  * BOM: https://github.com/kubernetes-sigs/bom
  * CycloneDX Generator: https://github.com/CycloneDX/cdxgen
  * DISTRO2SBOM: https://github.com/anthonyharrison/distro2sbom
  * Jake: https://github.com/sonatype-nexus-community/jake
  * Retire.js: https://github.com/RetireJS/retire.js
  * SPDX SBOM Generator: https://github.com/opensbom-generator/spdx-sbom-generator
  * Syft: https://github.com/anchore/syft
  * Tern: https://github.com/tern-tools/tern
  * The SBOM Tool: https://github.com/microsoft/sbom-tool
  * rebar3_sbom: https://github.com/voltone/rebar3_sbom
  * sbom-rs: https://github.com/psastras/sbom-rs
  
## Use cases

Example use cases

* CI/CD integrated gate keeper (e.g. with GitHub)
* Run on project and get results
* Give feedback on specific package(s)
* Help select/find packages for a specific purpose (e.g. PDF reader)

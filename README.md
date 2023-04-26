# ATTENTION
This repo has been archived. For updated versions, please visit https://github.com/advanced-security/sample-codeql-pipeline-config

# Sample pipeline files for popular CI/CD systems
This repository contains pipeline files for various CI/CD systems, illustrating how to integrate the CodeQL CLI Bundle for Automated Code Scanning.

Currently, the CI/CD systems covered here are Jenkins, Azure Pipelines, CircleCI and TravisCI.

For each CI/CD system, a template is provided for both the Windows and Linux operating systems. Included are both examples for simply builds using the AutoBuilder or analysis of interpreted languages, as well as an advanced example levering indirect build tracing ("sandwich mode") wrapped around potentially complex build commands.

# NOTE
The CodeQL Runner has been deprecated as of version 2.6.2 of the CodeQL CLI. All functionality is now natively available in the CodeQL CLI. Please use the CodeQL CLI Bundle instead of the CodeQL Runner.
The legacy template files for the CodeQL Runner can be found in the `_deprecated` folder

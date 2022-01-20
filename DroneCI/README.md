# Drone CI

To get CodeQL to work with Drone, you need to have a Docker image of the CodeQL Bundle installed into the image along with all your required build tools (dotnet, java, python, etc.).

## Requirements

- [CodeQL Bundle](https://github.com/github/codeql-action/releases)
- [GitHub PAT to push results back to GitHub Advanced Security](https://docs.github.com/en/code-security/code-scanning/using-codeql-code-scanning-with-your-existing-ci-system/configuring-codeql-cli-in-your-ci-system#uploading-results-to-github)

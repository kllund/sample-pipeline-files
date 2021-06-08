#!/bin/bash
set -vx
GITHUB_REPOSITORY="jfrog-xray-webhook-pcf"
# install Codeql
PWD_PATH=`pwd`
GITHUB_TOKEN=${bamboo.secret.github.token}
wget -q https://github.com/github/codeql-action/releases/latest/download/codeql-bundle-linux64.tar.gz
tar -xzf codeql-bundle-linux64.tar.gz
echo "PWD is now: $PWD_PATH"
# Defining tmp dirs
CODEQL_DB_PATH=$PWD_PATH/codeql/db
CODEQL_RESULTS_PATH="$PWD_PATH/codeql/results"
export PATH=$PATH:$PWD_PATH/codeql
# Dynamically find the ref / branch to use
if [[ -z "$GITHUB_REF" ]]; then
    GIT_REF="$GITHUB_REF"
else
    # Assumes that this is scanning a branch, not a Pull Request
    #   https://docs.github.com/en/code-security/secure-coding/configuring-codeql-code-scanning-in-your-ci-system#scanning-pull-requests
    GIT_REF="refs/heads/$(git branch --show-current)"
fi
# Git SHA hash for tracking in GitHub Code Scanning
GIT_HASH=$(git rev-parse HEAD)
# Just a placeholder for the name of the database + results file(s)
PROJECT_NAME="$GITHUB_REPOSITORY"
# CodeQL Database name for this analysis
CODEQL_DATABASE="$CODEQL_DB_PATH/$PROJECT_NAME"
# Using the CLI, there isn't language detection like the Runner
CODEQL_LANGUAGE="java"
# Setting which query suites are run automatically
#   https://codeql.github.com/docs/codeql-cli/using-custom-queries-with-the-codeql-cli/
#   https://codeql.github.com/docs/codeql-cli/creating-codeql-query-suites/
CODEQL_SUITE="$CODEQL_LANGUAGE-code-scanning.qls"
# Make sure all the dirs are created
mkdir -p $CODEQL_DB_PATH
mkdir -p $CODEQL_RESULTS_PATH
echo "[+] CodeQL DB Dir             :: $CODEQL_DB_PATH"
echo "[+] CodeQL Database Location  :: $CODEQL_DATABASE"
echo "[+] CodeQL Results Location   :: $CODEQL_RESULTS_PATH"
# Creating CodeQL Database
#   https://codeql.github.com/docs/codeql-cli/creating-codeql-databases/
codeql database create \
  --language="$CODEQL_LANGUAGE" \
  $CODEQL_DATABASE \
  --command='mvn clean test'
# Upgrade the CodeQL Database (if needed)
#   https://codeql.github.com/docs/codeql-cli/upgrading-codeql-databases/
codeql database upgrade $CODEQL_DATABASE
# CodeQL runs the analysis on the Database
#   https://codeql.github.com/docs/codeql-cli/analyzing-databases-with-the-codeql-cli/
SARIF_PATH="$CODEQL_RESULTS_PATH/$PROJECT_NAME-$CODEQL_LANGUAGE.sarif"
codeql database analyze \
  --format="sarif-latest" \
  --output="$SARIF_PATH" \
  $CODEQL_DATABASE \
  $CODEQL_SUITE
# Upload SARIF
#   https://github.blog/changelog/2021-03-12-codeql-code-scanning-improvements-for-users-analyzing-codebases-on-3rd-party-ci-cd-systems/
# - Uses $GITHUB_TOKEN by default for access token
codeql github upload-results \
    -r "$GITHUB_REPOSITORY" \
    -f "$GIT_REF" \
    -c "$GIT_HASH" \
    -s "$SARIF_PATH" \
    -a "$GITHUB_TOKEN"
echo "[+] CodeQL Finished"

#!/usr/bin/env bash
set -e
# Shell script to update npm in the source tree to a specific version 

BASE_DIR="$( pwd )"/ 
DEPS_DIR="$BASE_DIR"deps/ 
NPM_VERSION=$1

if [ "$#" -le 0 ]; then
  echo "Error: please provide an npm version to update to"
  exit 1
fi

echo "Cloning CLI repo"
echo "$NPM_VERSION"
gh repo clone npm/cli

echo "Prepping CLI repo for release"
cd cli
git checkout v"$NPM_VERSION"
make
make release


echo "Removing old npm"
cd "$DEPS_DIR"
rm -rf npm/

echo "Copying new npm"
tar zxf "$BASE_DIR"cli/release/npm-"$NPM_VERSION".tgz

echo "Removing CLI workspace"
cd "$BASE_DIR"
rm -rf cli

git add -A deps/npm
git commit -m "deps: upgrade npm to $NPM_VERSION"
git rebase --whitespace=fix HEAD^

# echo ""
# echo "All done!"
# echo ""
# echo "Please git add npm, commit the new version, and whitespace-fix:"
# echo ""
# echo "$ git add -A deps/npm"
# echo "$ git commit -m \"deps: upgrade npm to $NPM_VERSION\""
# echo "$ git rebase --whitespace=fix master"
# echo ""

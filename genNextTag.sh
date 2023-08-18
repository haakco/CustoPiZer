#!/usr/bin/env bash
RE='[^0-9]*\([0-9]*\)[.]\([0-9]*\)[.]\([0-9]*\)\([0-9A-Za-z-]*\)'
export RE
CURRENT_MAX_VERSION=$(git tag | grep -E '^v[0-9.]+$' | sed -E -e 's/^v//' | sort -Vr | head -n 1)
export CURRENT_MAX_VERSION
# shellcheck disable=SC2001
MAJOR=$(echo "$CURRENT_MAX_VERSION" | sed -e "s#$RE#\1#")
export MAJOR
# shellcheck disable=SC2001
MINOR=$(echo "$CURRENT_MAX_VERSION" | sed -e "s#$RE#\2#")
export MINOR
# shellcheck disable=SC2001
PATCH=$(echo "$CURRENT_MAX_VERSION" | sed -e "s#$RE#\3#")

((PATCH+=1))
export PATCH

NEW_VERSION="$MAJOR.$MINOR.$PATCH"
export NEW_VERSION

NEW_VERSION_PREFIX="v$MAJOR.$MINOR.$PATCH"
export NEW_VERSION_PREFIX

echo "Pushing tags to make sure its clean"
echo ""
git pull --all
git fetch --tags
git push --all
git push --tags

echo ""
echo "Current Version"
echo ""
echo "${CURRENT_MAX_VERSION}"
echo ""
echo "Matches"
git tag | grep "$CURRENT_MAX_VERSION"
echo ""
echo "Setting the following tags"
echo ""
echo "${NEW_VERSION_PREFIX}"
git tag "${NEW_VERSION_PREFIX}"
git push --tags
echo ""
echo "Generating github release"
echo ""
gh release create "${NEW_VERSION_PREFIX}" --generate-notes
echo ""
echo "Done"

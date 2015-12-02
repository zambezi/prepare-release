#!/usr/bin/env bash
set -e

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

pushd ${DIR} > /dev/null
PATH=$(npm bin):${PATH}
popd > /dev/null

usage() {
cat <<USAGE
Usage: prepare-release <level> [-m|--message <message>]

<level>

    Defines the semver level to use when incrementing the version.
    Level can be one of: major, minor, patch, premajor, preminor,
    prepatch, or prerelease. Default level is 'prerelease'.

    When using any of the 'pre-' levels, the current branch name
    will be included in the version number, to clearly indicate
    the version.

[-m|--message <message>]

    Optional message to use for the version commit. If the message
    contains %s it will be replaced with the resulting version.


Preparing a release can only be done in a clean working directory,
and will fail if the working directory is dirty. Files not being
tracked will also cause the release process to fail.

Preparing a release will also fail if the HEAD on the current
branch is also a release commit, in order to avoid duplicates.
USAGE
exit 0
}

error() {
  echo "error: $@" >&2
  exit 1
}

level="${1:-prerelease}"

case "${level}" in
  "major"     | \
  "minor"     | \
  "patch"     )
    ;;

  "premajor"  | \
  "preminor"  | \
  "prepatch"  | \
  "prerelease")
    pre="$(git rev-parse --abbrev-ref HEAD)"
    ;;

  "help" | "--help")
    usage;;

  *)
    error "invalid level '${1}'";;
esac

case "${2}" in
  "-m" | "--message")
    [[ -z "${@:3}" ]] && error "aborting due to empty commit message";;
  *)
    [[ -n "${2}" ]] && error "invalid option '${@:2}'";;
esac

if [[ -n $(git status --porcelain) ]]; then
  error "aborting due to dirty working directory"
fi

curr="v$(npm-inspect version)"

if [[ "${curr}" == $(git describe --exact-match head 2>/dev/null) ]]; then
  error "aborting due to current commit being a release"
fi

PATH="$(npm bin):${PATH}"

next=$(semver -i ${level} ${curr} --preid ${pre})

npm version ${next} ${@:2}
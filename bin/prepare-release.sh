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
Usage: prepare-release [--dry] <level> [-m|--message <message>]

[--dry]

    Perform a dry-run instead of committing a new version. Useful
    when checking to see that the given options will have the
    intended effect.

<level>

    Defines the semver level to use when incrementing the version.
    Level can be one of: master, major, minor, patch, premajor,
    preminor, prepatch, or prerelease.

    Default level is 'prerelease'.

    When using any of the 'pre-' levels, the current branch name
    will be included in the version number, to clearly indicate
    the pre-release nature of the new version.

    The level 'master' is special, and should only be used when
    transitioning from a 'pre-' level version. E.g. when moving
    from 'v1.0.0-rc.0' to 'v1.0.0' then 'master' should be used.
    The semantics of this is to say the only difference from the
    previous 'pre-' level version is the lack of a 'pre-' label.
    
    The 'master' level will have no effect if the current version
    is *not* a 'pre-' level version; and the program will exit
    with a non-zero exit code.

[-m|--message <message>]

    Optional message to use for the version commit. If the message
    contains %s it will be replaced with the resulting version.


Preparing a release can only be done in a clean working directory,
and will fail if the working directory is dirty. Files not being
tracked will also cause the release process to fail.

Preparing a release will also fail if the HEAD on the current
branch is also a release commit, in order to avoid duplicates.
The only exception to this rule is when transitioning from a
'pre-' level version to a 'master' level version.
USAGE
exit 0
}

error() {
  echo "error: $@" >&2
  exit 1
}

if [[ "${1}" == "--dry" ]]; then
  dry=1
  shift
fi

level="${1:-prerelease}"

case "${level}" in
  "master"    | \
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
    [[ -z "${@:3}" ]] && error "empty commit message";;
  *)
    [[ -n "${2}" ]] && error "invalid option '${@:2}'";;
esac

if [[ -n $(git status --porcelain) ]]; then
  error "dirty working directory"
fi

curr="v$(npm-inspect version)"

PATH="$(npm bin):${PATH}"

if [[ "${level}" == "master" ]]; then
  next=$(npm-inspect version | sed s/-.*//)
else
  next=$(semver -i ${level} ${curr} --preid ${pre})

  if [[ "${curr}" == $(git describe --exact-match head 2>/dev/null) ]]; then
    error "current commit is a release"
  fi
fi

if [[ "${curr}" == "v${next}" ]]; then
  error "no change"
elif [[ "${dry}" == 1 ]]; then
  echo "npm version ${next} ${@:2}"
else
  npm version ${next} ${@:2}
fi
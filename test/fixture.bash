#!/usr/bin/env bash

setup() {
  PATH="$(npm bin):${PATH}"
  alias prepare-release="${BATS_TEST_DIRNAME}/../bin/prepare-release.sh"
  repo="${BATS_TMPDIR}/project"
  cp -R "${BATS_TEST_DIRNAME}/project" "${repo}"
  
  pushd "${repo}"
  git init
  git add -A .
  git commit -m "Initial commit."
}

teardown() {
  popd
  rm -rf "${repo}"
}

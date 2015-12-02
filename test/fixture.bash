#!/usr/bin/env bash

setup() {
  PATH="${BATS_TEST_DIRNAME}/../bin:$(npm bin):${PATH}"
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

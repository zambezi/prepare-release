#!/usr/bin/env bats

load fixture

@test "should fail when there are changed files" {
  run echo "something" > file.txt
  run prepare-release.sh major
  [[ "${status}" -eq 1 ]]
  [[ "${output}" == "error: dirty working directory" ]]
}

@test "should fail when there are untracked files" {
  run touch me
  run prepare-release.sh major
  [[ "${status}" -eq 1 ]]
  [[ "${output}" == "error: dirty working directory" ]]
}

@test "should fail when given an invalid level" {
  run prepare-release.sh nope
  [[ "${status}" -eq 1 ]]
  [[ "${output}" == "error: invalid level 'nope'" ]]
}

@test "should fail when given a message but no level" {
  run prepare-release.sh -m foo
  [[ "${status}" -eq 1 ]]
  [[ "${output}" == "error: invalid level '-m'" ]]

  run prepare-release.sh --message foo
  [[ "${status}" -eq 1 ]]
  [[ "${output}" == "error: invalid level '--message'" ]]
}

@test "should fail when given an empty message" {
  run prepare-release.sh major -m ""
  [[ "${status}" -eq 1 ]]
  [[ "${output}" == "error: empty commit message" ]]

  run prepare-release.sh major --message ""
  [[ "${status}" -eq 1 ]]
  [[ "${output}" == "error: empty commit message" ]]
}

@test "should fail when last commit already is a release" {
  run prepare-release.sh major
  [[ "${status}" -eq 0 ]]
  [[ "${output}" == "v1.0.0" ]]

  run prepare-release.sh major
  [[ "${status}" -eq 1 ]]
  [[ "${output}" == "error: current commit is a release" ]]
}

@test "should fail when level is 'master' and current version is not a 'pre-' level" {
  run prepare-release.sh major
  [[ "${status}" -eq 0 ]]
  [[ "${output}" == "v1.0.0" ]]
  [[  $(npm-inspect version) == "1.0.0" ]]

  run prepare-release.sh master
  echo "${output}" 1>&2
  [[ "${status}" -eq 1 ]]
  [[ "${output}" == "error: no change" ]]
}
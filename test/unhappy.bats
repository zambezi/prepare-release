#!/usr/bin/env bats

load fixture

@test "should fail when there are changed files" {
  run echo "something" > file.txt
  run prepare-release major
  [[ "$status" -eq 1 ]]
  [[ "$output" == "error: aborting due to dirty working directory" ]]
}

@test "should fail when there are untracked files" {
  run touch me
  run prepare-release major
  [[ "$status" -eq 1 ]]
  [[ "$output" == "error: aborting due to dirty working directory" ]]
}

@test "should fail when given an invalid level" {
  run prepare-release nope
  [[ "$status" -eq 1 ]]
  [[ "$output" == "error: invalid level 'nope'" ]]
}

@test "should fail when given a message but no level" {
  run prepare-release -m foo
  [[ "$status" -eq 1 ]]
  [[ "$output" == "error: invalid level '-m'" ]]

  run prepare-release --message foo
  [[ "$status" -eq 1 ]]
  [[ "$output" == "error: invalid level '--message'" ]]
}

@test "should fail when given an empty message" {
  run prepare-release major -m ""
  [[ "$status" -eq 1 ]]
  [[ "$output" == "error: aborting due to empty commit message" ]]

  run prepare-release major --message ""
  [[ "$status" -eq 1 ]]
  [[ "$output" == "error: aborting due to empty commit message" ]]
}

@test "should fail when last commit already is a release" {
  run prepare-release major
  [[ "$status" -eq 0 ]]
  [[ "${output}" == "v1.0.0" ]]

  run prepare-release major
  [[ "$status" -eq 1 ]]
  [[ "${output}" == "error: aborting due to current commit being a release" ]]
}
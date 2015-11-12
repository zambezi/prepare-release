#!/usr/bin/env bats

load fixture

@test "should prepare a major release" {
  run prepare-release major
  [[ "$status" -eq 0 ]]
  [[ "${output}" == "v1.0.0" ]]
  [[  $(npm-inspect version) == "1.0.0" ]]
}

@test "should prepare a minor release" {
  run prepare-release minor
  [[ "$status" -eq 0 ]]
  [[ "${output}" == "v0.1.0" ]]
  [[  $(npm-inspect version) == "0.1.0" ]]
}

@test "should prepare a patch release" {
  run prepare-release patch
  [[ "$status" -eq 0 ]]
  [[ "${output}" == "v0.0.1" ]]
  [[  $(npm-inspect version) == "0.0.1" ]]
}

@test "should prepare a major pre-release" {
  run prepare-release premajor
  [[ "$status" -eq 0 ]]
  [[ "${output}" == "v1.0.0-master.0" ]]
  [[  $(npm-inspect version) == "1.0.0-master.0" ]]
}

@test "should prepare a minor pre-release" {
  run prepare-release preminor
  [[ "$status" -eq 0 ]]
  [[ "${output}" == "v0.1.0-master.0" ]]
  [[  $(npm-inspect version) == "0.1.0-master.0" ]]
}

@test "should prepare a patch pre-release" {
  run prepare-release prepatch
  [[ "$status" -eq 0 ]]
  [[ "${output}" == "v0.0.1-master.0" ]]
  [[  $(npm-inspect version) == "0.0.1-master.0" ]]
}

@test "should prepare a pre-release" {
  run prepare-release prerelease
  [[ "$status" -eq 0 ]]
  [[ "${output}" == "v0.0.1-master.0" ]]
  [[  $(npm-inspect version) == "0.0.1-master.0" ]]
}
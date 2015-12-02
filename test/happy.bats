#!/usr/bin/env bats

load fixture

@test "should prepare a major release" {
  run prepare-release.sh major
  [[ "${status}" -eq 0 ]]
  [[ "${output}" == "v1.0.0" ]]
  [[  $(npm-inspect version) == "1.0.0" ]]
}

@test "should prepare a minor release" {
  run prepare-release.sh minor
  [[ "${status}" -eq 0 ]]
  [[ "${output}" == "v0.1.0" ]]
  [[  $(npm-inspect version) == "0.1.0" ]]
}

@test "should prepare a patch release" {
  run prepare-release.sh patch
  [[ "${status}" -eq 0 ]]
  [[ "${output}" == "v0.0.1" ]]
  [[  $(npm-inspect version) == "0.0.1" ]]
}

@test "should prepare a major pre-release" {
  run prepare-release.sh premajor
  [[ "${status}" -eq 0 ]]
  [[ "${output}" == "v1.0.0-master.0" ]]
  [[  $(npm-inspect version) == "1.0.0-master.0" ]]
}

@test "should prepare a minor pre-release" {
  run prepare-release.sh preminor
  [[ "${status}" -eq 0 ]]
  [[ "${output}" == "v0.1.0-master.0" ]]
  [[  $(npm-inspect version) == "0.1.0-master.0" ]]
}

@test "should prepare a patch pre-release" {
  run prepare-release.sh prepatch
  [[ "${status}" -eq 0 ]]
  [[ "${output}" == "v0.0.1-master.0" ]]
  [[  $(npm-inspect version) == "0.0.1-master.0" ]]
}

@test "should prepare a pre-release" {
  run prepare-release.sh prerelease
  [[ "${status}" -eq 0 ]]
  [[ "${output}" == "v0.0.1-master.0" ]]
  [[  $(npm-inspect version) == "0.0.1-master.0" ]]
}

@test "should prepare a master release" {
  run prepare-release.sh prerelease
  [[ "${status}" -eq 0 ]]
  [[ "${output}" == "v0.0.1-master.0" ]]
  [[  $(npm-inspect version) == "0.0.1-master.0" ]]

  run prepare-release.sh master
  [[ "${status}" -eq 0 ]]
  [[ "${output}" == "v0.0.1" ]]
  [[  $(npm-inspect version) == "0.0.1" ]]
}

@test "should do a dry-run when --dry is present" {
  [[  $(npm-inspect version) == "0.0.0" ]]
  run prepare-release.sh --dry major
  [[ "${status}" -eq 0 ]]
  [[  $(npm-inspect version) == "0.0.0" ]]
}
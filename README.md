prepare-release
===============

Preparing releases can be a chore, and prone to error. This utility helps you prepare a project for release to npm, by setting the correct version according to input or convention, and making sure everything is tagged properly.

Installation
------------

If used locally, for instance in project scripts, it is recommended you install `prepare-release` as a local developer dependency:

```bash
npm install --save-dev @zambezi/prepare-release
```

It's also possible to install this tool globally:

```bash
npm install --save-dev @zambezi/prepare-release
```

Usage
-----

```bash
prepare-release [--dry] [-f|--force] <level> [-m|--message <message>]
```

## `[--dry]`

Perform a dry-run instead of committing a new version. Useful
when checking to see that the given options will have the
intended effect.

## `[-f|--force]`

Ignore the previous commit when preparing a release. This is
useful when going from a pre-release version to an untagged
version.

## `<level>`

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

## `[-m|--message <message>]`

Optional message to use for the version commit. If the message
contains %s it will be replaced with the resulting version.


Preparing a release can only be done in a clean working directory,
and will fail if the working directory is dirty. Files not being
tracked will also cause the release process to fail.

Preparing a release will also fail if the HEAD on the current
branch is also a release commit, in order to avoid duplicates.
The only exception to this rule is when transitioning from a
'pre-' level version to a 'master' level version.

Found an issue, or want to contribute?
--------------------------------------

If you find an issue, want to start a discussion on something related to this project, or have suggestions on how to improve it? Please [create an issue](../../issues/new)!

See an error and want to fix it? Want to add a file or otherwise make some changes? All contributions are welcome! Please refer to the [contribution guidelines](CONTRIBUTING.md) for more information.

License
-------

Please refer to the [license](LICENSE.md) for more information on licensing and copyright information.
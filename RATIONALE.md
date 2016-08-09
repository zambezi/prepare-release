prepare-release
===============

Preparing releases can be a chore, and prone to error. This utility helps you prepare a project for release to npm, by setting the correct version according to input or convention, and making sure everything is tagged properly.

This tool is specifically geared to producing releases for npm, meaning its primary target is `package.json`. It otherwise doesn't make any assumptions about the project, but tries to be as agnostic as possible.

Another goal of this tool is to play well with CI systems and other automation tools.
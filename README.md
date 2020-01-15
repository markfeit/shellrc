# ShellRC

TODO: Write this.


# Prerequisites

This works on a system with the following:

 * A POSIX shell and command-line utilities
 * GNU Make
 * Git


## Setup

Create a Git repository to hold the new set of snippets.  This can be
local or on GitHub.  In either case, make sure a copy of the new
repository is cloned and you're in it.

`git submodule add -b master https://github.com/markfeit/shellrc`

For any additional Git modules containing snippets that you want to be
part of this installation:
 * `git submodule add -b master GIT-REPO_URL`

`git submodule update --remote --recursive`

`ln -s shellrc/Makefile .`

**NOTE: This last step will overwrite your shell RC FILES.  Preserve a
  copy first.**

`make install`

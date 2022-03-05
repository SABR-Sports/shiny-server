#!/usr/bin/env bash

set -e
set -x

# This is needed for CentOS5/6 Jenkins workers to bootstrap a newer gcc toolchain.
cd "$(dirname $0)"

# Repo checkout directories are re-used by Jenkins workers, and so a
# $PROJECT_DIR/packaging/build/CMakeCache.txt might be hanging around from a
# previous build. This cache file is platform-specific, and the build that
# generated it may have been on a different platform. In order to build reliably
# we must first blow it and any other files not in the repo away.
git reset --hard && git clean -ffdx

if (which scl && scl -l | grep -q devtoolset-11);
then
	scl enable devtoolset-11 ./make-package.sh
else
	CC=gcc CXX=g++ ./make-package.sh "$@"
fi

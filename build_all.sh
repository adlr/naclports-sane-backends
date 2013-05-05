#!/bin/sh
# Copyright (c) 2012 The Native Client Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.
#
# This script builds all naclports in all possible configurations.
# If you want to be sure your change won't break anythign this is
# a good place to start.

set -x
set -e

TARGETS="libraries/sane-backends"
TARGETS=${TARGETS:-all}

export NACL_SDK_ROOT=$(readlink -f /home/adlr/nacl_sdk/pepper_26)

# x86_64 NaCl
export NACL_ARCH=x86_64
make ${TARGETS}

# i686 NaCl
#export NACL_ARCH=i686
#make ${TARGETS}

# ARM NaCl
#export NACL_ARCH=arm
#make ${TARGETS}

# PNaCl
#export NACL_ARCH=pnacl
#make ${TARGETS}

for arch in i686 x86_64 arm ; do
  outarch=${arch}
  if [ "$arch" = "i686" ]; then
    outarch="x86_32"
  fi
  cp out/repository-${arch}/sane-backends-1.0.23/build-nacl/adlrsane.nexe ~/Downloads/scanley/hello_tutorial_${outarch}.nexe
done

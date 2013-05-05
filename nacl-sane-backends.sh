#!/bin/bash
# Copyright (c) 2011 The Native Client Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.
#

# nacl-zlib-1.2.3.sh
#
# usage:  nacl-zlib-1.2.3.sh
#
# this script downloads, patches, and builds zlib for Native Client 
#

# NACL_SDK_ROOT=$(readlink -f /home/adlr/nacl_sdk/pepper_26) make libraries/sane-backends 2>&1 | tee log.txt


NACLPORTS_CFLAGS="-O0"

source pkg_info
source ../../build_tools/common.sh

CustomExtractStep() {
  Banner "Copying source from git repo"
  ChangeDir ${NACL_PACKAGES_REPOSITORY}
  Remove ${PACKAGE_DIR}
  cp -Rp /home/adlr/sane-backends ${PACKAGE_DIR}
}

CustomConfigureStep() {
  BACKENDS="plustek" CXXFLAGS="-O0 -g" CFLAGS="-I${NACL_SDK_ROOT}/include" DefaultConfigureStep --disable-ipv6 --enable-latex=no --enable-avahi=no --enable-static=yes --enable-shared=no --enable-pthread
  #Banner "Configuring ${PACKAGE_NAME}"
  #ChangeDir ${NACL_PACKAGES_REPOSITORY}/${PACKAGE_NAME}
  ## TODO: side-by-side install
  #CC=${NACLCC} AR="${NACLAR} -r" RANLIB=${NACLRANLIB} CFLAGS="-Dunlink=puts" ./configure\
  #   --prefix=${NACLPORTS_PREFIX} --disable-ipv6 --disable-preload --disable-latex --host=${NACL_CROSS_PREFIX}
  #echo "#define HAVE_SIGPROCMASK 1" >> include/sane/config.h
}


CustomBuildStep() {
  make clean
  cd backend && make -j${OS_JOBS} .libs/libsane.so.1.0.24
  #DefaultBuildStep
}

CustomPackageInstall() {
  DefaultPreInstallStep
  #DefaultDownloadStep
  #DefaultExtractStep
  CustomExtractStep
  # zlib doesn't need patching, so no patch step
  CustomConfigureStep
  #CustomBuildStep
  DefaultBuildStep

  echo ${NACLCXX} -g -O0 -o adlrsane.nexe ../nacl_main.cc -I${NACL_SDK_ROOT}/include -I../include backend/.libs/libsane.a sanei/.libs/libsanei.a lib/.libs/liblib.a lib/.libs/libfelib.a -lppapi_cpp -lppapi
  ${NACLCXX} -g -O0 -o adlrsane.nexe ../nacl_main.cc -I${NACL_SDK_ROOT}/include -I../include backend/.libs/libsane.a sanei/.libs/libsanei.a lib/.libs/liblib.a lib/.libs/libfelib.a -lppapi_cpp -lppapi
  #echo ${NACLCXX} -g -O0 -o adlrsane.nexe ../nacl_main.cc -I${NACL_SDK_ROOT}/include `find . -type f | grep \\\\.a\\$  | xargs -n 1 dirname | uniq | xargs -I X echo -LX` `find . -type f | grep \\\\.a\\$ | xargs -n 1 basename | sed 's/^lib\\(.*\\)\\.a/-l\\1/g'` `find . -type f | grep \\\\.a\\$ | xargs -n 1 basename | sed 's/^lib\\(.*\\)\\.a/-l\\1/g'` -lppapi_cpp -lppapi
  #${NACLCXX} -g -O0 -o adlrsane.nexe ../nacl_main.cc -I${NACL_SDK_ROOT}/include `find . -type f | grep \\\\.a\\$  | xargs -n 1 dirname | uniq | xargs -I X echo -LX` `find . -type f | grep \\\\.a\\$ | xargs -n 1 basename | sed 's/^lib\\(.*\\)\\.a/-l\\1/g'` `find . -type f | grep \\\\.a\\$ | xargs -n 1 basename | sed 's/^lib\\(.*\\)\\.a/-l\\1/g'` -lppapi_cpp -lppapi

  DefaultInstallStep
  DefaultCleanUpStep
}


CustomPackageInstall
#DefaultPackageInstall
exit 0

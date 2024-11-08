#!/bin/sh

cwd=$(pwd)

if test "x${CONTAINER}" != "x"; then
    yum install -y flex bison gperf autoconf wget
fi

if test "x${TARGET}" = "x"; then
    TARGET=linux
fi

systemc_version=2.3.4
systemc_tgz=${cwd}/${systemc_version}.tar.gz
systemc_dir=${cwd}/systemc-${systemc_version}

if test ! -f ${systemc_tgz}; then
#    wget https://github.com/accellera-official/systemc/archive/refs/tags/3.0.1.tar.gz
    wget https://github.com/accellera-official/systemc/archive/refs/tags/2.3.4.tar.gz
    if test $? -ne 0; then exit 1; fi
fi

if test -d ${systemc_dir}; then
    rm -rf ${systemc_dir}
fi

tar xvf ${systemc_tgz}
if test $? -ne 0; then exit 1; fi

cd ${systemc_dir}

# Patch...
touch docs/DEVELOPMENT.md

#autoconf
#if test $? -ne 0; then exit 1; fi

mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${cwd}/systemc-${TARGET}-${systemc_version}
if test $? -ne 0; then exit 1; fi

make -j$(nproc)
if test $? -ne 0; then exit 1; fi

make install
if test $? -ne 0; then exit 1; fi

cd ${cwd}

tar czf systemc-${TARGET}-${systemc_version}.tar.gz systemc-${TARGET}-${systemc_version}
if test $? -ne 0; then exit 1; fi

pwd
ls
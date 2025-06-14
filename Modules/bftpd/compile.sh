#!/usr/bin/env bash

set -e # fail out if any step fails

. ../../setCompilePath.sh

if [ ! -d bftpd ]
then
  wget https://downloads.sourceforge.net/project/bftpd/bftpd/bftpd-5.4/bftpd-5.4.tar.gz
  tar xvfz bftpd-5.4.tar.gz
  rm bftpd-5.4.tar.gz
cat << EOF > bftpd/mypaths.h
#define PATH_BFTPD_CONF "/system/sdcard/config/bftpd.conf"
#ifdef PREFIX
#define PATH_BFTPD_CONF_WITH_PREFIX PREFIX"/system/dafang/bftpd.conf"
#endif
#define PATH_STATUSLOG "/dev/null"
EOF
fi

cd bftpd
./configure --host=mips-linux --enable-debug --prefix=${INSTALLDIR}
make clean
sed -i "s/LIBS= -lcrypt/LIBS=\${TOOLCHAIN}\/..\/mips-linux-gnu\/libc\/uclibc\/usr\/lib\/libcrypt.a -muclibc/" Makefile
make
cp bftpd ${INSTALLDIR}/bin

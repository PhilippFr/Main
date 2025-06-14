#!/usr/bin/env bash

set -e # fail out if any step fails

. ../../setCompilePath.sh

SSLPATH=${INSTALLDIR}
PCREPATH=${INSTALLDIR}

if [ ! -d lighttpd1.4/.git ]
then
   git clone https://github.com/lighttpd/lighttpd1.4.git
fi

cd lighttpd1.4/
./autogen.sh

export PCRECONFIG=$PCREPATH/bin/pcre-config 
export PCRE_LIB=$PCREPATH/lib/libpcre.a 
export CFLAGS="$CFLAGS -DHAVE_PCRE_H=1 -DHAVE_LIBPCRE=1 -I$PCREPATH/include"
export CPPLAGS="$CFLAGS -DHAVE_PCRE_H=1 -DHAVE_LIBPCRE=1 -I$PCREPATH/include"
 
LIGHTTPD_STATIC=yes CPPFLAGS=-DLIGHTTPD_STATIC ./configure --prefix=${PWD}/_install --host=mips-linux-gnu --without-mysql --without-zlib --without-bzip2 --disable-ipv6 --enable-static --disable-shared  --with-openssl --with-openssl -with-openssl-includes=$SSLPATH/include --with-openssl-libs=$SSLPATH/lib --with-pcre

echo "PLUGIN_INIT(mod_alias)" > src/plugin-static.h
echo "PLUGIN_INIT(mod_auth)" >> src/plugin-static.h
echo "PLUGIN_INIT(mod_redirect)" >> src/plugin-static.h 
echo "PLUGIN_INIT(mod_rewrite)" >> src/plugin-static.h
echo "PLUGIN_INIT(mod_cgi)" >> src/plugin-static.h
echo "PLUGIN_INIT(mod_fastcgi)" >> src/plugin-static.h
echo "PLUGIN_INIT(mod_scgi)" >> src/plugin-static.h
echo "PLUGIN_INIT(mod_ssi)" >> src/plugin-static.h
echo "PLUGIN_INIT(mod_proxy)" >> src/plugin-static.h
echo "PLUGIN_INIT(mod_indexfile)" >> src/plugin-static.h
echo "PLUGIN_INIT(mod_dirlisting)" >> src/plugin-static.h
echo "PLUGIN_INIT(mod_staticfile)" >> src/plugin-static.h
echo "PLUGIN_INIT(mod_authn_file)" >> src/plugin-static.h
echo "PLUGIN_INIT(mod_accesslog)" >> src/plugin-static.h
echo "PLUGIN_INIT(mod_openssl)" >> src/plugin-static.h
echo "PLUGIN_INIT(mod_setenv)" >> src/plugin-static.h
echo "PLUGIN_INIT(mod_access)" >> src/plugin-static.h
echo "PLUGIN_INIT(mod_deflate)" >> src/plugin-static.h
# echo "PLUGIN_INIT(mod_evasive)" >> src/plugin-static.h 
echo "PLUGIN_INIT(mod_expire)" >> src/plugin-static.h
echo "PLUGIN_INIT(mod_extforward)" >> src/plugin-static.h
echo "PLUGIN_INIT(mod_simple_vhost)" >> src/plugin-static.h
echo "PLUGIN_INIT(mod_status)" >> src/plugin-static.h
echo "PLUGIN_INIT(mod_userdir)" >> src/plugin-static.h
# echo "PLUGIN_INIT(mod_uploadprogress)" >> src/plugin-static.h
# echo "PLUGIN_INIT(mod_usertrack)" >> src/plugin-static.h
echo "PLUGIN_INIT(mod_vhostdb)" >> src/plugin-static.h

make -j4
cp src/lighttpd ${INSTALLDIR}/bin/lighttpd.bin

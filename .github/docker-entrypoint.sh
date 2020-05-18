#!/bin/sh

set -x

apk add make gcc build-base linux-headers

wget https://github.com/zerotier/ZeroTierOne/archive/1.4.6.tar.gz -o zerotier.tar.gz

tar zxvf zerotier.tar.gz

rm zerotier.tar.gz

cd ZeroTierOne-1.4.6/

sed -i -e 's/-march=armv5//g' make-linux.mk

make SHARED=0 CC='gcc -static' CXX='g++ -static -march=armv6'

tar -czvf zerotier-one-armv6.tar.gz zerotier-one

(cd ..; mkdir deploy)

mv zerotier-one-armv6.tar.gz ../deploy/zerotier-one-armv6.tar.gz

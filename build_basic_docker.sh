#!/usr/bin/env bash

# build_basic_docker_from_tlinux2.4
# yum -y update

# install git
yum -y install zlib zlib-devel curl gcc curl-devel expect make wget gettext zip unzip \
    && yum -y install git \
    && git config --global user.email "anonymous" \
    && git config --global user.name "anonymous" \
    && git config --global http.postBuffer 524288000

# install git-lfs
yum -y install git-lfs \
    && git lfs install

# install python3
yum -y install python3 python3-devel

# install gcc10
wget -c http://ftp.gnu.org/gnu/gcc/gcc-10.1.0/gcc-10.1.0.tar.gz
tar -xzvf gcc-10.1.0.tar.gz
cd gcc-10.1.0

# 下载依赖包
./contrib/download_prerequisites

# 创建文件夹，存储编译中产生的临时文件
mkdir build
cd build/

# 配置编译
../configure --prefix=/usr/local/gcc-10.1.0 --enable-bootstrap --enable-checking=release --enable-languages=c,c++ --disable-multilib

# 进行编译，只能进程数能够加速
make -j 8

# 安装，大约3-5分钟左右
make install

# 配置为默认 gcc
echo -e '\nexport PATH=/usr/local/gcc-10.1.0/bin:$PATH\n' >> /etc/profile.d/gcc.sh && source /etc/profile.d/gcc.sh
ln -sv /usr/local/gcc-10.1.0/include/ /usr/include/gcc

# 配置生效 & 验证
ldconfig -v
ldconfig -p | grep gcc
gcc -v

#清理docker的内容
cd ../..
rm gcc-10.1.0.tar.gz
rm -r gcc-10.1.0/
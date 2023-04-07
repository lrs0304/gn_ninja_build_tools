#!/usr/bin/env bash

# build_basic_docker_from_tlinux2.4
# yum -y update

# install gcc环境
yum -y install zlib zlib-devel curl gcc curl-devel expect make wget gettext zip unzip

# install python3
yum -y install python3 python3-devel

# install gcc11
wget -c https://github.com/gcc-mirror/gcc/archive/refs/tags/releases/gcc-11.2.0.zip
unzip gcc-11.2.0.zip
cd gcc-11.2.0

# 下载依赖包
./contrib/download_prerequisites

# 创建文件夹，存储编译中产生的临时文件
mkdir build
cd build/

# 配置编译
../configure --prefix=/usr/local/gcc-11.2.0 --enable-bootstrap --enable-checking=release --enable-languages=c,c++ --disable-multilib

# 进行编译，只能进程数能够加速
# make -j 8
# 安装，大约3-5分钟左右
make install

# 配置为默认 gcc
echo -e '\nexport PATH=/usr/local/gcc-11.2.0/bin:$PATH\n' >> /etc/profile.d/gcc.sh && source /etc/profile.d/gcc.sh
ln -sv /usr/local/gcc-11.2.0/include/ /usr/include/gcc
ln -sf `which gcc` /bin/cc

# 配置生效 & 验证
ldconfig -v
ldconfig -p | grep gcc
gcc -v

#清理docker的内容
cd ../..
rm gcc-11.2.0.tar.gz
rm -r gcc-11.2.0/


# 编译新版本git
wget https://github.com/git/git/archive/refs/tags/v2.38.4.zip
unzip v2.38.4.zip
cd git-2.38.4/

yum -y install curl-devel expat-devel openssl-devel
make prefix=/usr/local/git install
cd ..

# 配置默认
# /etc/profile 最后一行的 export PATH... 为系统的环境变量，这里相当于 append 进去
echo -e "\nexport PATH=/usr/local/git/bin:$PATH\n" >> /root/.bashrc

# 立即执行，刷新环境变量
source /root/.bashrc
git --version
ln -sf `which git` /bin/git

# 清理docker里的内容
rm v2.38.4.zip
rm -r git-2.38.4/

# 配置git 参数
git config --global user.email "anonymous"
git config --global user.name "anonymous"
git config --global http.postBuffer 524288000

# install git-lfs
yum -y install git-lfs \
    && git lfs install
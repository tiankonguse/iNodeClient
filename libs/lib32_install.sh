#!/bin/sh

##param must be exists
if [ "$1" == "" ]
then
    echo "Please input software source path."
    echo "eg:    ./lib32_install.sh /mnt/cdrom/"   
    exit 1
fi

##backup inode.repo if /etc/yum.repos.d/inode.repo exists
if [ -f "/etc/yum.repos.d/inode.repo" ]
then
    echo "/etc/yum.repos.d/inode.repo exists."
    mv -f /etc/yum.repos.d/inode.repo /etc/yum.repos.d/inode.repo.old
fi

echo "software source path:  $1"

echo "[Cluster]" > /etc/yum.repos.d/inode.repo
echo "name=Red Hat Enterprise Linux \$releasever - \$basearch - Cluster"  >> /etc/yum.repos.d/inode.repo
echo "baseurl=\"file://$1\" " >> /etc/yum.repos.d/inode.repo
echo "enabled=1 " >> /etc/yum.repos.d/inode.repo
echo "gpgcheck=1 " >> /etc/yum.repos.d/inode.repo
echo "gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release  ">> /etc/yum.repos.d/inode.repo

TEMP=`echo "$1"|grep '/$'`
if [  "$TEMP" != "" ]
then
    INSTALL_PATH=${1}Packages
else
    INSTALL_PATH=${1}/Packages
fi
echo "software packages path:  $INSTALL_PATH"
yum clean all  > /dev/null 2>&1
yum repolist  > /dev/null 2>&1
sleep 2
echo "start installing:"
yum -y install "$INSTALL_PATH"/libstdc++*.i686.rpm
yum -y install "$INSTALL_PATH"/ncurses*.i686.rpm
yum -y install "$INSTALL_PATH"/gtk2*.i686.rpm
yum -y install "$INSTALL_PATH"/glibc*.i686.rpm
yum -y install "$INSTALL_PATH"/libgcc*.i686.rpm
yum -y install "$INSTALL_PATH"/libXxf86vm*.i686.rpm
yum -y install "$INSTALL_PATH"/libSM*.i686.rpm
yum -y install "$INSTALL_PATH"/PackageKit-gtk-module*.i686.rpm
yum -y install "$INSTALL_PATH"/libcanberra-gtk2*.i686.rpm

sleep 2
rm -f /etc/yum.repos.d/inode.repo

if [ -f "/etc/yum.repos.d/inode.repo.old" ]
then
    echo "/etc/yum.repos.d/inode.repo.old exists."
    mv -f /etc/yum.repos.d/inode.repo.old /etc/yum.repos.d/inode.repo
fi



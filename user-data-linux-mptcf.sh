#!/bin/bash

touch /tmp/completed
yum -y install epel-release
setenforce 0
sed -i 's/^SELINUX=enforcing/SELINUX=permissive/' /etc/selinux/config

sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl restart sshd.service

OSv=`cat /etc/redhat-release |cut -d' ' -f3`
H=`cat /etc/sysconfig/network |grep 'HOSTNAME' |wc -l`
if [ "$H" == 0 ]
then
        echo "HOSTNAME=HNAME" >> /etc/sysconfig/network
else
        sed -i 's/.*HOSTNAME.*/HOSTNAME=HNAME/' /etc/sysconfig/network
fi
hostname HNAME
echo "HNAME" > /etc/hostname
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDci6vj8HKLT4Dc0U6RNxMAzxu8zcLbXU0WW5u2nQj5lJUjhkA22DsACeBZitCw5AHCX3i9401iZyOO64AD11/trgkvfu5fYA+xh4teKk10JR+skReKUP3wd8uqWkwXy6GyGKUxdAzslVXeGQxKPvtQv7AdNiKcoQv9n/WYSCEVO/ZrsG/s0JvLg+HIeg9tzmCdH0kzTxK9AlRW/iy1822SQfMAavUggQXALOcsNgqHTMhsvJlb4zW8iENkz+CMZgWdZYx6Lhb/N5mD9QRYs8Mk3H2JN1o/Gw7mF9vN1odXW85twbefpP67wTLmqT5phaib1sdSk7ifXFvHXg09bHq5 root@usnjlswalk01.waterfrontmedia.net" >> /root/.ssh/authorized_keys
echo 'HNAME' > /proc/sys/kernel/hostname
yum install wget sshpass ntpdate epel-release -y
ntpdate 172.31.22.107
chattr -i /etc/resolv.conf
wget http://172.31.88.206/packages/resolv.conf-temp -O /etc/resolv.conf
chattr +i /etc/resolv.conf
wget http://172.31.88.206/packages/puppetlabs-release-el-7.noarch.rpm -O /tmp/puppetlabs-release-el-7.noarch.rpm
rpm -ivh /tmp/puppetlabs-release-el-7.noarch.rpm
#yum -y install puppet

wget http://172.31.88.206/packages/puppet.conf-temp -O /etc/puppet/puppet.conf
sed -i 's/HOSTNAME/HNAME/' /etc/puppet/puppet.conf
sed -i '6ipreserve_hostname: true' /etc/cloud/cloud.cfg
rm -rf /etc/localtime
ln -s /usr/share/zoneinfo/America/New_York /etc/localtime

echo "100" > /tmp/completed
# VirtualBox 4.3.28 64 bit
# CentOS-7-x86_64-Everything-1503-01.iso
# Name: centos7-vagrant
# Mem: 512M
# Disk: 20G
# disable audio and usb
# base install centos7 - minimal
# root password: vagrant
# add user: vagrant/vagrant
# login as root
# dhclient
# 
yum update -y
yum install -y epel-release
yum install -y gcc kernel-devel-$(uname -r) kernel-headers-$(uname -r) dkms make bzip2 perl ntp wget vim 
curl -O http://download.virtualbox.org/virtualbox/4.3.28/VBoxGuestAdditions_4.3.28.iso
mkdir /media/iso
mount -t iso9660 -o loop VBoxGuestAdditions_4.3.28.iso /media/iso/
sh /media/iso/VBoxLinuxAdditions.run
umount /media/iso
rm VBoxGuestAdditions_4.3.28.iso
rmdir /media/iso

sed -i -e 's/^ONBOOT=.*/ONBOOT=yes/' /etc/sysconfig/network-scripts/ifcfg-enp0s3

chkconfig ntpd on && chkconfig sshd on && chkconfig NetworkManager on
sed -i -e 's/^.*UseDNS .*/UseDNS no/' /etc/ssh/sshd_config
sed -i -e 's/^SELINUX=.*/SELINUX=permissive/' /etc/selinux/config

sed -i 's/^\(Defaults.*requiretty\)/#\1/' /etc/sudoers

echo 'vagrant ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

mkdir -p /home/vagrant/.ssh

wget --no-check-certificate https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant -O /home/vagrant/.ssh/id_rsa

wget  --no-check-certificate https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub -O /home/vagrant/.ssh/id_rsa.pub

cat  /home/vagrant/.ssh/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys 

chown -R vagrant:vagrant /home/vagrant/.ssh

chmod 0600 /home/vagrant/.ssh/authorized_keys
chmod 0700 /home/vagrant/.ssh

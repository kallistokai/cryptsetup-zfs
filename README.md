# install ZFS
`apt install linux-headers-amd64 zfsutils-linux zfs-dkms zfs-zed`

# install modules required by mountEncryptedZfs.pl
`apt libio-prompter-perl`

# manual commands (device name is 'sda3', pool name is 'storage'):
`cryptsetup luksFormat /dev/sda3`
`cryptsetup luksOpen /dev/sda3 sda3_crypt`
`zfs create storage /dev/mapper/sda3_crypt`
`zfs set mountpoint=/mnt/storage storage`
`zfs set canmount=off storage`
`zfs set compression=lz4 storage`
`zfs create storage/rootfs`

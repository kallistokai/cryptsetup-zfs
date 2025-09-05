### Install ZFS
```
apt install linux-headers-amd64 zfsutils-linux zfs-dkms zfs-zed
```

### Install modules required by mountEncryptedZfs.pl
```
apt libio-prompter-perl
```

### Set up encrypted device (block device name is 'sda3')
```
cryptsetup luksFormat /dev/sda3
cryptsetup luksOpen /dev/sda3 sda3_crypt
```

### Set up zpool
```
zfs create storage /dev/mapper/sda3_crypt
zfs set mountpoint=/mnt/storage storage
zfs set canmount=off storage
zfs set compression=lz4 storage
```

### Set up `rootfs` dataset
```
zfs create storage/rootfs
```

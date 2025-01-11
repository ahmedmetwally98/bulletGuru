# Assignment 2

## Requirements.

- Make at least two partitions on your SD-CARD using gparted.
- Create for each partitions filesystem ( first one ext4 & second one ext2 ).
- Mount two partitions on your root filesystem.
- Add some files inside each one.
- Reboot your machine.
- check if mounting points still exists, it should not.
- Make the ext4 persistance by adding /etc/fstab file —-> (search how you can do that).
- reboot your system.
- Check if the ext4 is mounted.

> commands:
>>
>> 1. `$ lsblk` to list all block devices. The USB flash driver should be displayed. The flash device's path -> `/dev/sdc`
>> 2. `$ sudo umount /dev/sdc` to unmount the flash device from its default mounting point.
>> 3. `$ sudo fdisk /dev/sdc`
>> 4. I created 3 primary partitions.
>> 5. `$ sudo mkfs -t {{ext4|ext3|ext2...}} {{path/to/partition}}` to assign a filesystem type to a specific partition.
>> 6. `$ sudo mkfs -t ext4 /dev/sdc1` create part1 with ext4 fs
>> 7. `$ sudo mkfs -t ext3 /dev/sdc2` create part1 with ext3 fs
>> 8. `$ sudo mkfs -t ext2 /dev/sdc3` create part1 with ext2 fs
>> 9. `$ sudo mount /dev/sdc1 /part1` 
>> 10. `$ sudo mount /dev/sdc2 /part2`
>> 11. `$ sudo mount /dev/sdc3 /part3`
>> After rebooting the machine all mounting points are removed, because all these mounting points are dynamically add. if we need to make it permenant we need to modify the `/etc/fstab` file. so that we can add an entry point for filesystem of a specific partitiofor given storage device.
>> 12. add the following line to the `/etc/fstab` file to add entry point of ext4 fs for specific UUID `UUID=d07c6cd1-ebc9-4beb-9893-857e55448fde  /part1 ext4 defaults 0 2`
>> 13. run command `$ sudo mount -a` to ensure no errors in the `/etc/fstab` file.
>> After rebooting, the mounting point /part1 for partition of ext4 fs still exists.

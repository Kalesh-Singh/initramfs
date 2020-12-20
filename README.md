# Boot in qemu

```bash
 qemu-system-<arch> \
 -initrd initramfs.cpio.gz \
 -kernel bzImage \
 -net user,host=10.0.2.10,hostfwd=tcp::10023-:22 \
 -nographic \
 -append "console=ttyS0"
 ```

### TODO

ssh with `dropbear` isn't working currently.

For now, you can get a file onto the `guest` by adding it in `initramfs`.

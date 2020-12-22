# Boot in qemu

```bash
 qemu-system-<arch> \
 -initrd initramfs.cpio.gz \
 -kernel bzImage \
 -net user,host=10.0.2.10,hostfwd=tcp::10023-:22 \
 -nographic \
 -m 1G \
 -append "console=ttyS0"
 ```

### TODO

ssh configurations still not sorted.

For now, you can get a file onto the `guest` by adding it in `initramfs`.

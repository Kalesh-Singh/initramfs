# Boot in qemu

```bash
 qemu-system-x86_64 \
 -initrd initramfs.cpio.gz \
 -kernel bzImage \
 -net user,host=10.0.2.10,hostfwd=tcp::10023-:22 \
 -nographic \
 -m 1G \
 -append "console=ttyS0"
```

```bash
 qemu-system-aarch64 \
 -initrd initramfs.cpio.gz \
 -kernel bzImage \
 -net user,host=10.0.2.10,hostfwd=tcp::10023-:22 \
 -nographic \
 -m 1G \
 -append "console=ttyAMA0" \
 -M virt
 -cpu cortex-a53
```

### TODO

ssh configurations still not sorted.

For now, you can get a file onto the `guest` by adding it in `initramfs`.

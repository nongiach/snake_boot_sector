# Snake game on MBR

Hi folks! Here is one of my one weekend project that I made back in 2013.


# What is this ?

A custom MBR (Master Boot Record) booting a snake game. Once installed on an usb flash drive it will boot instead of your system.

# ScreenToGif

![Alt Text](/snake.gif)

## Start from [qemu](https://www.qemu.org/)

```sh
$ qemu-system-i386 snake.img
```

## Start from [Virtualbox](https://www.virtualbox.org/)

Import snake.ova from virtualbox and start !!

## Start on your hardware using an USB key

```sh
$ sudo dd bs=512 if=snake.img of=/dev/YOUR_USB_KEY_DEVICE
```

*Replace YOUR_USB_KEY_DEVICE by your usb device (example: sdb or sdc).* Be careful if you choose the wrong device your computer might break.
**WARNING:** This command will cause your USB device to lose any data present on it.

Booting on this USB device will not harm your computer.

## Start from [bochs](http://bochs.sourceforge.net)
```sh
$ bochs 'boot:a' 'floppya: 1_44=snake.img, status=inserted'
```

---

By [@chaign\_c][] [#HexpressoTeam][hexpresso].


[hexpresso]:     https://hexpresso.github.io
[@chaign\_c]:    https://twitter.com/chaign_c

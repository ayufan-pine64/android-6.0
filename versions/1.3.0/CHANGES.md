Upgrade (from [Ubuntu](https://github.com/ayufan-pine64/linux-build/releases/latest)):
```
$ pine64_upgrade_android.sh /dev/mmcblk1 android-6.0 1.3.0
```

Notice:
- Edit `/boot/uEnv.txt` as there are many different system and performance level configuration options,
- Add to `/boot/uEnv.txt`:
  - `emmc_compat=on`: if you are having problems with using eMMC module (especially eMMC 5.1),
  - `pinebook_lcd_mode=batch1|batch2`: if you are having problems with screen flickering on Pinebook,

Changes:
- 1.3.0: Use custom build boot0 with support for eMMC 5.1,
- 1.3.0: Support HS200 for eMMC 5.1,
- 1.3.0: Add `emmc_compat=150mhz|200mhz` allowing to enable extra performance boost on eMMC (unstable),
- 1.3.0: Make u-boot and kernel to support eMMC 5.1,
- 1.3.0: Run u-boot eMMC support in compatibility mode (SDR25),
- 1.3.0: Allow to change Pinebook LCD parameters with `uEnv.txt` to fix flickering,
- 1.3.0: Allow to enable eMMC compatibility mode for Android via `uEnv.txt`,


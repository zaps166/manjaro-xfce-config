# Manjaro Linux Xfce configuration

Xfce4 desktop + custom config by me.

## Configuration steps

### Running script

You can run script and response `y` for most/all questions if you have clean Manjaro MATE configuration. If you have existing installation of Arch/Manjaro Linux, review/modify the script first, because it will change your computer configuration!

Run script: `./install.sh`

### Other configuration

Remove qt5ct (optional, but this is unused now):
 - `sudo pacman -Rc qt5ct`

Install QMPlay2:
- `yay -S qmplay2-git`

For laptops with microphone mute LED:
- `yay -S mic-mute-led-reverse`

For laptops to prevents suspend if you have external display connected when running on laptop's battery in MATE desktop:
- `yay -S xfce4-no-sleep-on-battery-lid-closed-git`

Kvantum can be configured by script, but for manual configuration:
- disable compositing and translucency - it can degrade scrolling performance and it can cause glitches in some applications,
- disable transient scrollbars (optional),

Optional no password for sudo:
- `sudo visudo` - uncomment line with "%wheel" and "NOPASSWD", save and exit
- `sudo rm /etc/sudoers.d/10-installer`

Useful Firefox about:config flags:
- `middlemouse.paste = false`
- `general.autoScroll = true`
- `general.smoothScroll = false`
- `security.dialog_enable_delay = 0`
- `browser.sessionstore.restore_pinned_tabs_on_demand = true`
- `privacy.webrtc.legacyGlobalIndicator = false`
- `browser.download.improvements_to_download_panel = false`
- `places.history.expiration.max_pages = 2147483647` (create new integer value)
- `media.autoplay.block-event.enabled = true`
- `fission.autostart = false`
- `browser.tabs.searchclipboardfor.middleclick = false`

For VA-API acceleration in Firefox:
- `media.ffmpeg.vaapi.enabled = true`
- `gfx.webrender.all = true` (force WebRender to be sure)

Some useful kernel boot command line:
- `mitigations=off` (dangerous, disable CPU BUGs mitigations)
- `tsc=reliable` (on some PCs it's TSC is detected as unreliable - it forces TSC anyway)
- `nvidia-drm.modeset=1` (useful for Nvidia Optimus laptops)
- `intel_pstate=passive` (allows to use ondemand and schedutil governors on Intel CPUs)
- `intel_iommu=on,igfx_off` (for GPU/PCI passthrough on Intel CPUs)
- `iommu=pt` (for GPU/PCI passthrough)
- `video=efifb:off` (useful for GPU passthrough)
- `amdgpu.ppfeaturemask=0xffffffff` (enables O/C for AMD Radeons)
- `pcie_aspm=force` (if APSM is not detected, but you want to use it anyway)
- `pci=noaer` (for bugged BIOS - don't use if not needed)
- `nmi_watchdog=0`
- `preempt=full`
- `highres=on`

Other hints:
- edit `/etc/default/grub`:
  - remove `quiet`
  - add some kernel boot command line arguments
  - run `sudo update-grub` after configuration
- edit `/etc/mkinitcpio.conf`:
  - set `MODULES=(amdgpu)` for early KMS for AMD Radeon GPUs
  - set `MODULES=(i915)` for early KMS for Intel GPUs
  - run `sudo mkinitcpio -P`
- don't install `libva-vdpau-driver` and `xfce4-volumed-pulse` - uninstall if you have it
- command to toggle microphone mute: `pactl set-source-mute @DEFAULT_SOURCE@ toggle`
- on laptop install `tlp` and `tlpui` and configure PCI Runtime PM, ASPM, CPU governor for AC and Battery (enable: `sudo systemctl enable tlp`)
- if you don't configure NVIDIA by MHWD, add `options nvidia "NVreg_DynamicPowerManagement=0x02"` to `/etc/modprobe.d/nvidia.conf` on modern laptops to allow to suspend GPU
- run `watch -n 1 cat /sys/bus/pci/devices/0000:01:00.0/power/runtime_status` to check power status for NVIDIA GPU on laptop (replace `0000:01:00.0` with your configuration from `lspci`)
- [LightDM config for NVIDIA Optimus as first GPU in X11](https://wiki.archlinux.org/title/NVIDIA_Optimus#LightDM)
- [security (faillock) docs](https://wiki.archlinux.org/title/security#User_setup)
- [encryption docs](https://wiki.archlinux.org/title/Dm-crypt/Encrypting_an_entire_system)
- install `xiccd` for color management

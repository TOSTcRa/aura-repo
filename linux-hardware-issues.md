# Linux Hardware Issues - Comprehensive Guide (2025-2026)

This document provides a detailed overview of common hardware and driver issues Linux users face, along with known workarounds and solutions.

---

## 1. GPU Issues

### 1.1 AMD GPU Problems

#### AMD GPU Reset Bug
The AMD GPU reset bug is a well-known issue that causes system hangs and crashes:

**Symptoms:**
- Complete system freeze requiring hard reboot
- Black screen followed by graphical artifacts
- "Ring GFX_0.0.0 timeout and reset failure" errors
- Log messages: "GPU reset begin!" followed by reset success/failure

**Affected Hardware:**
- RX 6000 series (RDNA2)
- RX 7000 series (RDNA3)
- RX 8000 series (RDNA4)

**Known Workarounds:**
1. **Underclock GPU**: Set max clock to stock spec (e.g., 2491 MHz for RX 6600) using CoreCtrl
2. **Use LTS kernel**: Issues more common in 6.12+ kernels
3. **Kernel parameter**: Add `amdgpu.gpu_recovery=0` to disable GPU recovery (less safe)
4. **Per-queue reset**: Coming in future kernels - AMD is developing per-queue reset support

**GPU Passthrough Reset Bug (VFIO):**
- GPU fails to reset properly after VM shutdown
- Requires full host reboot before starting another VM
- **Fix**: Use `vendor-reset` kernel module for supported AMD GPUs
- **Fix**: Bind device to vfio-pci before any other driver can touch it

**Sources:**
- [Ubuntu 25.04 GPU crashing discussion](https://discourse.ubuntu.com/t/amd-gpu-crashing-on-ubuntu-25-04-ring-gfx-0-0-0-timeout-and-reset-failure/62975)
- [Linux Mint RX 6600 GPU reset fix](https://forums.linuxmint.com/viewtopic.php?t=441502)
- [AMD GPU reset improvements - Phoronix](https://www.phoronix.com/news/Better-AMD-GPU-Reset-Linux)
- [Proxmox AMD Reset Bug discussion](https://forum.proxmox.com/threads/amd-reset-bug-on-linux-vm-only.94341/)

---

### 1.2 Intel Arc Driver Problems

#### Current Status (2025-2026)
Intel Arc GPUs have dual driver support (i915 and Xe), causing compatibility issues:

**Known Issues:**
- Arc A750 and A770 broken on Linux 6.19 Git kernel (no display output)
- Arc A580 works on both drivers
- 25-50% lower performance than expected in modern games
- System freezes when opening Steam (Arc B580)
- Games failing to launch

**Requirements:**
- **Minimum kernel**: 6.11 for Lunar Lake, Battlemage (B570/B580)
- Debian's stable kernel is too old for Arc support

**Workarounds:**
1. Use OpenGL instead of Vulkan if experiencing corruption/freezes
2. Upgrade Mesa via kisak-mesa PPA (Ubuntu-based distros)
3. Use newer kernel (6.11+)
4. Choose between i915 and Xe driver based on your GPU model

**Sources:**
- [Intel Xe vs i915 performance - Phoronix](https://www.phoronix.com/review/intel-xe-i915-linux-619)
- [GamersNexus Intel Arc driver review](https://gamersnexus.net/gpus/intel-arc-gpu-driver-problems-revisited-2025-arc-graphics-driver-review)
- [EndeavourOS Arc driver discussion](https://forum.endeavouros.com/t/are-the-intel-arc-drivers-really-this-bad-on-linux/77240)
- [Intel Arc ArchWiki](https://wiki.archlinux.org/title/Intel_graphics)

---

### 1.3 NVIDIA Optimus/Hybrid Graphics

#### Common Problems
- Screen tearing without prime sync
- System freezes 20-30 minutes after boot (PCI reallocation loop)
- External displays not working
- GPU power state transition issues
- Laptop power off when switching graphics (RTX 30 series Mobile)

**Solutions:**

1. **PRIME Render Offload** (Official NVIDIA method)
   ```bash
   __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia application
   ```

2. **Optimus Manager**
   ```bash
   yay -S optimus-manager optimus-manager-qt
   ```

3. **EnvyControl** (No daemon required)
   ```bash
   sudo envycontrol -s nvidia  # Switch to NVIDIA
   sudo envycontrol -s integrated  # Switch to Intel/AMD
   ```

4. **Fix system freezes** (Add to `/etc/modprobe.d/nvidia.conf`):
   ```
   options nvidia NVreg_DynamicPowerManagement=0x02
   ```

5. **Enable DRM kernel mode setting** for prime sync:
   ```
   options nvidia-drm modeset=1
   ```

**Sources:**
- [NVIDIA Optimus - ArchWiki](https://wiki.archlinux.org/title/NVIDIA_Optimus)
- [Optimus Manager GitHub](https://github.com/Askannz/optimus-manager)
- [System freezes on hybrid graphics - GitHub](https://github.com/basecamp/omarchy/issues/3242)

---

### 1.4 HDR Support Problems

#### Current State (2025)
HDR support has reached a major milestone with the Wayland color management protocol merged!

**Working:**
- GNOME 48 with HDR support
- KDE Plasma 6 with HDR
- MPV media player
- Mesa Vulkan WSI
- SDL 3.2.6+
- Chromium HDR video playback

**Known Issues:**

1. **NVIDIA Problems:**
   - Enabling HDR on login crashes KWin (driver 550.90+)
   - Stable drivers lack VK_EXT_swapchain_colorspace
   - Gamescope recommended with AMD GPU instead

2. **GNOME Limitations:**
   - Gamescope HDR appears "washed out"
   - No scRGB or frog-color-management-v1 protocol support

3. **Firefox:**
   - HDR not enabled by default
   - Enable via `about:config` -> `gfx.wayland.hdr`

4. **EDID Parsing:**
   - GNOME/KDE can't read HDR metadata from DisplayID 2.0
   - Only CTA-861 blocks are parsed

5. **X11:**
   - No HDR support, no development in that direction

**Sources:**
- [Wayland HDR Protocol merged - GamingOnLinux](https://www.gamingonlinux.com/2025/02/wayland-colour-management-and-hdr-protocol-finally-merged/)
- [Linux HDR 2025 review - Phoronix](https://www.phoronix.com/review/linux-hdr-2025)
- [HDR ArchWiki](https://wiki.archlinux.org/title/HDR)
- [Chromium HDR support - It's FOSS](https://itsfoss.com/news/chromium-native-hdr-support-wayland/)

---

### 1.5 VRR/FreeSync/G-Sync Issues

#### Common Problems

1. **Multi-monitor issues:**
   - VRR stutters on dual monitors
   - Monitor frequency drops to 49Hz when no VRR application running
   - Desktop animations become jerky

2. **Desktop environment compatibility:**
   - Works in KDE but not in Cinnamon
   - Some compositors lack direct scanout support

3. **X11 vs Wayland:**
   - Some users unknowingly use X11 where VRR doesn't work

4. **G-Sync requirements:**
   - Must use DisplayPort connection
   - HDMI 2.1 VRR requires kernel 5.13+

**Solutions:**

1. **Check VRR status:**
   ```bash
   # For AMD
   cat /sys/class/drm/card0-DP-1/vrr_capable

   # In KDE
   # System Settings -> Display -> VRR
   ```

2. **Enable G-Sync on unvalidated monitors:**
   - nvidia-settings -> X Server Display Configuration -> Advanced
   - Select "Allow G-SYNC on monitor not validated as G-SYNC Compatible"

3. **Use frame limiter:**
   - Keep FPS within VRR range (e.g., 80-144 for 144Hz monitor)
   - Use MangoHud: `MANGOHUD_CONFIG=fps_limit=140`

4. **Fullscreen requirement:**
   - VRR only works in fullscreen
   - Enable compositor option for "Display fullscreen windows in overlay"

**Sources:**
- [VRR ArchWiki](https://wiki.archlinux.org/title/Variable_refresh_rate)
- [VRR/FreeSync in Cinnamon - Linux Mint Forums](https://forums.linuxmint.com/viewtopic.php?t=448289)
- [NVIDIA VRR issues - Developer Forums](https://forums.developer.nvidia.com/t/monitors-literally-stutter-when-vrr-g-sync-is-enabled/256836)

---

## 2. Laptop Issues

### 2.1 Fingerprint Readers

#### Why Most Don't Work
- Closed-source firmware/drivers
- Proprietary protocols (Windows Hello specific)
- Lack of vendor documentation

**Check Support:**
```bash
lsusb | grep -i finger
# Compare USB ID with fprint supported devices list
```

**Supported Solutions:**

1. **fprintd** (main framework):
   ```bash
   sudo apt install fprintd libpam-fprintd
   fprintd-enroll
   ```

2. **Dell laptops:**
   - May need `libfprint-2-tod1-broadcom` package
   - BIOS update may be required
   - Install libssl1.1

3. **Synaptics Tudor sensors:**
   - Check GitHub for specific drivers

**Unsupported Hardware:**
- Many Goodix readers (521d, etc.)
- Most IR-based Windows Hello cameras
- Some newer Synaptics models

**Sources:**
- [Fingerprint sensor and Linux - Linux BSD OS](https://linuxbsdos.com/2025/02/16/your-laptops-fingerprint-sensor-and-linux/)
- [Dell fingerprint fix - Dell Community](https://www.dell.com/community/en/conversations/precision-mobile-workstations/make-fingerprint-reader-work-again-with-linux-ubuntu-2404/66a762ff8e75fa46cbe9c76e)
- [fprintd project](https://fprint.freedesktop.org/)

---

### 2.2 IR Cameras (Windows Hello)

#### Current Status
**NOT SUPPORTED** in most cases.

- IR cameras use proprietary Windows Hello protocols
- No official Linux drivers from vendors
- libfprint focuses on fingerprint readers, not facial recognition

**Alternative: Howdy**
```bash
sudo add-apt-repository ppa:boltgolt/howdy
sudo apt install howdy
sudo howdy add
```
- Works with standard webcams (not IR)
- Less secure than Windows Hello
- May have issues with low light conditions

---

### 2.3 Thunderbolt/USB4 Problems

#### Known Issues (2025)
- USB4 docks not working on kernels past 6.11.5
- Kernel panics with Wayland compositors
- Intel maintainer departure affecting development
- Dock disappeared from boltctl after updates

**Solutions:**

1. **Check authorization:**
   ```bash
   boltctl list
   boltctl authorize <device-uuid>
   ```

2. **Enable in UEFI:**
   - Disable "Secure Thunderbolt" mode for ad-hoc connections
   - Or use udev rules from Arch Wiki

3. **BIOS update:**
   - Many dock issues resolved by firmware updates

4. **Debug logging:**
   ```bash
   # Add to kernel cmdline
   thunderbolt.dyndbg=+p
   ```

**AMD Systems:**
- Enabling Thunderbolt may reduce PCIe lanes for other devices
- Verify PCIe lane allocation in BIOS

**Sources:**
- [Thunderbolt/USB4 kernel docs](https://docs.kernel.org/admin-guide/thunderbolt.html)
- [USB4 dock issues - Arch Forums](https://bbs.archlinux.org/viewtopic.php?id=304715)
- [Intel tbtools GitHub](https://github.com/intel/tbtools)

---

### 2.4 Touchpad Gestures

#### Common Issues
- 3-finger tap emulating middle click unexpectedly
- Gestures stop working for ~15 seconds randomly
- Pinch-zoom often unavailable
- Conflicts with touchscreen on 2-in-1 laptops

**Solutions:**

1. **Touchegg + Touché** (Recommended):
   ```bash
   sudo apt install touchegg
   flatpak install flathub com.github.joseexposito.touche
   ```

2. **libinput-gestures**:
   ```bash
   sudo gpasswd -a $USER input
   sudo apt install libinput-tools
   # Install gestures app
   ```

3. **Fusuma** (Ruby-based):
   ```bash
   sudo apt install ruby libinput-tools
   sudo gem install fusuma
   ```

4. **Fix 3-finger tap** (xinput):
   ```bash
   xinput list  # Find touchpad device
   xinput get-button-map <device-id>
   xinput set-button-map <device-id> 1 2 3 ...
   ```

5. **GNOME on X11:**
   - Install X11Gestures GNOME extension

**Wayland Requirement:**
- Check Wayland is enabled if gestures don't work on Ubuntu

**Sources:**
- [Touchegg GitHub](https://github.com/JoseExposito/touchegg)
- [Touchpad gestures - Baeldung](https://www.baeldung.com/linux/touchpad-gestures)
- [Touchpad Synaptics - ArchWiki](https://wiki.archlinux.org/title/Touchpad_Synaptics)

---

### 2.5 Keyboard Backlight Control

#### Common Issues
- Backlight turns off after suspend/sleep
- Fn keys not working
- No control slider in settings

**Solutions:**

1. **Check available controls:**
   ```bash
   ls /sys/class/leds/
   # Look for *::kbd_backlight
   ```

2. **Manual control:**
   ```bash
   # Read current level
   cat /sys/class/leds/*/kbd_backlight/brightness

   # Set brightness (0-3 typically)
   echo 2 | sudo tee /sys/class/leds/*/kbd_backlight/brightness
   ```

3. **Use brightnessctl:**
   ```bash
   sudo apt install brightnessctl
   brightnessctl --list
   brightnessctl -d *::kbd_backlight set 2
   ```

4. **ASUS laptops:**
   ```bash
   yay -S asusctl
   asusctl -k low  # low, med, high, off
   ```

5. **Restore after suspend** (systemd service):
   ```bash
   # /etc/systemd/system/kbd-backlight-restore.service
   [Unit]
   Description=Restore keyboard backlight after suspend
   After=suspend.target

   [Service]
   Type=oneshot
   ExecStart=/usr/bin/brightnessctl -d *::kbd_backlight set 2

   [Install]
   WantedBy=suspend.target
   ```

**Sources:**
- [Keyboard backlight - ArchWiki](https://wiki.archlinux.org/title/Keyboard_backlight)
- [Linux Mint backlight issues](https://forums.linuxmint.com/viewtopic.php?t=408147)

---

### 2.6 Fan Control

#### ACPI/Firmware Issues
- Fan control stuck at high speed after kernel update
- No fan control on certain ASUS/Dell/HP laptops
- Microsoft ACPI fan extensions needed

**Vendor-Specific Tools:**

1. **ThinkPad:**
   ```bash
   sudo apt install thinkfan
   # Configure /etc/thinkfan.conf
   ```

2. **ASUS:**
   ```bash
   yay -S asusctl
   asusctl fan-curve -m quiet
   ```

3. **Dell:**
   ```bash
   # Enable dell-smm-hwmon
   sudo modprobe dell-smm-hwmon
   ```

4. **Lenovo Legion:**
   - Install lenovo-legion-linux kernel module

**General Tools:**

```bash
# Install fancontrol
sudo apt install lm-sensors fancontrol
sudo sensors-detect
sudo pwmconfig
sudo systemctl enable fancontrol
```

**Known Issues:**
- fancontrol doesn't work after suspend (must restart service)
- ACPI errors may require BIOS update
- Ubuntu 24 kernel regression affecting fan control

**Sources:**
- [Fan speed control - ArchWiki](https://wiki.archlinux.org/title/Fan_speed_control)
- [Microsoft ACPI fan extensions - Phoronix](https://www.phoronix.com/news/Linux-Microsoft-ACPI-Fan)

---

## 3. Peripheral Issues

### 3.1 Webcam Quality

#### Why Quality is Worse on Linux
- Aggressive auto-exposure and auto-gain settings
- Default resolution may be lower
- USB bandwidth limitations with hubs
- No vendor tuning like Windows drivers

**Solutions:**

1. **Adjust camera settings:**
   ```bash
   sudo apt install v4l-utils
   v4l2-ctl --list-devices
   v4l2-ctl -d /dev/video0 --list-ctrls
   v4l2-ctl -d /dev/video0 --set-ctrl=auto_exposure=1
   v4l2-ctl -d /dev/video0 --set-ctrl=exposure_time_absolute=200
   ```

2. **Use fix-webcam-linux script:**
   - [GitHub: fix-webcam-linux](https://github.com/pravin/fix-webcam-linux)

3. **Use Webcamoid for higher resolutions:**
   ```bash
   flatpak install flathub io.github.nickvergessen.webcamoid
   ```

4. **Connect directly to USB port** (avoid hubs)

5. **Use MJPEG format** for 720p+ in guvcview

**Sources:**
- [fix-webcam-linux GitHub](https://github.com/pravin/fix-webcam-linux)
- [Webcam troubleshooting - Ubuntu](https://help.ubuntu.com/community/Webcam/Troubleshooting)

---

### 3.2 Drawing Tablets (Wacom, XP-Pen, Huion)

#### Wacom Support
Good out-of-box support thanks to Linux Wacom Project:

```bash
# Check if detected
xsetwacom list
libinput list-devices | grep -i wacom

# Configure
xsetwacom set "Wacom Intuos Pro M Pen stylus" MapToOutput HDMI-1
```

**Common Issues:**
- Multi-monitor mapping (tablet maps to all screens)
- New models may need kernel update
- libinput errors on some devices

**XP-Pen / Huion:**
```bash
# Install digimend drivers
sudo apt install digimend-dkms
```

**Configuration Tools:**
- **Wacom**: Use xsetwacom or GNOME/KDE settings
- **OpenTabletDriver**: Cross-platform alternative

**Sources:**
- [Linux Wacom Project](https://linuxwacom.github.io/)
- [Graphics tablet - ArchWiki](https://wiki.archlinux.org/title/Graphics_tablet)

---

### 3.3 Gaming Peripherals (Razer, Logitech, Corsair)

#### Razer Devices
No official drivers, but excellent community support:

```bash
# Install OpenRazer
sudo add-apt-repository ppa:openrazer/stable
sudo apt install openrazer-meta

# GUI: Polychromatic, RazerGenie, or razercfg
```

**Supported features:**
- RGB lighting
- DPI settings
- Polling rate
- **NOT supported**: Custom keybinds, layers, macros

#### Logitech Devices
```bash
# Install Piper for mice
sudo apt install piper

# For G203 LED control
pip install g203-led
```

#### Universal RGB Control
```bash
# OpenRGB - supports many brands
flatpak install flathub org.openrgb.OpenRGB
```

**Supported brands:**
- ASUS, ASRock, Corsair, G.Skill, Gigabyte
- HyperX, MSI, Razer, ThermalTake

**Sources:**
- [OpenRazer](https://openrazer.github.io/)
- [Razer peripherals - ArchWiki](https://wiki.archlinux.org/title/Razer_peripherals)
- [OpenRGB](https://openrgb.org/)
- [Piper](https://github.com/libratbag/piper)

---

### 3.4 Docking Stations

#### Common Issues
- USB peripherals stop working while power delivery continues
- Monitors not detected
- DisplayLink driver crashes
- Thunderbolt authorization problems

**Solutions:**

1. **DisplayLink docks:**
   ```bash
   # Download from displaylink.com
   # Note: May not work with Secure Boot enabled
   ```

2. **Thunderbolt docks:**
   ```bash
   boltctl list
   boltctl authorize <device>
   ```

3. **USB-C docks:**
   - Upgrade to kernel 6.14+ for 9000 series CPUs
   - Try unplugging dock completely (including power) and wait

4. **General tips:**
   - Keep system updated
   - Try different dock brand if issues persist
   - Disable Secure Boot if DisplayLink fails

**Sources:**
- [Docking station issues - Linux Mint Forums](https://forums.linuxmint.com/viewtopic.php?t=450552)
- [Top docking stations for Linux 2025](https://www.addictivetips.com/buying-guides/laptop-docking-stations-linux/)

---

## 4. Storage Issues

### 4.1 NVMe Power Management

#### APST (Autonomous Power State Transition) Issues
- Drive freezes due to power saving mode
- System hangs after period of inactivity

**Disable APST:**
```bash
# Add to /etc/default/grub GRUB_CMDLINE_LINUX_DEFAULT:
nvme_core.default_ps_max_latency_us=0
sudo update-grub
```

**Check current settings:**
```bash
cat /sys/module/nvme_core/parameters/default_ps_max_latency_us
nvme id-ctrl /dev/nvme0 -H | grep 'Non-Operational Power State'
```

#### AMD IOMMU Issues (HP laptops with KIOXIA drives)
```bash
# Try kernel parameters:
amd_iommu=off
# or
amd_iommu=fullflush
```

**Sources:**
- [NVMe ArchWiki](https://wiki.archlinux.org/title/Solid_state_drive/NVMe)
- [Fixing NVMe problems - mbaraa.com](https://mbaraa.com/blog/fixing-nvme-ssd-problems-on-linux)
- [NVMe optimization guide](https://perlod.com/tutorials/nvme-optimization-for-linux-servers/)

---

### 4.2 SSD TRIM Issues

#### Check TRIM Support
```bash
lsblk --discard
# Non-zero DISC-GRAN means TRIM is supported
```

#### Enable Weekly TRIM
```bash
sudo systemctl enable --now fstrim.timer
# Check status
systemctl status fstrim.timer
```

#### TRIM with LVM/LUKS
- dm-crypt supports discard passthrough
- Has security implications (not enabled by default)
- Enable in /etc/crypttab: add `discard` option

#### Known Issues
- Some Samsung, Micron, Crucial SSDs have TRIM bugs
- Linux ATA driver maintains blacklist for problematic firmware

**Sources:**
- [SSD ArchWiki](https://wiki.archlinux.org/title/Solid_state_drive)
- [TRIM guide - Siberoloji](https://www.siberoloji.com/understanding-trim-in-linux-a-complete-guide-to-ssd-optimization/)

---

## 5. Motherboard/Firmware Issues

### 5.1 Secure Boot

#### Common Problems
- Third-party drivers won't load
- DKMS modules fail to sign
- Dual boot issues with Windows

**Solutions:**

1. **Enroll MOK key:**
   ```bash
   sudo mokutil --import /var/lib/dkms/mok.pub
   # Reboot and enroll in MOK manager
   ```

2. **Sign kernel modules manually:**
   ```bash
   sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 \
     /path/to/private_key.priv /path/to/public_key.der module.ko
   ```

3. **Disable Secure Boot** (last resort):
   - BIOS/UEFI -> Security -> Secure Boot -> Disabled

**Sources:**
- [Secure Boot - ArchWiki](https://wiki.archlinux.org/title/Unified_Extensible_Firmware_Interface/Secure_Boot)
- [Secure Boot with Linux - Medium](https://pawitp.medium.com/the-correct-way-to-use-secure-boot-with-linux-a0421796eade)

---

### 5.2 TPM Issues

#### TPM 2.0 Requirements
- Requires UEFI boot (no Legacy/CSM)
- PCR values change on kernel update

**Full Disk Encryption with TPM:**
```bash
# Enroll TPM key
sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+7 /dev/nvme0n1p3
```

**Known Issues:**
- PCR 4 changes on every kernel update (use PCR 0+7 instead)
- AMD fTPM may cause performance issues
- Firmware bugs can cause PCR 7 to not change properly

**Security Note:**
LogoFAIL vulnerability allows compromising UEFI through malicious boot logos - keep firmware updated!

**Sources:**
- [TPM ArchWiki](https://wiki.archlinux.org/title/Trusted_Platform_Module)
- [FDE with TPM guide](https://blastrock.github.io/fde-tpm-sb.html)

---

### 5.3 Wake on LAN

#### Troubleshooting Steps

1. **Check BIOS settings:**
   - Enable "Wake on LAN" or "Magic Packet"
   - ASRock: "PCIE Devices Power On"

2. **Verify in Linux:**
   ```bash
   sudo ethtool enp5s0 | grep Wake
   # Should show: Wake-on: g
   ```

3. **Enable WOL:**
   ```bash
   sudo ethtool -s enp5s0 wol g
   ```

4. **Make persistent with NetworkManager:**
   ```bash
   nmcli connection modify "Wired connection 1" 802-3-ethernet.wake-on-lan magic
   nmcli device reapply enp5s0
   ```

5. **TLP conflict:**
   ```bash
   # In /etc/tlp.conf:
   WOL_DISABLE=N
   ```

**Known Issues:**
- Kernel 6.2.x regression (fixed in later versions)
- Some Realtek drivers disable WOL by default

**Sources:**
- [Wake on LAN - ArchWiki](https://wiki.archlinux.org/title/Wake-on-LAN)
- [WOL guide - nick.tay.blue](https://nick.tay.blue/2025/03/05/wol/)

---

## Summary: Quick Reference

### GPU Selection for Linux
| GPU | Recommendation | Notes |
|-----|----------------|-------|
| AMD RDNA2+ | Good | Best open-source drivers, occasional reset bugs |
| Intel Arc | Fair | Improving, needs kernel 6.11+, performance issues |
| NVIDIA | Mixed | Proprietary only, Optimus problematic, HDR issues |

### Hardware to Avoid
- Laptops with Goodix fingerprint readers
- IR cameras for facial recognition
- DisplayLink docks with Secure Boot requirement
- Older NVIDIA GPUs (Pascal support dropped)

### Essential Packages
```bash
# General hardware support
sudo apt install linux-firmware fwupd

# GPU tools
sudo apt install mesa-utils vulkan-tools

# Laptop tools
sudo apt install tlp powertop acpi

# Peripheral tools
sudo apt install v4l-utils brightnessctl
```

---

*Last updated: January 2026*
*Based on community reports and official documentation*

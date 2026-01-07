# Linux Pain Points - Research for Crazy Distro

This document compiles common Linux frustrations from community discussions and technical documentation.
A new user-friendly distro should address these issues.

---

## 1. Hardware Compatibility Problems

### WiFi Issues
- **Missing firmware**: Devices require separate firmware packages beyond kernel drivers
- **Driver conflicts**: Multiple drivers loading for one device cause configuration failures
- **RF-kill blocking**: Hardware/software blocks preventing interface activation
- **Random disconnections**: 8+ potential causes including power-saving, channel bandwidth, roaming conflicts
- **Regulatory domain**: Misconfigured regional settings make networks invisible
- **Enterprise WPA2/WPA3**: Complex 802.1X configuration vs simple Personal mode

**Solution for Crazy Distro:**
- Ship with all common WiFi firmware out of the box
- Auto-detect and configure regulatory domain
- Simple GUI for WiFi troubleshooting
- One-click power management toggle

### Bluetooth Problems
- **Service failures**: Missing /sys/class/bluetooth directory, no detected hardware
- **No default controller**: rfkill-blocked or firmware issues
- **USB adapters not recognized**: Broadcom/Logitech devices need firmware flashing
- **Immediate disconnect after pairing**: Dual-boot conflicting pairing keys
- **BLE devices not discovered**: Require special scan modes
- **Cannot reconnect after sleep**: Devices need to be marked as trusted
- **Audio stuttering**: Multiple Bluetooth devices cause interference

**Solution for Crazy Distro:**
- Pre-install all Bluetooth firmware
- Auto-trust paired devices
- Handle dual-boot pairing key sync
- Better audio codec defaults (SBC-XQ, aptX)

### Printer Issues
- **Setup breaks after upgrades**: CUPS config needs restoration
- **Stuck print jobs**: Requires printer deletion and re-addition
- **USB detection conflicts**: usblp module conflicts, USB autosuspend
- **Network printer discovery**: Requires Avahi hostname resolution
- **HP printers dominate problems**: Missing filters, outdated plugins
- **Authentication failures**: GUI apps can't prompt for credentials

**Solution for Crazy Distro:**
- Auto-detect and configure printers
- Include HP drivers by default
- Sane ErrorPolicy defaults (retry-current-job)
- Simple printer troubleshooting GUI

---

## 2. Graphics & Display Problems

### NVIDIA Driver Issues
- **Driver selection confusion**: nvidia-open vs nvidia-dkms vs legacy drivers
- **Wayland problems**: Flickering, out of order frames (pre-555.xx)
- **DRM/KMS requirement**: Must enable modeset=1 manually
- **Turing GPUs**: GSP firmware causes power management issues
- **Legacy Kepler cards**: Fail on newer CPUs with IBT
- **Suspend issues**: VRAM not preserved correctly

**Solution for Crazy Distro:**
- Auto-detect GPU and install correct driver
- Pre-configure DRM/KMS correctly
- Offer easy switch between open/proprietary drivers
- Test suspend/resume during installation

### Display/Monitor Problems
- **KMS resolution issues**: Monitors send incorrect EDID data
- **Tiny console fonts**: After enabling KMS
- **Display detection failures**: Wrong fallback resolutions
- **Multi-monitor setup**: Complex manual configuration

**Solution for Crazy Distro:**
- EDID override GUI
- Sensible font defaults
- Easy multi-monitor configuration tool

### X11/Xorg Issues
- **Black screen**: /tmp full prevents X from creating files
- **Framebuffer conflicts**: xf86-video-fbdev conflicts
- **Missing fonts**: Applications requesting "(null)" fonts
- **Keyboard initialization**: Full filesystem prevents keymap compilation
- **Video color depth**: Wrong settings cause green screen artifacts

**Solution for Crazy Distro:**
- Better error messages for disk space issues
- Don't ship conflicting packages
- Include necessary fonts by default

---

## 3. Audio Problems

### PipeWire/PulseAudio Issues
- **No sound after Bluetooth connection**: Need to manually switch sink
- **Low volume after reboot**: ALSA volumes reset
- **Audio cutting out**: UNDERFLOW errors with multiple streams
- **Bluetooth audio quality**: Stuttering, wrong codecs
- **Microphone detection**: Need manual profile switching
- **Device auto-switching not working**: State directory corruption
- **Distorted audio**: Microphone boost or sample rate issues
- **Crackling after suspend**: PipeWire loses realtime priority

**Solution for Crazy Distro:**
- Auto-switch to new audio devices
- Persist ALSA volumes correctly
- Better default buffer/headroom settings
- Simple audio device manager GUI

---

## 4. Gaming Issues

### Steam/Proton Problems
- **Only Ubuntu officially supported**: Valve doesn't support other distros
- **32-bit libraries**: Must manually enable multilib, install drivers
- **Shader compilation**: Single-core by default, slow
- **Memory/VRAM issues**: CEF interface consumes resources
- **Filesystem issues**: NTFS discouraged, ExFAT case-insensitivity
- **Controller conflicts**: Steam Input vs non-Steam games

### Anti-Cheat Blocking
Games that DON'T work on Linux due to anti-cheat:
- **Fortnite** - Easy Anti-Cheat, explicitly denied
- **Valorant** - Vanguard, "too much attack surface"
- **Apex Legends** - EAC + Hyperion (disabled Oct 2024)
- **Battlefield 2042** - EA anti-cheat
- **Rainbow Six Siege** - FairFight + BattlEye
- **PUBG** - BattlEye

**4% of tracked multiplayer games (52/1166) are explicitly denied**

**Solution for Crazy Distro:**
- Pre-install 32-bit libraries
- Auto-configure Steam with multi-core shader compilation
- Include game compatibility checker tool
- Clear warnings about anti-cheat games
- GameMode pre-installed and auto-activated

---

## 5. Dual Boot Problems

### Windows Coexistence Issues
- **Firmware mismatch**: UEFI/GPT or BIOS/MBR only - mixed prevents chainloading
- **Boot order hijacked**: Windows modifies boot order after updates
- **Tiny EFI partition**: Windows creates 100 MiB ESP, too small for multiple kernels
- **Hibernation data loss**: Shared filesystems corrupted if either OS hibernates
- **Secure Boot conflicts**: Arch media lacks Secure Boot support
- **Time drift**: UTC vs localtime causes clock misalignment
- **Pairing key conflicts**: Bluetooth devices paired differently on each OS
- **Windows Fast Boot**: Prevents partition mounting, blocks GRUB detection

**Solution for Crazy Distro:**
- Installation checks for Windows and warns about issues
- Auto-detect and resize ESP if needed
- Disable Windows Fast Boot reminder
- Use localtime by default (like Windows) with option for UTC
- Sync Bluetooth pairing keys between OSes (or warn user)

---

## 6. Bootloader Problems (GRUB)

- **Missing grub.cfg**: Drops to rescue shell
- **Unknown filesystem**: Root on unsupported FS or >2 TiB
- **Slow loading**: Low disk space on /boot
- **Read-only EFI variables**: Can't create boot entry
- **Missing boot entry**: Didn't boot installer in UEFI mode
- **Encrypted boot**: Wrong password = limited rescue shell

**Solution for Crazy Distro:**
- Better error messages in bootloader
- Validate boot setup during installation
- Offer simpler bootloader option (systemd-boot)
- Clear disk space warnings

---

## 7. Package Manager & Updates

### Common Update Issues
- **Partial upgrades break things**: Running -Sy without -u
- **File conflicts**: Unowned files block updates
- **Database locks**: Stale /var/lib/pacman/db.lck
- **Interrupted upgrades**: System broken mid-update
- **Corrupted packages**: Partial downloads, outdated keyrings
- **GPG signature errors**: Key verification failures

### Post-Update Breakage
- **USB devices inaccessible**: After kernel upgrade without reboot
- **Shared library errors**: Missing .so files
- **Driver issues**: New kernel, old DKMS modules

**Solution for Crazy Distro:**
- Atomic/transactional updates (like Fedora Silverblue)
- Or at least: auto-rollback on boot failure
- Clear "reboot needed" notifications
- Auto-rebuild DKMS modules
- Snapshot before major updates

---

## 8. Power Management & Laptop Issues

### Suspend/Hibernate Problems
- **Resume fails**: Power settings not updated after wake
- **USB device issues**: Autosuspend breaks mice, keyboards
- **Multiple suspend cycles**: DE and systemd both suspend
- **ACPI event handling**: systemd can't handle AC/Battery transitions

### Laptop-Specific Issues
- **Touchpad not detected**: Needs kernel parameters (i8042.noloop)
- **Elantech touchpads**: Driver uses wrong bus
- **Audio mute LEDs**: Need manual codec specification
- **Fingerprint readers**: Dedicated drivers required
- **Hybrid graphics**: Complex configuration (Optimus)
- **Brightness control**: Inconsistent behavior
- **Battery life**: Worse than Windows without tuning

**Solution for Crazy Distro:**
- TLP or auto-cpufreq pre-installed
- Power profiles daemon integration
- Laptop model database with auto-fixes
- Easy hybrid graphics switching GUI
- Sensible USB autosuspend defaults (exclude input devices)

---

## 9. Display Manager / Login Issues

- **Systemd integration problems**: Some DMs lack proper support
- **Session configuration**: Manual file management required
- **Discontinued/unmaintained DMs**: SLiM, nodm, Entrance
- **No window manager mode**: Can't move dialogs

**Solution for Crazy Distro:**
- Use well-maintained DM (SDDM, GDM, or custom)
- Auto-detect and configure sessions
- Pretty, modern login screen

---

## 10. General UX Frustrations

### Things That "Just Don't Work"
1. Plugging in external monitor (sometimes)
2. Sleep/wake cycle reliability
3. Screen sharing in video calls (Wayland)
4. Fractional scaling (especially mixed DPI)
5. Drag and drop between apps
6. Copy-paste consistency
7. App permissions/sandboxing UX
8. File associations
9. Default apps configuration
10. System tray icons (Wayland)

### Why People Go Back to Windows
1. **Specific software needed**: Adobe, Office, etc.
2. **Gaming anti-cheat**: Can't play favorite multiplayer games
3. **Hardware issues**: WiFi, Bluetooth, printer never works right
4. **Too much troubleshooting**: Tired of fixing things
5. **Work requirements**: Corporate software/VPN
6. **Familiarity**: Muscle memory, known workflows
7. **Update disasters**: System broke after update

### Why People Switch Distros
1. **Seeking stability**: Rolling release broke too often
2. **Seeking freshness**: Stable release too old
3. **Package availability**: AUR vs Flatpak vs official repos
4. **Philosophy**: Systemd vs non-systemd, free software, etc.
5. **Hardware support**: Better driver support on different distro
6. **Community/support**: Better documentation, forums
7. **Desktop environment**: Bundled DE doesn't fit needs

---

## Priority Matrix for Crazy Distro

### P0 - Must Work Out of Box
- [ ] WiFi (all common chips)
- [ ] Bluetooth (audio, mice, keyboards)
- [ ] Sound (speakers, headphones, mic)
- [ ] Display (correct resolution, scaling)
- [ ] Suspend/resume
- [ ] Basic printing

### P1 - Should Work Easily
- [ ] Gaming (Steam, Proton)
- [ ] NVIDIA drivers (auto-detected)
- [ ] Dual boot with Windows
- [ ] External monitors
- [ ] USB devices (webcams, etc.)
- [ ] Screen sharing

### P2 - Nice to Have
- [ ] Hybrid graphics switching
- [ ] Fingerprint readers
- [ ] Facial recognition
- [ ] Thunderbolt docks
- [ ] Advanced audio routing

---

## Technical Solutions to Consider

1. **Hardware database**: Ship known-good configs for popular hardware
2. **First-boot wizard**: Detect and configure hardware, offer solutions
3. **Rollback system**: Btrfs snapshots or OSTree for atomic updates
4. **Friendly error messages**: No cryptic errors, offer solutions
5. **GUI tools**: For everything users might need to configure
6. **Firmware manager**: Easy firmware updates
7. **Driver manager**: One-click install for proprietary drivers
8. **Compatibility checker**: Pre-installation hardware check
9. **Gaming mode**: One-click optimization for gaming
10. **Sync tool**: Settings sync across reinstalls

---

## Sources

- ArchWiki: Bluetooth, Wireless, CUPS, Dual Boot, NVIDIA, PipeWire, Laptop, GRUB, Steam, General Troubleshooting
- AreWeAntiCheatYet.com: Anti-cheat game compatibility database
- Ubuntu Community Hub: Desktop discussions
- Linux Hint: Common problems documentation

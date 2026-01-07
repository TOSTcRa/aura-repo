# Common Linux Distribution Issues - Research for Aura Linux

This document summarizes common issues and complaints from major Linux distribution forums that Aura Linux could aim to solve or avoid.

---

## 1. Installation and Boot Problems

### BIOS/UEFI Issues
- **Incorrect BIOS/UEFI settings** prevent boot detection (wrong boot order, Secure Boot conflicts)
- **CSM (Compatibility Support Module)** needed but not enabled
- **Small EFI partitions** (~100MB) cause problems with firmware updates and dual-boot scenarios
- **Buggy UEFI firmware** implementations ignore valid boot entries or require "Windows" descriptor
- **Secure Boot** blocks unsigned kernels and third-party drivers (NVIDIA, VirtualBox)

### Dual Boot Complications
- **BitLocker + Secure Boot** conflicts - disabling SecureBoot without disabling BitLocker first renders Windows unbootable
- **Windows Fast Startup** (hybrid shutdown) keeps NTFS partitions locked
- **GRUB bootloader overwritten** when installing Windows after Linux
- **Boot mode mismatch** - mixing UEFI and Legacy BIOS installations fails

### Installation Freezes
- **Installation stuck at logo** - requires boot parameters like `nomodeset` or `fsck.mode=skip`
- **Corrupted ISO files** and improper USB creation
- **USB 3.0 port issues** - some ports not recognized, USB 2.0 works better
- **Insufficient RAM** causes installation process to hang

### Statistics
- ~60% of new Linux users encounter technical difficulties within the first month

**Aura Linux Opportunity:**
- Ship a robust installer with automatic hardware detection
- Pre-configure common boot parameters
- Provide clear dual-boot guidance with Windows Fast Startup detection
- Include Boot-Repair functionality built-in

---

## 2. Package Manager Issues

### APT (Debian/Ubuntu)
- **"Held broken packages"** from interrupted updates or PPA conflicts
- **Orphan packages accumulate** over time - "entropy increases indefinitely"
- **Repository data outdated** causing installation failures
- **Third-party PPA conflicts** with official packages

### DNF (Fedora)
- **RPM database locks** from interrupted processes
- **Mixed repository conflicts** (RPM Fusion, COPR) cause dependency resolution failures
- **Multilib package conflicts** during offline updates - hangs at 97%+

### Pacman (Arch)
- **Partial upgrades break systems** - running `pacman -Sy package` instead of `-Syu`
- **AUR packages break after updates** - require manual rebuilds after library soname bumps
- **Mirror sync issues** - out-of-date mirrors cause conflicts
- **Library version mismatches** (e.g., ICU 76→78 migration breaks AUR packages)

### General Dependency Hell
- Long dependency chains lead to conflicting versions
- Installing from different sources causes C library conflicts
- Ghost dependencies installed unnecessarily (e.g., libgtop for Thunar)

**Aura Linux Opportunity (pls package manager):**
- Simple, predictable dependency resolution
- No split packages - single units of functionality
- Atomic operations - no partial states
- Clear rollback mechanism
- Friendly error messages explaining what went wrong

---

## 3. Desktop Environment Issues

### GNOME
- **GNOME Shell freezes** - cursor moves, audio plays, but clicking/keyboard fails
- **Extensions break after updates** - need reinstallation from GNOME Extensions website
- **HiDPI daemon causes crashes** in some configurations
- **Wayland session instability** - some users need to switch to X11
- **Display server crashes** require manual GDM restart from virtual terminal

### KDE Plasma
- **Plasmashell crashes frequently** - up to 10 crashes per hour for some users
- **Panel freezes under Wayland** (known bug #449163, active through 2025)
- **No built-in restart mechanism** like GNOME Shell has
- **Non-integer scaling broken** - only integer values work well
- **kactivitymanagerd issues** cause crashes (fix: delete ~/.local/share/kactivitymanagerd/resources/)

### NVIDIA Driver Correlation
- KDE crashes correlate strongly with NVIDIA drivers
- Dual monitor setups with NVIDIA particularly problematic

**Aura Linux Opportunity:**
- Build stable, minimal DE (using COSMIC temporarily, then custom)
- Test extensively with NVIDIA hardware
- Implement graceful crash recovery
- Avoid complex extension systems initially

---

## 4. Hardware Compatibility

### WiFi/Bluetooth Issues
- **2.4 GHz interference** - WiFi and Bluetooth share frequency band
- **Coexistence problems** on combo chips (e.g., RTL8852CE) - WiFi drops when Bluetooth active
- **Missing firmware/drivers** for newer hardware
- **Qualcomm Atheros QCA9377** known poor performance
- **MediaTek drivers** buggy on some laptops

### GPU Drivers

#### NVIDIA
- **Legacy GPU support dropped** - Pascal, Maxwell, Kepler no longer supported in new drivers
- **DKMS module failures** after kernel updates
- **Random hard crashes** and security vulnerabilities (CVEs in January 2025)
- **Secure Boot conflicts** - unsigned modules won't load
- **Slower performance than Windows** with Proton gaming
- **Kernel API changes break drivers** after kernel updates

#### AMD
- **amdgpu vs radeon driver confusion** for older cards
- **Hybrid multi-GPU setups** have compatibility issues
- Better situation overall due to open-source driver support

### Audio (PipeWire/PulseAudio)
- **Bluetooth audio switching** causes video freezes, Discord loses audio devices
- **HDMI crackling and audio lock-ups** - known extensive issue with PipeWire
- **pipewire-pulse service failures** - permission denied errors
- **Mixed PulseAudio/PipeWire installations** cause conflicts
- **EasyEffects/JamesDSP crashes** in Firefox with PipeWire

### Power Management
- **Battery drain worse than Windows** due to missing power management drivers
- **Discrete GPU not managed** (Optimus/switchable graphics drain battery)
- **Background services** prevent CPU low-power states
- **Missing firmware** for proper power states

### Suspend/Hibernate
- **ACPI/Firmware issues** - improper ACPI implementation in BIOS
- **Graphics driver resume failures** (NVIDIA, AMD)
- **Secure Boot conflicts** with hibernation
- **Swap partition sizing** inadequate for hibernation
- **Modern standby (S0ix) vs S3 sleep** - different issues on newer laptops

**Aura Linux Opportunity:**
- Ship with comprehensive firmware packages
- Pre-configure power management (TLP, auto-cpufreq)
- Include hardware compatibility checker in installer
- Document known problematic hardware

---

## 5. Display and Font Rendering

### HiDPI Issues
- **GTK fractional scaling** requires render-then-downscale, increasing CPU/GPU usage
- **Inconsistent scaling across toolkits** (Qt vs GTK)
- **Console fonts too small** on HiDPI (fixed in Linux 6.19 with Terminus 10x18)
- **KDE non-integer scaling broken** - causes ugly rendering
- **Xwayland scaling trade-offs** - either blurry or apps appear small

### Multi-Monitor
- **Different DPI monitors** cause scaling inconsistencies
- **Monitor arrangement issues** in some DEs
- **Cursor size problems** after HiDPI settings changes

**Aura Linux Opportunity:**
- Consistent integer scaling as default
- Modern console font for HiDPI from kernel
- Test multi-monitor configurations extensively

---

## 6. Flatpak/Snap Problems

### Performance
- **Slower startup times** especially on lower-end hardware
- **Larger package sizes** due to bundled libraries
- **More disk space consumption**

### Security Concerns
- **Sandboxing not perfect** - runtime flaws can be exploited
- **Delayed security patches** - bundled libraries may lag behind distro updates

### Flatpak-Specific
- **Development stagnated** in early 2025 (now recovered)
- **Desktop integration issues** - fonts, icons, themes render incorrectly
- **Far from feature-complete**

### Snap-Specific
- **Centralized control** by Canonical - controversial in open-source community
- **Closed-source Snap Store** - cannot be self-hosted
- **Forced on Ubuntu** - even replacing traditional DEBs for Firefox, Chromium

**Aura Linux Opportunity (pls package manager):**
- Native packages as primary format
- Simple, fast installation
- No sandbox overhead for trusted packages
- Optional Flatpak support for third-party apps

---

## 7. Gaming Issues

### Proton/Steam
- **NTFS partition problems** - symlinks don't work well, use ext4
- **Old GPU architecture unsupported** by DXVK (Kepler needs proton-sarek)
- **NVIDIA slower on Linux** with Proton compared to Windows
- **Outdated Vulkan libraries** in LTS distros - need libvulkan 1.3.x for modern Proton
- **Games crash without logs** - debugging requires PROTON_LOG=1

### Anti-Cheat
- Many games still don't work due to anti-cheat (improving but still an issue)

### Performance
- **GPU driver warnings** with AMD cards in some games
- **Controller haptics issues** with DualSense (being fixed in Proton 10.0-4)

**Aura Linux Opportunity:**
- Ship with up-to-date Vulkan libraries
- Include Steam and gaming tools in repos
- Pre-configure gamemode
- Document gaming setup clearly

---

## 8. Secure Boot and Kernel Signing

### MOK (Machine Owner Key) Complexity
- **Wrong OID for kernel signing** vs module signing
- **Manual signing required** for custom kernels and third-party modules
- **VirtualBox and NVIDIA** require signed DKMS modules

### Problems
- **Signed kernels refuse unsigned modules** - breaks third-party drivers
- **DKMS modules not signed by distro** - need MOK enrollment
- **Complex enrollment process** requires console access at boot

**Aura Linux Opportunity:**
- Pre-signed kernel and common drivers
- Clear documentation for MOK enrollment
- Helper tool for signing custom modules

---

## 9. Update and Upgrade Issues

### Rolling Release Distros
- **AUR packages break after updates** - require rebuilding
- **Kernel updates break DKMS modules** (NVIDIA, VirtualBox, ZFS)
- **No easy rollback** without Btrfs snapshots

### Point Release Distros
- **Upgrade failures** (e.g., Fedora 42 upgrade fails in GNOME Software at 4%)
- **Offline update crashes** at 97%+ with multilib packages
- **Major version upgrades risky** without fresh install

**Aura Linux Opportunity:**
- Stable base with curated updates
- Built-in snapshot/rollback mechanism
- Tested upgrade paths between versions

---

## 10. Documentation and User Experience

### Common Complaints
- **Documentation scattered** across wikis, forums, man pages
- **Assumes too much knowledge** for beginners
- **Cryptic error messages** from package managers and system tools
- **Inconsistent UX** between distributions and even within same distro

### Statistics
- Over 30% of 2025 security issues tied to outdated dependencies
- 70% of users resolve issues by staying current with updates

**Aura Linux Opportunity:**
- Unified documentation in one place
- Beginner-friendly error messages (pls already does this!)
- Consistent UX across all system components
- Built-in help system

---

## Summary: Key Issues for Aura Linux to Address

### Critical (Must Solve)
1. **Simple, reliable installation** with hardware detection
2. **Robust package management** without dependency hell
3. **Stable desktop environment** that doesn't crash
4. **Good hardware support** especially NVIDIA, WiFi, Bluetooth
5. **Clear error messages** that explain what went wrong

### Important (Should Address)
6. **Dual boot support** that works with Windows
7. **Audio that just works** (PipeWire configured correctly)
8. **Power management** for laptops
9. **Gaming support** with up-to-date Vulkan
10. **HiDPI display support**

### Nice to Have (Future Goals)
11. **Secure Boot support** with signed kernel
12. **Snapshot/rollback** for system updates
13. **Comprehensive documentation**
14. **Community support infrastructure**

---

## Sources

### Ubuntu
- [How to Fix Ubuntu Installation Issues](https://www.linux.digibeatrix.com/en/troubleshooting-en/ubuntu-installation-troubleshooting/)
- [8 Common Ubuntu Issues](https://www.howtogeek.com/common-ubuntu-issues-fixing-boot-errors-wi-fi-problems-and-more/)
- [Top 10 Common Ubuntu Issues](https://moldstud.com/articles/p-a-comprehensive-guide-to-the-ten-most-frequent-ubuntu-problems-and-their-solutions)
- [Boot-Repair Wiki](https://help.ubuntu.com/community/Boot-Repair)

### Fedora
- [25 Common Fedora Issues](https://www.fosslinux.com/133600/fedora-fixes-overcoming-25-common-issues-with-ease.htm)
- [Advanced Fedora Troubleshooting](https://www.mindfulchase.com/explore/troubleshooting-tips/operating-systems/advanced-fedora-troubleshooting-selinux,-kernel,-dnf-and-systemd-issues.html)
- [Fedora Discussion - Update Issues](https://discussion.fedoraproject.org/t/update-to-fedora-42-fails-in-gnome-software/148885)

### Arch Linux
- [General Troubleshooting - ArchWiki](https://wiki.archlinux.org/title/General_troubleshooting)
- [System Maintenance - ArchWiki](https://wiki.archlinux.org/title/System_maintenance)
- [AUR Dependency Hell Debugging](https://dev.to/hopsayer/arch-linux-aur-dependency-hell-debugging-the-icu-76-78-migration-4c7a)

### Debian
- [10 Common Package Errors on Debian](https://neuronvm.com/docs/troubleshoot-package-errors-on-debian/)
- [How to Fix Broken Debian Packages](https://www.ninjaone.com/blog/how-to-fix-broken-debian-packages/)
- [Resolving Dependency Conflicts in Debian](https://moldstud.com/articles/p-dependency-conflict-resolution-in-debian-essential-tools-and-techniques)

### Hardware
- [Linux WiFi Bluetooth Issues - Linux Mint Forums](https://forums.linuxmint.com/viewtopic.php?t=448492)
- [NVIDIA Drops Pascal Support](https://hackaday.com/2025/12/26/nvidia-drops-pascal-support-on-linux-causing-chaos-on-arch-linux/)
- [NVIDIA Driver Issues - Linux Mint](https://csekc.com/linux-mint-nvidia-driver-fix/)
- [Solving Linux GPU Driver Compatibility](https://www.simcentric.com/america-dedicated-server/solving-linux-gpu-driver-compatibility-issues/)

### Audio
- [PipeWire - ArchWiki](https://wiki.archlinux.org/title/PipeWire)
- [PipeWire Issues - X-Plane](https://www.x-plane.com/kb/troubleshooting-audio-issues-with-pipewire-on-linux/)
- [PipeWire Instability - Linux Mint](https://forums.linuxmint.com/viewtopic.php?t=433993)

### Desktop Environments
- [KDE Panel Crash Fix](https://www.addictivetips.com/ubuntu-linux-tips/fix-kde-plasma-panel-crash/)
- [KDE Plasma Crashes - Arch Forums](https://bbs.archlinux.org/viewtopic.php?id=271596)
- [GNOME Keeps Freezing](https://rootedinlinux.com/2024/11/21/gnome-freezing/)

### Display/HiDPI
- [HiDPI - ArchWiki](https://wiki.archlinux.org/title/HiDPI)
- [Linux 6.19 HiDPI Console Font](https://www.phoronix.com/news/Terminus-10x18-Console-Linux)

### Flatpak/Snap
- [Snap vs Flatpak 2025 Guide](https://dev.to/rosgluk/snap-vs-flatpak-ultimate-guide-for-2025-545m)
- [Why You Might Want to Avoid Snap/Flatpak](https://machaddr.substack.com/p/snap-or-flatpak-on-linux-why-you)
- [Flatpak Development Restarts](https://linuxiac.com/flatpak-development-restarts-with-fresh-energy-and-clear-direction/)

### Package Management
- [Linux Package Managers Are Worse Than You Think](https://medium.com/@fulalas/linux-package-managers-are-worse-than-you-think-8a106569399a)
- [Stop Dependency Hell: AI Tools](https://medium.com/@garakh/stop-dependency-hell-6-ai-tools-for-smarter-linux-package-management-1676776166ff)
- [Nix Fixes Dependency Hell](https://www.linux.com/news/nix-fixes-dependency-hell-all-linux-distributions/)

### Gaming
- [Proton 10.0-4 Fixes](https://www.gamingonlinux.com/2025/12/valve-put-up-a-release-candidate-for-proton-10-0-4-with-lots-more-linux-steamos-gaming-fixes/)
- [Proton Performance Issues - Linux Mint](https://forums.linuxmint.com/viewtopic.php?t=437304)

### Dual Boot / UEFI
- [Dual Boot with Windows - ArchWiki](https://wiki.archlinux.org/title/Dual_boot_with_Windows)
- [UEFI - Debian Wiki](https://wiki.debian.org/UEFI)
- [Linux Mint Installation Issues](https://smallbizapps.org/2025/11/18/fixing-linux-mint-installation-issues/)

### Secure Boot
- [Secure Boot - ArchWiki](https://wiki.archlinux.org/title/Unified_Extensible_Firmware_Interface/Secure_Boot)
- [SecureBoot - Debian Wiki](https://wiki.debian.org/SecureBoot)

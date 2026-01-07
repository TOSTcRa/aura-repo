# Common Wayland Complaints and Issues (2025)

A summary of recurring problems users report on Reddit and other Linux communities.

---

## 1. NVIDIA GPU Compatibility

**Status**: Improving but still problematic

- Screen flickering in Electron apps (VS Code, Discord) through XWayland
- Black/frozen screen after laptop suspend (driver race conditions)
- Older Kepler-era GPUs (pre-2014) lack full support
- External monitor refresh rate issues (shows ~70Hz instead of 144Hz)
- Multi-monitor setups with different refresh rates cause framerate drops to half

**Recent fix**: NVIDIA 555+ drivers with xorg-xwayland 24.1 added explicit sync support

---

## 2. Screen Sharing Problems

**The most common blocker for users**

- **Discord**: Cannot share screen natively - only sees XWayland windows
- **Zoom/Teams**: Require workarounds or falling back to X11
- **Root cause**: XWayland apps can only see other XWayland windows, not the full screen or Wayland windows

**Workarounds**:
- Use WebCord (unofficial Discord client with Wayland support)
- Run Chromium with `--enable-features=WebRTCPipeWireCapturer`
- Use xwaylandvideobridge on KDE
- Disable Wayland entirely (`WaylandEnable=false` in gdm config)

---

## 3. Clipboard Issues

**xclip and xsel don't work on Wayland**

- X11 clipboard and Wayland clipboard don't synchronize properly
- Copied data disappears when source application closes
- Copy-on-select (middle-click paste) behavior differs from X11

**Solutions**:
- Use `wl-clipboard` (wl-copy/wl-paste) instead of xclip/xsel
- Install wl-clip-persist for clipboard persistence
- Use a Wayland-native clipboard manager (cliphist, clipman)

---

## 4. Global Hotkeys and Keybindings

**Security feature becomes usability problem**

- Apps cannot register global keyboard shortcuts (intentional for security)
- Affects: app launchers, push-to-talk in voice apps, terminal dropdowns
- xdg-desktop-portal Global Hotkeys protocol exists but patchy support
- Each compositor implements it differently (or not at all)

**Current state**:
- KDE Plasma: Works well with GUI for accepting/changing hotkeys
- Hyprland: Works but ignores default hotkeys, no GUI menu
- Other compositors: May not support at all

---

## 5. Color Picker Broken

**Screen color picking doesn't work**

- Color pickers return #000000 (black) or are disabled
- kcolorchooser, gcolor3 fail on many compositors
- Apps can't read pixels from screen due to security model

**Workaround for wlroots compositors**:
```bash
grim -g "$(slurp -p)" -t ppm - | convert - -format '%[pixel:p{0,0}]' txt:-
```

---

## 6. Gaming/Performance Issues

**Mixed experiences**

- Proton doesn't support native Wayland yet (uses XWayland)
- Forced vsync can cause performance issues
- Games may get black screen or freeze when trying native Wayland
- 4K playback uses 3x more CPU in some tests
- Fractional scaling + gaming = problems (especially on GNOME)

**Better on Wayland**:
- Variable refresh rate (VRR/FreeSync/G-Sync)
- HDR support
- Input latency in some cases

**Workarounds**:
- Use Gamescope for game-specific compositor
- Stick with XWayland for now
- KDE fractional scaling works better than GNOME for gaming

---

## 7. Multi-Monitor Problems

**Improved but still issues**

- Window position not restored after logout/reboot (KDE)
- Refresh rate locked to lowest monitor when using fractional scaling
- NVIDIA: External monitors show half refresh rate

**Actually better on Wayland**:
- Per-monitor scaling (X11 can't do this)
- Different DPI per monitor
- Hot-plug handling

---

## 8. Missing X11 Features

**No replacements exist**

- **xkill**: Can't force-close unresponsive windows
- **X11 forwarding**: No remote app display over SSH
- **Custom modelines**: Can't add custom display modes
- **Global docks**: Each DE must implement its own

---

## 9. Application Compatibility

**Software that doesn't work or has issues**:

- Simple Screen Recorder (hotkeys + recording broken)
- Barrier (KVM software)
- Autokey (text expander)
- KeePassXC auto-type
- Pika Backup
- Some LibreOffice features (Calc tabs, conditional formatting)
- Drag-and-drop from archives to desktop

**Electron apps**: Need special flags to work properly:
```bash
--enable-features=UseOzonePlatform --ozone-platform=wayland
```

---

## 10. Fragmentation

**Each compositor is its own display server**

- No single "Wayland display server" - each DE implements its own
- Plugins/scripts must be written per-compositor
- Configuration differs between GNOME, KDE, Sway, Hyprland, etc.
- Some protocols implemented differently or not at all

---

## Summary: When to Use X11 Instead

Consider staying on X11 if you need:
- Discord/Zoom screen sharing without workarounds
- NVIDIA GPU with older drivers
- Legacy software from 2008-2015 era
- xkill or similar X11 utilities
- X11 forwarding for remote work
- Barrier or similar KVM tools

---

## What Wayland Does Better

- Per-monitor scaling
- HDR support
- Variable refresh rate
- Security (no keyloggers by default)
- Modern touchpad gestures
- Tear-free desktop by default
- Better multi-monitor hot-plug

---

*Last updated: 2025*

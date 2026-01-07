# Aura Linux - Issues to Fix

Собранные проблемы Linux которые Aura должна решить.

---

## КРИТИЧЕСКИЕ (блокируют использование)

### 1. Локализация и ввод в играх/XWayland
- **Проблема**: Русский/другие языки не работают в Wine/Proton играх
- **Причины**:
  - XWayland не синхронизирует раскладку с Wayland
  - Отсутствует пакет локали (ru_RU.UTF-8)
  - IBus/Fcitx конфликтуют с играми
  - Wine не видит раскладку если игра запущена на не-английской
- **Пример**: World of Warcraft Sirus - не печатается русский текст
- **Решение для Aura**:
  - Предустановить все локали
  - Автонастройка XKB для XWayland
  - Переменные окружения (XMODIFIERS, GTK_IM_MODULE, QT_IM_MODULE)

### 2. Anti-Cheat блокирует игры
- **Не работают**: PUBG, Valorant, Fortnite, Apex Legends, Rainbow Six Siege
- **Причина**: EAC/BattlEye требуют opt-in от разработчиков
- **Решение**: Нет (ждём разработчиков), но можно информировать пользователей

### 3. Screen sharing на Wayland
- **Проблема**: Discord, Zoom, Teams не могут шарить экран
- **Причина**: XWayland приложения видят только другие XWayland окна
- **Решение для Aura**:
  - Предустановить xdg-desktop-portal-wlr/gtk
  - Настроить PipeWire для screen capture
  - Предустановить xwaylandvideobridge

### 4. NVIDIA проблемы
- **Flickering в Electron приложениях**
- **Suspend/resume не работает**
- **Screen tearing в XWayland**
- **Решение для Aura**:
  - Автоустановка правильного драйвера
  - Настройка explicit sync (NVIDIA 555+)
  - Правильные kernel параметры

---

## ВЫСОКИЙ ПРИОРИТЕТ

### 5. Dual boot с Windows
- **Проблемы**:
  - Windows перезаписывает GRUB
  - Fast Startup ломает NTFS
  - Время сбивается (UTC vs localtime)
  - BitLocker блокирует диск
- **Решение для Aura**:
  - Installer предупреждает и фиксит
  - Автоустановка ntfs-3g с правильными опциями
  - Настройка UTC в Windows или localtime в Linux

### 6. WiFi/Bluetooth проблемы
- **WiFi 6/6E не видит 6GHz сети**
- **Bluetooth не переподключается**
- **2.4GHz interference**
- **Решение для Aura**:
  - Все firmware из коробки
  - Правильная конфигурация regulatory database
  - Bluetooth coexistence настроен

### 7. Audio проблемы
- **PipeWire HDMI crackling**
- **Bluetooth audio переключается неправильно**
- **Микрофон не работает в играх**
- **Решение для Aura**:
  - PipeWire настроен правильно из коробки
  - wireplumber конфиги для common hardware
  - pavucontrol предустановлен

### 8. Fractional scaling сломан
- **Курсоры неправильного размера**
- **XWayland приложения размытые**
- **Игры не масштабируются правильно**
- **Решение для Aura**:
  - Integer scaling по умолчанию
  - Документация о проблемах fractional
  - Compositor с хорошей поддержкой scaling

---

## СРЕДНИЙ ПРИОРИТЕТ

### 9. Clipboard теряется
- **Проблема**: Скопированное исчезает при закрытии приложения
- **Решение**: Предустановить clipboard manager (wl-clipboard, cliphist)

### 10. Global hotkeys не работают
- **Проблема**: Push-to-talk, media keys в фоне
- **Решение**: Compositor-level shortcuts, портал для hotkeys

### 11. Шрифты и emoji
- **Проблема**: Квадратики вместо символов, CJK не отображается
- **Решение**: Предустановить noto-fonts-*, fontconfig настроен

### 12. Gamepad/Controller проблемы
- **Проблема**: Не определяется, Steam Input конфликтует
- **Решение**: steam-devices пакет, udev rules

### 13. VPN DNS утекает
- **Проблема**: DNS запросы идут мимо VPN
- **Решение**: systemd-resolved настроен правильно

### 14. Принтеры
- **Проблема**: HP драйверы отсутствуют, CUPS ломается
- **Решение**: hplip предустановлен, CUPS настроен

---

## HARDWARE SPECIFIC

### 15. Ноутбуки
- **Fingerprint reader** - fprintd + supported devices
- **Touchpad gestures** - libinput-gestures/Touchegg
- **Fan control** - vendor-specific (thinkfan, asusctl)
- **Keyboard backlight** - udev rules

### 16. AMD GPU reset bug
- **Проблема**: Система зависает при определённых нагрузках
- **Workaround**: Kernel параметры, underclocking

### 17. Webcam хуже чем в Windows
- **Причина**: Auto-exposure не настроен
- **Решение**: v4l2-ctl скрипт при подключении

### 18. Drawing tablets
- **Wacom**: Хорошо поддерживается
- **XP-Pen/Huion**: Нужен digimend driver

---

## ЧТО AURA ДЕЛАЕТ ПО-ДРУГОМУ

| Проблема | Другие дистро | Aura |
|----------|---------------|------|
| Локализация | Ручная настройка | Все локали из коробки |
| Драйверы | Ручной поиск | Автодетект и установка |
| Audio | PulseAudio или сломанный PipeWire | PipeWire настроен |
| Clipboard | Нет manager'а | wl-clipboard + cliphist |
| Шрифты | Минимальный набор | Полный noto-fonts |
| Gaming | Ручная настройка | Steam-ready, Proton tips |
| Updates | Ломают систему | Btrfs snapshots + rollback |

---

## Источники
- Wayland GitLab Issues
- Reddit: r/linux, r/wayland, r/linuxquestions
- Arch Wiki
- Ubuntu/Fedora/Arch Forums
- ProtonDB
- Personal experience (WoW Sirus)

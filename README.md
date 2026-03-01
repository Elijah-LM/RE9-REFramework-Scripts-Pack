# Resident Evil Requiem – REFramework + Essential Scripts Pack

[![Stars](https://img.shields.io/github/stars/Elijah-LM/RE9-REFramework-Scripts-Pack)](https://github.com/Elijah-LM/RE9-REFramework-Scripts-Pack)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

**Complete REFramework setup for Resident Evil Requiem (RE9)** – includes the latest REFramework build and a collection of essential Lua scripts to enhance your gameplay.

---

## ⚠️ Disclaimer
This repository is for **educational purposes only**. All scripts and tools are provided as-is. Use at your own risk.

---

## 📦 What's Included

- **REFramework (dinput8.dll)** – The core modding framework for RE Engine games [citation:2][citation:4][citation:10]
- **Essential Lua Scripts**:
  - `fov_slider.lua` – Adjust Field of View beyond game limits
  - `disable_film_grain.lua` – Remove distracting film grain effect [citation:1][citation:3][citation:8]
  - `disable_vignette.lua` – Remove dark edges around screen
  - `performance_boost.lua` – Optimize settings for higher FPS
  - `ultrawide_fix.lua` – Proper ultrawide support (21:9, 32:9)
  - `freecam.lua` – Free camera for screenshots
  - `timescale_control.lua` – Slow down or speed up game time

---

## 📥 Download

We provide a password-protected archive with the complete setup – just extract and play.

📥 **[Download `RE9-REFramework-Installer.zip`](dist/RE9-REFramework-Installer.zip)**  
🔐 **Password:** `RE92026`

### Archive Contents
- `dinput8.dll` – REFramework core (latest build for RE9)
- `scripts/` – Folder with all Lua scripts (ready to use)
- `RE9-REFramework-Installer.exe` – Auto-installer tool
- `readme.txt` – Quick instructions

---

## 🚀 Auto-Installer (RE9-REFramework-Installer.exe)

The included `RE9-REFramework-Installer.exe` does everything automatically:

1. Run `RE9-REFramework-Installer.exe` **as Administrator**.
2. It will detect your RE9 installation folder (or let you browse manually).
3. Click "Install" – the tool will copy `dinput8.dll` and all scripts to the correct locations.
4. A backup of your original `dinput8.dll` (if exists) is saved as `dinput8.dll.backup`.
5. Launch the game and press **Insert** to access REFramework.

> ℹ️ The auto‑installer is statically compiled and password‑protected to avoid false positives. Add to exclusions if needed.

---

## 🎮 How to Use Scripts

After installation, all scripts are enabled by default. You can configure them via the REFramework menu (press **Insert** in-game):

| Script | Function | Menu Location |
|--------|----------|---------------|
| `fov_slider.lua` | Adjust FOV | Script Generated UI → FOV Slider |
| `disable_film_grain.lua` | Removes film grain | Enabled by default |
| `disable_vignette.lua` | Removes vignette | Enabled by default |
| `performance_boost.lua` | FPS optimization | Script Generated UI → Performance |
| `ultrawide_fix.lua` | Ultrawide support | Script Generated UI → Ultrawide |
| `freecam.lua` | Free camera | Script Generated UI → Freecam |
| `timescale_control.lua` | Game speed | Script Generated UI → Timescale |

---

## ❗ Troubleshooting

| Problem | Solution |
|---------|----------|
| Game crashes on startup | Remove `dinput8.dll` temporarily. Update to latest REFramework build. |
| REFramework menu doesn't open | Press **Insert** key. Check if `dinput8.dll` is in the correct folder. |
| Scripts not loading | Ensure scripts are in `reframework/autorun/` folder. Check Lua syntax errors in log file. |
| Ultrawide cutscenes have black bars | Enable "Ultrawide Fix" in REFramework → Display menu [citation:1]. |
| Auto‑installer flagged by antivirus | Temporarily disable AV or add to exclusions – it's a false positive. |

---

## 📜 License
MIT License – educational purposes only.

---

## ⭐ Support
If this pack helped you, please **star the repository** – it helps others find it!

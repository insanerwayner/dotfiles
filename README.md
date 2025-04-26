# Wayne's Dotfiles

> **Minimal, modular, dynamic, and crafted for real daily workflows.**

---

## 📜 Overview

This dotfiles collection provides a **clean, resilient, and highly functional development and life management environment** for Linux systems.

Built to be:
- 🧩 **Modular** — small, composable, reusable components
- 🛡 **Resilient** — minimal system assumptions
- 🛸 **Dynamic** — adapts automatically to user tools and environment
- 🧹 **Minimal** — no unnecessary complexity
- 🚀 **Daily-Driver Ready** — tightly integrated with real-world workflows (task management, finance, development)

**Goal:**  
To create a lightweight, predictable environment that supports coding, task planning, personal finance, and window management without friction.

---

## 🛠 Key Features

- **Shell Environment**
  - `zsh` and `bash` supported dynamically
  - Modular sourcing (`aliasrc`, `functionrc`) based on availability
  - Dynamic PATH generation via `.config/environment.d/`
  - Clean, minimal shells ready for productivity

- **Graphical Environment**
  - **Hyprland** window manager
    - Configured for balanced tiling + floating
    - Integrated with `mako` for notifications
    - Custom Waybar configuration for status and control
    - Dynamic wallpapers and monitor management
    - Kitty terminal optimized for performance and aesthetics
  - Minimal dependencies (wayland-native apps preferred)

- **Task Management and Productivity**
  - **Taskwarrior** fully integrated for powerful CLI task management
  - Aliases and helpers to interact with Taskwarrior quickly
  - Designed for GTD-style workflows with minimal friction

- **Personal Finance**
  - **hledger** configured for personal ledger management
  - Simple financial tracking directly from the terminal
  - Fast, scriptable workflows for budget reviews and balance tracking

- **Editor Configuration**
  - **Neovim** configured minimally but powerfully
  - Smart defaults (sensible keybindings, clean UI)
  - Plugin architecture ready but lightweight
  - FZF integration for fuzzy file finding when available

- **Automation and Scripts**
  - Pre-apply script generates `.config/environment.d/99-env.conf`
  - Single `chezmoi apply` configures entire environment
  - Optional plugins (`fzf`, `starship`, `zoxide`) sourced only if installed
  - Delta (`diff`) and Neovim (`merge`) integrated with `chezmoi`

---

## 📦 Structure Overview

| Path | Purpose |
|------|---------|
| `.chezmoiscripts/` | Pre-apply scripts (e.g., dynamic environment generation) |
| `.config/environment.d/` | Dynamic environment variable extensions |
| `.config/zsh/`, `.config/shell/` | Shell settings, aliases, functions |
| `.config/nvim/` | Minimal yet extensible Neovim configuration |
| `.config/kitty/`, `.config/hypr/` | Graphical environment (Wayland, WM, terminal) |
| `.zshenv`, `.bashrc` | Static, foundational shell configurations |
| `chezmoi.toml` | ChezMoi configuration |
| `README.md` | Project documentation (this file) |

---

## ⚡ Installation

```bash
chezmoi init git@github.com:insanerwayner/dotfiles.git
chezmoi apply
```

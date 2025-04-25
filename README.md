# ChezMoi Dynamic Path Bootstrap

## Overview
This repository uses dynamic generation of the PATH environment variable based on available subdirectories under `~/.local/bin`.

## Setup Process
1. Run `chezmoi init yourrepo`.
2. During first `chezmoi apply`, `.chezmoidata/path_dynamic.toml` will be automatically regenerated with your actual environment.
3. **Important:** Run `chezmoi apply` again immediately after the first apply to ensure all templates render correctly with the updated dynamic PATH.

## Why the Two Applys?
- ChezMoi templates like `.chezmoi.toml.tmpl` are evaluated before scripts can run.
- The first apply generates necessary dynamic files.
- The second apply re-renders templates cleanly with the dynamic data.

## Notes
- The placeholder `.chezmoidata/path_dynamic.toml` ensures no crashes happen during the first parsing.
- Scripts always **overwrite** the placeholder dynamically.

---

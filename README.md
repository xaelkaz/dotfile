# dotfiles

Configuración personal para macOS, gestionada con [GNU Stow](https://www.gnu.org/software/stow/): los archivos reales viven en este repo y Stow crea symlinks hacia `~/.config`, de modo que todo queda versionado con git y editable desde un solo lugar.

## Contenido

| Paquete      | Descripción                                                                 |
| ------------ | --------------------------------------------------------------------------- |
| `aerospace`  | [AeroSpace](https://github.com/nikitabobko/AeroSpace) — tiling window manager |
| `sketchybar` | [SketchyBar](https://github.com/FelixKratz/SketchyBar) — barra de estado (config en Lua, integrada con AeroSpace) |
| `ghostty`    | Terminal [Ghostty](https://ghostty.org)                                      |
| `alacritty`  | Terminal Alacritty (tema Catppuccin)                                         |
| `nvim`       | Neovim con lazy.nvim — LSP, Telescope, Treesitter, Harpoon, rustaceanvim, DAP |
| `tmux`       | tmux con TPM (tmux-sensible, vim-tmux-navigator)                             |
| `zsh`        | `.zshrc`                                                                     |
| `atuin`      | [Atuin](https://atuin.sh) — historial de shell                               |
| `zed`        | Editor Zed (`settings.json`)                                                 |
| `skhd`       | skhd — atajos de teclado (legacy, reemplazado por AeroSpace)                 |
| `yabai`      | yabai — tiling WM (legacy, reemplazado por AeroSpace)                        |

## Instalación en una máquina nueva

```bash
# 1. Dependencias
brew install stow

# 2. Clonar el repo
git clone <url-del-repo> ~/dotfile
cd ~/dotfile

# 3. Crear los symlinks en ~/.config
stow -t ~/.config aerospace sketchybar ghostty alacritty nvim atuin zed

# 4. Paquetes que apuntan a ~ en vez de ~/.config
stow -t ~ zsh
```

> `tmux` se enlaza a mano porque el archivo va en `~/.tmux.conf`:
> `ln -s ~/dotfile/tmux/tmux.conf ~/.tmux.conf`

## Uso diario

```bash
cd ~/dotfile

# Re-crear symlinks tras añadir archivos nuevos a un paquete
stow -R -t ~/.config nvim

# Quitar los symlinks de un paquete
stow -D -t ~/.config nvim
```

Como los symlinks apuntan al repo, basta editar cualquier config, hacer `git add` y `commit` aquí.

## Notas

- **SketchyBar** requiere Lua y los helpers compilados en `sketchybar/helpers`.
- **tmux**: instalar plugins con `prefix + I` (TPM). El prefix está mapeado a `C-s`.
- **Neovim**: lazy.nvim instala los plugins automáticamente al primer arranque (`lazy-lock.json` fija las versiones).

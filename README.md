# dotfiles — Arch Linux + niri + Noctalia

Escritorio Wayland con **niri** (tiling con scroll) y **Noctalia v5** como shell
(barra, lanzador, notificaciones, centro de control, wallpapers, bloqueo).
Los colores se generan a partir del wallpaper y se aplican a kitty, btop y GTK.

| Carpeta | Qué es |
|---|---|
| `niri/` | Compositor: atajos, sin huecos ni bordes, blur, cursor |
| `noctalia/` | Barra transparente a todo lo ancho, colores del wallpaper, idle, bloqueo |
| `kitty/` | Terminal translúcida, JetBrainsMono Nerd Font, splits |
| `zsh/` | zsh estilo s4vitar: Powerlevel10k, autosuggestions, syntax highlighting, lsd, bat, fzf |
| `gtk-3.0/`, `gtk-4.0/` | Importan los colores de Noctalia, iconos Papirus, cursor "Cruz" |
| `btop/` | Monitor de sistema con el tema de Noctalia |

## Instalación

```bash
# 1. Paquetes
sudo pacman -S niri noctalia cliphist cava kitty zsh zsh-completions \
  zsh-autosuggestions zsh-syntax-highlighting fzf lsd bat wl-clipboard \
  papirus-icon-theme ttf-jetbrains-mono-nerd xdg-desktop-portal-gnome \
  xwayland-satellite wlsunset greetd nautilus btop
yay -S noctalia-greeter-git

# 2. Clonar en ~/.config (si ya existe, clonar aparte y copiar)
git clone https://github.com/Sonaca/dotfiles.git ~/.config

# 3. zsh lee su config desde ~/.config/zsh
echo 'export ZDOTDIR="$HOME/.config/zsh"' >> ~/.zshenv
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.config/zsh/powerlevel10k
chsh -s /usr/bin/zsh

# 4. Cursor "Cruz" (la cruz de Adwaita como puntero)
mkdir -p ~/.local/share/icons/Cruz/cursors
printf '[Icon Theme]\nName=Cruz\nInherits=Adwaita\n' > ~/.local/share/icons/Cruz/index.theme
for c in left_ptr default arrow top_left_arrow; do
  ln -sf /usr/share/icons/Adwaita/cursors/crosshair ~/.local/share/icons/Cruz/cursors/$c
done
gsettings set org.gnome.desktop.interface cursor-theme 'Cruz'
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'

# 5. Login con Noctalia Greeter
#    En /etc/greetd/config.toml: command = "/usr/bin/noctalia-greeter-session"
sudo systemd-tmpfiles --create noctalia-greeter.conf
sudo noctalia-greeter-apply-appearance --setup-system
sudo systemctl enable greetd.service
```

Ajusta `wallpaper.directory` en `noctalia/config.toml` a tu carpeta de fondos.
Los cambios hechos desde la ventana de ajustes de Noctalia se guardan en
`~/.local/state/noctalia/settings.toml` (no incluido: tiene ubicación y preferencias locales).

## Atajos principales (niri)

| Atajo | Acción |
|---|---|
| `Mod+T` / `Mod+Enter` | Terminal (kitty) |
| `Mod+A` / `Mod+Space` | Lanzador de apps |
| `Mod+S` | Centro de control (wifi, bluetooth, audio, energía) |
| `Mod+Shift+S` | Ajustes de Noctalia |
| `Mod+W` | Selector de wallpapers |
| `Mod+Alt+V` | Historial del portapapeles |
| `Mod+L` | Bloquear |
| `Alt+Tab` | Cambiar de ventana |
| `Mod+←/→` | Columna anterior / siguiente |
| `Mod+↑/↓` | Ventana o escritorio de arriba / abajo |
| `Mod+Ctrl+flechas` | Mover la ventana |
| `Mod+O` | Vista general |
| `Mod+K` | Cerrar ventana |
| `Mod+Shift+/` | Ver todos los atajos |

## kitty

`Ctrl+Shift+Enter` divide · `Ctrl+flechas` cambia de panel · `Ctrl+Shift+Z` amplía ·
`cat imagen.png` muestra imágenes en la terminal (`icat` también).

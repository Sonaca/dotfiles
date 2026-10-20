# ~/.config/zsh/.zshrc — zsh estilo s4vitar (p10k + autosuggestions + syntax highlighting)
# zsh lo encuentra gracias a ~/.zshenv:  export ZDOTDIR="$HOME/.config/zsh"

# ── Prompt instantáneo de Powerlevel10k (debe ir arriba del todo) ──
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ── Historial ──
HISTFILE="$ZDOTDIR/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE SHARE_HISTORY EXTENDED_HISTORY
setopt AUTO_CD INTERACTIVE_COMMENTS

# ── Teclas (Inicio, Fin, Supr, Ctrl+flechas) ──
bindkey -e
bindkey '^[[H'    beginning-of-line
bindkey '^[[F'    end-of-line
bindkey '^[[3~'   delete-char
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

# ── Autocompletado con menú navegable ──
autoload -Uz compinit
compinit -d "${XDG_CACHE_HOME:-$HOME/.cache}/zcompdump"
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'   # sin distinguir mayúsculas
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# ── Alias (lsd y bat, como s4vitar) ──
if command -v lsd >/dev/null; then
  alias ls='lsd --group-dirs=first'
  alias l='lsd --group-dirs=first'
  alias ll='lsd -lh --group-dirs=first'
  alias la='lsd -lha --group-dirs=first'
  alias lt='lsd --tree --depth 2'
fi
alias catn='/usr/bin/cat'            # cat original

# cat: las imágenes se ven en la terminal (kitty), el resto con bat
cat() {
  if [[ $# -eq 1 && -f $1 && -n $KITTY_WINDOW_ID ]] && \
     [[ "$(file -b --mime-type -- "$1")" == image/* ]]; then
    kitten icat -- "$1"
  elif command -v bat >/dev/null; then
    bat --paging=never "$@"
  else
    command cat "$@"
  fi
}
alias icat='kitten icat'              # ver imágenes directamente
alias grep='grep --color=auto'

# ── Esc Esc: añade/quita sudo al comando actual (o al anterior) ──
sudo-command-line() {
  [[ -z $BUFFER ]] && zle up-history
  if [[ $BUFFER == sudo\ * ]]; then BUFFER="${BUFFER#sudo }"; else BUFFER="sudo $BUFFER"; fi
  zle end-of-line
}
zle -N sudo-command-line
bindkey '\e\e' sudo-command-line

# ── Funciones de pentesting (del curso de s4vitar, adaptadas a Wayland) ──
# mkt: crea la estructura de trabajo de una máquina
mkt() { mkdir -p {nmap,content,exploits,scripts}; }

# extractPorts: lee un escaneo nmap -oG y copia los puertos abiertos al portapapeles
extractPorts() {
  local ports ip
  ports="$(grep -oP '\d{1,5}/open' "$1" | awk -F/ '{print $1}' | xargs | tr ' ' ',')"
  ip="$(grep -oP '^Host: .* \(\)' "$1" | head -n 1 | awk '{print $2}')"
  echo -e "\n[*] Extrayendo información...\n"
  echo -e "\t[*] IP: $ip"
  echo -e "\t[*] Puertos abiertos: $ports\n"
  printf '%s' "$ports" | wl-copy && echo -e "[*] Puertos copiados al portapapeles\n"
}

# ── fzf: Ctrl+R historial, Ctrl+T archivos, Alt+C carpetas ──
command -v fzf >/dev/null && source <(fzf --zsh)

# ── Plugins (syntax-highlighting debe ir el último) ──
[[ -r /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && \
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
[[ -r /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && \
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ── Powerlevel10k ──
# Clonado en ~/.config/zsh/powerlevel10k (actualizar: git -C "$ZDOTDIR/powerlevel10k" pull)
if [[ -r "$ZDOTDIR/powerlevel10k/powerlevel10k.zsh-theme" ]]; then
  source "$ZDOTDIR/powerlevel10k/powerlevel10k.zsh-theme"
elif [[ -r /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme ]]; then
  source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
fi
[[ -f "$ZDOTDIR/.p10k.zsh" ]] && source "$ZDOTDIR/.p10k.zsh"

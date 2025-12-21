# ============================================
# ARCH LINUX BASHRC
# Adapted from macOS .zshrc
# ============================================

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# ============================================
# UV ENVIRONMENT (if exists)
# ============================================
# Source UV environment if it exists
# This sets up Python tools installed with UV
if [ -f "$HOME/.local/bin/env" ]; then
    . "$HOME/.local/bin/env"
fi

# ============================================
# PATH CONFIGURATION
# ============================================
# IMPORTANT: Add ~/.local/bin FIRST for uv and other tools
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/bin:$PATH"
# Ueberzugpp configuration for Hyprland
export UEBERZUG_BACKEND="wayland"
export WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-wayland-1}"
# ============================================
# EDITOR CONFIGURATION
# ============================================
export EDITOR="nvim"
export VISUAL="nvim"
export GIT_EDITOR="nvim"

# ============================================
# EDITOR ALIASES
# ============================================
alias vi='nvim'
alias vim='nvim'
alias v='nvim'

# ============================================
# LS_COLORS - VSCode Dark+ inspired
# ============================================
export LS_COLORS='rs=0:di=38;5;75:ln=38;5;140:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=00:tw=30;42:ow=34;42:st=37;44:ex=38;5;114:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:*.R=00;34:*.r=00;34:*.Rmd=00;36:*.rmd=00;36'

# ============================================
# GREP COLORS
# ============================================
export GREP_COLORS='ms=38;5;214:mc=38;5;214:sl=:cx=:fn=38;5;141:ln=38;5;114:bn=38;5;114:se=38;5;243'

# ============================================
# GCC COLORS
# ============================================
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# ============================================
# EZA CONFIGURATION (modern ls replacement)
# ============================================
if command -v eza &>/dev/null; then
    alias ls='eza --color=always --icons --group-directories-first'
    alias ll='eza --color=always --icons --group-directories-first -lh'
    alias la='eza --color=always --icons --group-directories-first -lha'
    alias lt='eza --color=always --icons --group-directories-first --tree --level=2'
else
    # Fallback to regular ls with colors
    alias ls='ls --color=auto'
    alias ll='ls -lh --color=auto'
    alias la='ls -lha --color=auto'
fi

# ============================================
# GREP ALIAS
# ============================================
alias grep='grep --color=auto'

# ============================================
# BAT CONFIGURATION (better cat)
# ============================================
if command -v bat &>/dev/null; then
    export BAT_THEME="Visual Studio Dark+"
    alias cat='bat --style=plain'
    alias catp='bat --style=plain --paging=never'
fi

# ============================================
# FZF CONFIGURATION (fuzzy finder colors)
# ============================================
if command -v fzf &>/dev/null; then
    export FZF_DEFAULT_OPTS='
        --color=fg:#d4d4d4,bg:#1e1e1e,hl:#569cd6
        --color=fg+:#d4d4d4,bg+:#264f78,hl+:#569cd6
        --color=info:#608b4e,prompt:#c586c0,pointer:#c586c0
        --color=marker:#dcdcaa,spinner:#c586c0,header:#569cd6
        --color=border:#3e3e3e,label:#aeaeae,query:#d4d4d4
        --border="rounded" --border-label="" --preview-window="border-rounded"
        --prompt="> " --marker=">" --pointer="◆" --separator="─"
        --scrollbar="│"'

    # FZF key bindings (if available)
    [ -f /usr/share/fzf/key-bindings.bash ] && source /usr/share/fzf/key-bindings.bash
    [ -f /usr/share/fzf/completion.bash ] && source /usr/share/fzf/completion.bash
fi

# ============================================
# GIT PROMPT FUNCTION
# ============================================
# Colors for git status (VSCode inspired)
GIT_PROMPT_CLEAN='\033[38;5;114m'    # Green when clean
GIT_PROMPT_AHEAD='\033[38;5;180m'    # Yellow when ahead
GIT_PROMPT_BEHIND='\033[38;5;203m'   # Red when behind
GIT_PROMPT_MODIFIED='\033[38;5;180m' # Yellow when modified
COLOR_RESET='\033[0m'

# Function to get git branch and status
git_prompt() {
    # Check if we're in a git repository
    if ! git rev-parse --is-inside-work-tree &>/dev/null; then
        return
    fi

    local branch=$(git symbolic-ref --short HEAD 2>/dev/null || git describe --tags --always 2>/dev/null)
    local color=""

    # Default to green (clean)
    color=$GIT_PROMPT_CLEAN

    # Check if behind/ahead of remote
    if git rev-list --count --left-right @{upstream}...HEAD &>/dev/null 2>&1; then
        local behind=$(git rev-list --count --left-right @{upstream}...HEAD 2>/dev/null | awk '{print $1}')
        local ahead=$(git rev-list --count --left-right @{upstream}...HEAD 2>/dev/null | awk '{print $2}')

        if [[ "$behind" -gt 0 ]]; then
            color=$GIT_PROMPT_BEHIND # Red if behind
        elif [[ "$ahead" -gt 0 ]]; then
            color=$GIT_PROMPT_AHEAD # Yellow if ahead
        fi
    fi

    # Check for working tree changes
    if ! git diff --quiet || ! git diff --cached --quiet; then
        color=$GIT_PROMPT_MODIFIED # Yellow for changes
    fi

    echo -e "${color}(${branch})${COLOR_RESET}"
}

# ============================================
# YAZI INTEGRATION
# ============================================
# Yazi maintain directory on exit
function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

# ============================================
# PROMPT CONFIGURATION
# ============================================
# VSCode Dark+ inspired prompt
# Blue for path, green for prompt symbol
PS1='\[\033[38;5;75m\]\w\[\033[0m\] $(git_prompt)\n\[\033[38;5;114m\]❯\[\033[0m\] '

# ============================================
# DIRECTORY NAVIGATION ALIASES
# ============================================
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# ============================================
# GIT SHORTCUTS
# ============================================
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'
alias glog='git log --oneline --graph --decorate'

# ============================================
# SAFETY NETS
# ============================================
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# ============================================
# SYSTEM SHORTCUTS
# ============================================
alias reload='source ~/.bashrc'
alias editbash='nvim ~/.bashrc'

# Arch-specific aliases
alias update='sudo pacman -Syu'
alias install='sudo pacman -S'
alias remove='sudo pacman -Rns'
alias search='pacman -Ss'
alias orphans='sudo pacman -Rns $(pacman -Qtdq)'

# System information
alias sysinfo='inxi -Fxxxz'
alias diskspace='df -h'
alias meminfo='free -h'

# ============================================
# HYPRLAND-SPECIFIC (if using Hyprland)
# ============================================
if [ "$XDG_SESSION_TYPE" = "wayland" ] && [ "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
    # Hyprland-specific aliases
    alias hypreload='hyprctl reload'
fi

# ============================================
# HISTORY CONFIGURATION
# ============================================
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoreboth:erasedups
shopt -s histappend

# ============================================
# SHELL OPTIONS
# ============================================
# Check window size after each command
shopt -s checkwinsize

# Enable extended pattern matching
shopt -s extglob

# Enable recursive globbing with **
shopt -s globstar

# Correct minor spelling errors in cd
shopt -s cdspell

# ============================================
# COMPLETION
# ============================================
# Enable programmable completion
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# ============================================
# ARCHIVE EXTRACTION
# ============================================
# Extract any archive with single command
extract() {
    if [ -f "$1" ]; then
        case "$1" in
        *.tar.bz2) tar xjf "$1" ;;
        *.tar.gz) tar xzf "$1" ;;
        *.bz2) bunzip2 "$1" ;;
        *.rar) unrar x "$1" ;;
        *.gz) gunzip "$1" ;;
        *.tar) tar xf "$1" ;;
        *.tbz2) tar xjf "$1" ;;
        *.tgz) tar xzf "$1" ;;
        *.zip) unzip "$1" ;;
        *.Z) uncompress "$1" ;;
        *.7z) 7z x "$1" ;;
        *) echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# ============================================
# ADDITIONAL USEFUL FUNCTIONS
# ============================================

# Make directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Quick backup of a file
backup() {
    cp "$1" "$1.backup-$(date +%Y%m%d-%H%M%S)"
}

# Find process using a port
port() {
    sudo lsof -i :"$1"
}

# Weather function (requires curl)
weather() {
    curl "wttr.in/${1:-}"
}

# ============================================
# TMUX AUTO-START (Optional)
# ============================================
# Uncomment to auto-start tmux
# if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
#     tmux attach -t default || tmux new -s default
# fi

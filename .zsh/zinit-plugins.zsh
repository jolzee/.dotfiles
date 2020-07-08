# sourced from https://github.com/fossabot/dotdrop/blob/7662b92906621a4ede4a1297a574ffda26da4f0c/dotfiles/zsh/zinit.zsh

# toggles "sudo" before the command by pressing [ESC][ESC]
# https://github.com/hcgraf/zsh-sudo
zinit ice wait'1b' lucid
zinit light hcgraf/zsh-sudo

# automatically generates completion functions from getopt-style help texts
# https://github.com/RobSis/zsh-completion-generator
zstyle :plugin:zsh-completion-generator programs ''
export GENCOMPL_FPATH="$ZINIT[COMPLETIONS_DIR]"
zinit ice wait'1b' lucid
zinit light RobSis/zsh-completion-generator

# auto-ls
# https://github.com/desyncr/auto-ls
zinit ice wait'0' lucid
zinit light desyncr/auto-ls

#
# ─── FZF ──────────────────────────────────────────────────────────────────────
#

# Install `fzf` binary and tmux helper script
zinit ice from"gh-r" as'command'
zinit light junegunn/fzf-bin

zinit ice as'command' pick"bin/fzf-tmux"
zinit light junegunn/fzf

# Create and bind multiple widgets using fzf
zinit ice wait'0a' lucid id-as"junegunn/fzf_completions" pick"/dev/null" \
  multisrc"shell/{completion,key-bindings}.zsh"
zinit light junegunn/fzf

# fzf-marks, at slot 0, for quick Ctrl-G accessibility
# https://github.com/urbainvaes/fzf-marks
# zt has'fzf' bindmap'^g -> ^f'; zinit load urbainvaes/fzf-marks
# zinit ice trackbinds bindmap'^g -> ^f' lucid
# zinit light urbainvaes/fzf-marks

# wfxr/formarks - quickly navigating your work path
# https://github.com/wfxr/formarks

# ─── fuzzy movement and directory choosing ────────────────────────────────────
# autojump command
# https://github.com/rupa/z
zinit ice wait'0c' lucid
zinit light rupa/z
# zinit load agkozak/zsh-z
# zinit light skywind3000/z.lua

# Pick from most frecent folders with `Ctrl+g`
# https://github.com/andrewferrier/fzf-z
# zinit ice wait'0b' lucid
# zinit load andrewferrier/fzf-z

# lets z+[Tab] and zz+[Tab]
# https://github.com/changyuheng/fz
zinit ice wait'0b' lucid
zinit light changyuheng/fz

# Like `z` command, but opens a file in vim based on frecency
# zinit wait'0b' as'command' pick"v"
# zinit light rupa/v

# interactive-cd
# https://github.com/changyuheng/zsh-interactive-cd
# zinit light changyuheng/zsh-interactive-cd

#
# ─── IMPORTANT ───────────────────────────────────────────────────────────────
#

# additional completion definitions
# https://github.com/zsh-users/zsh-completions
# zt 0a blockf atpull'zinit creinstall -q .'; z zsh-users/zsh-completions
zinit ice blockf
zinit light zsh-users/zsh-completions

zinit ice as"completion"
zinit snippet https://github.com/deadc0de6/dotdrop/blob/master/completion/_dotdrop.sh-completion.zsh

# fast-syntax-highlighting
# https://github.com/zdharma/fast-syntax-highlighting
# (compinit without `-i` spawns warning on `sudo -s`)
#zinit ice wait'0a' lucid atinit"ZINIT[COMPINIT_OPTS]='-i' _zpcompinit_fast; zpcdreplay"
zinit light zdharma/fast-syntax-highlighting

# zsh-history-substring-search
# https://github.com/zsh-users/zsh-history-substring-search
zinit light zsh-users/zsh-history-substring-search

# multi-word, syntax highlighted history searching
# https://github.com/zdharma/history-search-multi-word
zinit ice wait'1a' lucid trackbinds bindmap'^R -> ^S'
zinit light zdharma/history-search-multi-word

# autosuggestions
# https://github.com/zsh-users/zsh-autosuggestions
# Note: should go _after_ syntax highlighting plugin
zinit ice wait'0a' lucid atload'_zsh_autosuggest_start' compile'{src/*.zsh,src/strategies/*}'
zinit light zsh-users/zsh-autosuggestions


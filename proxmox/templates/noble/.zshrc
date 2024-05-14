export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
CASE_SENSITIVE="true"
HYPHEN_INSENSITIVE="true"
plugins=(
  docker
  direnv
  git
  git-commit
  gitignore
  wd
)
source $ZSH/oh-my-zsh.sh
zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 13
export PROMPT='%{$fg_bold[green]%}%p%(?:%{%}➜ :%{%}➜ ) %(!.%{%F{yellow}%}.)$USER@%{$fg[white]%}%M %{$fg[cyan]%}%c%{$reset_color%} $(git_prompt_info)'

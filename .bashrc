#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
export EDITOR='nvim'
alias vi="vim"
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

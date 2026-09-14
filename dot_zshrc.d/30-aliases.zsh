# 别名

# ---- eza 系列（替代 ls）----
alias ls='eza -al --color=always --group-directories-first --icons=always' # 完整列表
alias la='eza -a  --color=always --group-directories-first --icons=always' # 含隐藏文件
alias ll='eza -l  --color=always --group-directories-first --icons=always' # 长格式
alias lt='eza -aT --color=always --group-directories-first --icons=always' # 树状
alias l.='eza -a | grep -e "^\\."'                                       # 仅隐藏文件

# ---- 目录导航 ----
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

# ---- 日常工具 ----
alias grep='grep --color=auto'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias wget='wget -c '
alias tarnow='tar -acf '
alias untar='tar -zxvf '

# ---- 系统维护 ----
alias grubup='sudo grub-mkconfig -o /boot/grub/grub.cfg'

# ---- 进程查看 ----
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'

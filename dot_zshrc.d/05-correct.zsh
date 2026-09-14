# 只纠正命令名（cleas → clear），不纠正参数
# 覆盖 cachyos-config.zsh 中 ENABLE_CORRECTION="true" 设置的 correct_all
unsetopt correct_all
setopt correct

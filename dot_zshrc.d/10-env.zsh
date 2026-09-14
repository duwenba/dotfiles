# 环境变量与 PATH

# 追加用户本地可执行目录（目录不存在时自动跳过，避免 PATH 污染）
for _dir in "$HOME/.local/bin" "$HOME/.cargo/bin" "$HOME/Applications/depot_tools"; do
  [[ -d "$_dir" && ":$PATH:" != *":$_dir:"* ]] && PATH="$_dir:$PATH"
done
unset _dir

# 默认浏览器
export BROWSER="zen-browser"

# man 分页器（使用 bat 渲染）
export MANROFFOPT="-c"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

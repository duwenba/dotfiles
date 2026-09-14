# 自定义函数

# backup：将文件复制为 .bak
function backup() {
  cp "$1" "$1.bak"
}

# copy：双参数且第一个是目录时递归复制，否则普通 cp
function copy() {
  if (( $# == 2 )) && [[ -d "$1" ]]; then
    local from="${1%/}" to="$2"
    command cp -r "$from" "$to"
  else
    command cp "$@"
  fi
}

# y：yazi 退出后自动跳转到其中最后停留的目录
function y() {
  local tmp cwd
  tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  command yazi "$@" --cwd-file="$tmp"
  if [[ -r "$tmp" ]]; then
    cwd="$(<"$tmp")"
    if [[ -n "$cwd" && "$cwd" != "$PWD" && -d "$cwd" ]]; then
      builtin cd -- "$cwd"
    fi
  fi
  command rm -f -- "$tmp"
}

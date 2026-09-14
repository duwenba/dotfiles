---
name: linux-use
description: Linux 系统管理约定（CachyOS）。请求管理员权限时使用 run0 而不是 sudo；文本搜索用 rg、文件查找用 fd、Python 用 uv。涉及安装软件、修改系统文件、systemctl 操作等需要 root 的场景时加载本 skill。
---

# Linux Use（CachyOS）

本机是 CachyOS（Arch 系），使用 systemd 261。**所有需要管理员权限的操作一律使用 `run0`，不使用 `sudo`。**

## 为什么用 run0

- `run0`（systemd-run 的封装）通过 systemd 以 root 身份运行命令，不依赖 setuid 二进制，更安全
- 密码通过 polkit 交互式认证，不会出现在进程列表或 shell 历史里
- 不支持从 stdin 传密码（这是刻意的设计，不要尝试 `echo pass | run0 ...`）

## 用法

```bash
run0 pacman -S --noconfirm imv     # 安装软件包
run0 systemctl restart sshd        # 管理服务
run0 nano /etc/fstab               # 编辑系统文件
```

## 在 agent 非交互环境下的处理

**直接运行 `run0 <命令>`，不要加 `--no-ask-password`。**

- 桌面会话（Hyprland）中有 polkit agent（如 hyprpolkitagent），即使 agent 的 bash 工具没有 TTY，`run0` 也会在用户桌面上弹出图形密码窗口，用户输入密码后命令正常执行。
- `--no-ask-password` 会禁用交互式认证，导致立即失败（Access denied），只在确认 polkit 凭据已缓存时才用。
- 不要尝试绕过认证（禁止 `echo password | sudo`、`sudo -S` 等）。
- 如果桌面上没有出现密码弹窗、命令因认证失败，再请用户在自己的终端里运行该命令。
- 如果命令本身需要交互（编辑器等），直接给用户终端里的命令，让用户自己执行。

## 现代工具替代约定

本机已安装以下 high-performance 替代品。日常命令默认优先使用它们，替代传统 coreutils：

| 传统工具 | 替代工具 | 说明 |
| --- | --- | --- |
| `grep` | `rg`（ripgrep） | 递归搜索文本，默认遵循 .gitignore、更快、彩色输出 |
| `find` | `fd` | 查找文件，更快，默认忽略隐藏文件与 .gitignore |
| `python` | `uv python` / `uv run` | 用 uv 管理 Python 解释器与脚本/项目，替代系统 python |

### 文本搜索：`rg`（替代 `grep`）

```bash
rg "pattern" path/                # 递归搜索（默认忽略 .gitignore 中的文件）
rg -i "pattern"                   # 忽略大小写
rg -l "pattern"                   # 只列出匹配的文件名
rg --hidden "pattern"             # 也搜索隐藏文件
rg "pattern" --type py            # 只搜 Python 文件（fd/rg 都支持 -t/--type）
```

- 想涵盖隐藏文件用 `--hidden`，想要传统 grep 的逐行原始输出用 `--no-heading`（配合管道时常用）。
- 需要匹配正则的细节行为与 grep 不同时，再回退到 `grep`。

### 文件查找：`fd`（替代 `find`）

```bash
fd "name" path/                   # 按名字查找
fd -e md                          # 按扩展名查找（.md 文件）
fd --hidden "name"                # 包含隐藏文件
fd --type f "name"                # 只找文件（-t d 只找目录）
fd -x rm {}                       # 对每个结果执行命令
fd --exec-batch ls                # 批量执行（-X）
```

- 默认忽略隐藏文件和 .gitignore，与 `rg` 行为一致。
- 需要 find 的 `-exec`/`-printf` 等复杂表达式时，再回退到 `find`。

### Python：`uv`（替代系统 python）

```bash
uv python list                    # 查看已安装/可用的 Python 版本
uv python install 3.12            # 安装指定版本
uv run python script.py           # 用项目锁定的解释器运行脚本
uv python find                    # 找到当前使用的解释器路径
uv venv                           # 在目录创建虚拟环境（替代 python -m venv）
uv add <pkg>                      # 在项目中添加依赖
uv pip install <pkg>              # 向当前 venv 安装包（替代 pip）
```

- 需要临时跑脚本时用 `uv run python foo.py`，它会自动选好解释器并进入环境。
- 需要 root 装系统级包时才用 `run0 pacman -S python-xxx`，否则一律走 uv。

### 配合 run0 使用

现代工具跑普通用户态操作时不需要 root；只有写系统目录或管理系统包时才叠加 run0：

```bash
run0 fd . /etc --hidden --exec grep -l root   # 需要 root 才能读 /etc 时
run0 uv pip install --system pkg              # 系统级 Python 包（谨慎，优先 venv）
```

## 例外

- 仅当用户明确表示已配置 sudo 时，才允许回退到 `sudo`。
- 纯用户态操作（不涉及 root）不需要 run0，正常执行即可。
- 若某个替代工具未安装或行为不符（用户明确要求用原版），回退到对应的 coreutils 工具。

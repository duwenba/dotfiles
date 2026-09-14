# chezmoi dotfiles — recluse @ CachyOS

源目录：`~/.local/share/chezmoi`（chezmoi 自动 git 仓库）
目标目录：`$HOME`（所有路径前缀 `dot_` → `.`，`dot_config/...` → `.config/...`）

## 目录结构

```
~/.local/share/chezmoi/
├── README.md                  # ← 你正在读的（路径 docs/，chezmoi 不部署）
├── dot_bashrc
├── dot_bash_profile
├── dot_zshrc.tmpl             # 模板化：cachyos-zsh-config 包存在才 source
├── dot_zshrc.d/                # 整个 zsh 配置目录
├── dot_gitconfig.tmpl          # 用 .email / .name 模板变量
├── dot_pi/agent/               # pi coding agent（见「pi agent」一节）
├── dot_config/
│   ├── alacritty/alacritty.toml
│   ├── bottom/bottom.toml
│   ├── btop/btop.conf
│   ├── fish/config.fish.tmpl   # 模板化：cachyos-fish-config 包存在才 source
│   ├── gh/private_config.yml   # 原文件 0600，chezmoi 自动加 private_ 前缀
│   ├── helix/config.toml
│   ├── hypr/core/*.lua         # 9 个 portable 文件（不含 monitors.lua）
│   ├── jj/config.toml.tmpl     # 用 .email / .name 模板变量
│   ├── kitty/kitty.conf
│   ├── lazygit/empty_config.yml # 原文件内容为空
│   ├── micro/{settings,bindings}.json
│   ├── yazi/{yazi,keymap,theme,package}.toml
│   └── zed/private_settings.json # 原文件 0600
└── docs/README.md
```

## 常用命令

```bash
chezmoi managed                  # 列出所有被管理的文件
chezmoi diff                     # 看 source 与目标的差异（用 delta 渲染）
chezmoi apply                    # 部署 source → home
chezmoi apply --force            # 即使 source 较旧也覆盖（谨慎使用）
chezmoi add ~/.config/foo/bar    # 把新文件纳入管理
chezmoi add --template ~/.x      # 当文件含个人信息/路径时
chezmoi edit ~/.config/kitty/kitty.conf
# ↑ 自动从 dot_config/kitty/kitty.conf 打开编辑器
chezmoi cat ~/.gitconfig         # 查看模板渲染后的最终内容
chezmoi data                     # 查看 [data] 变量
chezmoi data --bash              # 同上，shell export 格式
```

## 故意不管理的文件

### 机密（永远不进 git）
- `~/.ssh/id_ed25519`、`~/.ssh/id_ed25519.pub` — SSH 私钥、公钥可放进 chezmoi 但需要 `age`/`gpg` 加密
- `~/.gnupg/` — GPG 密钥环
- `~/.config/gh/hosts.yml` — GitHub OAuth token

### 自动生成的机器状态
- `~/.zsh_history`、`~/.bash_history`、`~/.viminfo`、`~/.python_history`
- `~/.zcompdump*`
- `~/.cache/`、`~/.local/state/`
- `~/.config/dconf/`（dconf 数据库）

### KDE / Plasma / Qt / GNOME 配置（机器相关）
- `kdeglobals`、`dolphinrc`、`kiorc`、`baloo*`、`Trolltech.conf`、`QtProject.conf`
- `powermanagementprofilesrc`、`systemmonitorrc`、`drkonqirc`、`discoverrc`
- `bluedevilglobalrc`、`procps`、`pulse`、`session`、`systemd`、`fontconfig`
- `gtk-3.0/`、`gtk-4.0/`、`gtkrc*`、`qt5ct`、`qt6ct`、`xsettingsd`、`nwg-look`
- `user-dirs.*`、`xdg-desktop-portal`、`environment.d`、`autostart`、`mimeapps.list`
- `swash`、`winboat`、`noctalia/`、`shelly/`、`uwsm/`、`denia-home/`、`Folia/`、`net.imput.helium/`
- `PacmanLogViewer/`、`obs-studio/`、`termusic/`、`qView/`、`GIMP/`、`gnome-builder/`、`gnome-mpv/`
- `nvtop/`、`cava/`、`celluloid/`、`bottom/themes/`、`rio/`、`mango/`
- `Biu/`、`Folia/`、`denia-home/`、`denial/`、`dgop/`、`vinput/`、`helium/`
- `mozilla/`、`zen/`、`firejail/`、`containers/`
- `backgrounds/`、`des/`、`dls/`、`doc/`、`mus/`、`pic/`、`pro/`、`pub/`、`tem/`、`vid/`

### 编辑器扩展包（外部依赖，最好用各工具自带管理）
- `micro/{colorschemes,syntax,backups,buffers}`、`helix/themes/`、`zed/themes/`
- `yazi/flavors/`、`yazi/plugins/`（用 `ya pkg add`）

### 应用运行时数据
- `jj/repos/`、`gh/hosts.yml`

### pi coding agent（`~/.pi/agent/`）
- `sessions/`（49M 会话历史）、`npm/`（33M node_modules）、`tmp/`、`talk.db*`
- `models-store.json`（程序生成的模型缓存）、`trust.json`（含本机路径 `/mnt/ntfs/...`）
- `extensions/`、`themes/`（当前为空）、`extension-settings/schemas/`（扩展包自动生成）
- ⚠️ `auth.json`、`models.json` 含**明文 API key**：不直接纳入，改为模板化（见「pi agent」一节）

### Hyprland 机器特异项
- `hypr/hyprland.lua`（CachyOS 发行版管理）
- `hypr/hl.meta.lua`（自动生成）
- `hypr/xdph.conf`（XWayland 相关，机器相关）
- `hypr/keymap.lua`（Noctalia Keymap 插件管理）
- `hypr/core/monitors.lua`（显示器输出名机器而异）
- `hypr/shells/`（shell 切换相关）

## 添加新配置的流程

```bash
# 1. 在 ~/.config/... 或 ~/... 编辑文件
vim ~/.config/kitty/kitty.conf

# 2. 让 chezmoi 接管
chezmoi add ~/.config/kitty/kitty.conf

# 3. 如需个人信息模板化，编辑源文件
chezmoi edit ~/.config/kitty/kitty.conf
# ↑ 这会打开 dot_config/kitty/kitty.conf，可改成 *.tmpl 并用 {{ .var }}
```

## pi agent（`~/.pi`）的托管方式

```
~/.pi/agent/   →   dot_pi/agent/
```

**纳入的（手写意图）**：`settings.json`、`open-tui.json`、`spark.json`、
`extension-settings/pi-ui-tweaks.json`、`skills/{github-cli,linux-use}/SKILL.md`。

**模板化的（机密）**：

| 目标 | 源 | 模板变量 |
|---|---|---|
| `~/.pi/agent/models.json` | `dot_pi/agent/private_models.json.tmpl` | `{{ .pi_ark_api_key | quote }}` |
| `~/.pi/agent/auth.json` | `dot_pi/agent/private_auth.json.tmpl` | `{{ .pi_deepseek_api_key | quote }}` |

明文 key 只存在于 `~/.config/chezmoi/chezmoi.toml` 的 `[data]`（权限 0600，**不在 git 仓库里**），
源仓库内不含任何明文 key。两个目标文件原本是 0644/0755（同目录其他配置也是 0644 却带执行位），
已收敛为 0600，并由 `private_` 前缀兜底。

**轮换 key**：

```bash
hx ~/.config/chezmoi/chezmoi.toml        # 改 [data] pi_ark_api_key / pi_deepseek_api_key
chezmoi apply                            # 重新渲染两个文件
diff <(chezmoi cat ~/.pi/agent/models.json) ~/.pi/agent/models.json   # 应为空
```

**新机器**（key 不在仓库里，必须自备）：

```bash
chezmoi init git@github.com:USER/dotfiles.git
chezmoi apply --dry-run --override-data '{"pi_ark_api_key":"...","pi_deepseek_api_key":"..."}'
chezmoi apply           --override-data '{"pi_ark_api_key":"...","pi_deepseek_api_key":"..."}'
# 或先把 key 写进 ~/.config/chezmoi/chezmoi.toml 的 [data] 再 apply
```

**为什么 `chezmoi add --recursive ~/.pi` 是错的**：会带进 49M sessions、33M node_modules、
SQLite 运行时库和两份明文 key。这个目录"程序生成的状态"远多于"手写的意图"，只能逐文件 add。

## 跨机器同步

`chezmoi init` 已自动初始化 source git 仓库。当前未配 remote。

```bash
cd ~/.local/share/chezmoi
git remote add origin git@github.com:USER/dotfiles.git   # 替换为你的仓库
git add -A && git commit -m "snapshot: $(date +%F)"
git push -u origin master
```

新机器：

```bash
chezmoi init git@github.com:USER/dotfiles.git
chezmoi apply --force
```

## 数据变量

`~/.config/chezmoi/chezmoi.toml` 中 `[data]` 段定义了模板里用的变量。
当前：

- `name` = `"Du Wenba"`
- `email` = `"2275317692@qq.com"`

模板里这样用：

```toml
[user]
email = {{ .email | quote }}
name = {{ .name | quote }}
```

覆盖方式（v2.72.1 实测）：

```bash
# ✅ 可用：JSON 覆盖，可只覆盖部分 key
chezmoi cat               --override-data '{"email":"other@example.com"}' ~/.gitconfig
chezmoi apply             --override-data '{"email":"other@example.com"}'
chezmoi apply --override-data-file ~/.config/chezmoi/override.json

# ❌ 不存在 / 无效：chezmoi 没有 --data flag；
#    CHEZMOI_DATA_<KEY> 环境变量也不会覆盖 [data]（实测 chezmoi data 值不变）
```

> `--override-data` 是**部分覆盖**：没提供的 key 仍取 `chezmoi.toml` 的值。

## 处理发行版特定包

如果某个配置文件 `source` 了发行版专属的脚本（`/usr/share/<distro>-xxx-config/...`），
直接放进 chezmoi 会在别的发行版上部署失败。用 `stat` 模板函数做部署时条件渲染：

```zsh
{{ if stat "/usr/share/cachyos-zsh-config/cachyos-config.zsh" -}}
source /usr/share/cachyos-zsh-config/cachyos-config.zsh
{{ end }}
```

原理：`chezmoi apply` 时检查 `/usr/share/...` 是否存在，存在则渲染 `source` 行，否则整块跳过。
这样：

- 当前机器装了包 → 渲染正常
- 以后删了包 → 下次 `chezmoi apply` 自动移除 `source` 行
- 换到别的发行版 → 该路径不存在，整块不渲染，不报错

可用的条件模板函数（[chezmoi docs](https://chezmoi.io/docs/reference/templates/special-functions/)）：

| 函数 | 用途 |
|---|---|
| `stat path` | 文件/目录是否存在 |
| `lookPath name` | 可执行文件是否在 `PATH` 中 |
| `eq .chezmoi.os.id "cachyos"` | 按 OS ID 判断 |
| `eq .chezmoi.hostname "xxx"` | 按主机名判断 |

trim 标记注意点：

- `{{- ... }}` 去掉左侧空白
- `{{ ... -}}` 去掉右侧空白
- `{{ end }}` 后面的换行/空行会被当成"条件为真时的输出"的一部分

调试时用 `chezmoi cat <target>` 看渲染结果，或者 `chezmoi diff` 对比差异。

## 备份 / 回滚

```bash
chezmoi diff                     # 改动前先看一眼
chezmoi apply --dry-run          # 只打印不改文件
git -C ~/.local/share/chezmoi log --oneline
git -C ~/.local/share/chezmoi revert <commit>
chezmoi apply --force            # 让目标回到 source 状态
```

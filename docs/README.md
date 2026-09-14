# chezmoi dotfiles — recluse @ CachyOS

源目录：`~/.local/share/chezmoi`（chezmoi 自动 git 仓库）
目标目录：`$HOME`（所有路径前缀 `dot_` → `.`，`dot_config/...` → `.config/...`）

## 目录结构

```
~/.local/share/chezmoi/
├── README.md                  # ← 你正在读的（路径 docs/，chezmoi 不部署）
├── dot_bashrc
├── dot_bash_profile
├── dot_zshrc
├── dot_zshrc.d/                # 整个 zsh 配置目录
├── dot_gitconfig.tmpl          # 用 .email / .name 模板变量
├── dot_config/
│   ├── alacritty/alacritty.toml
│   ├── bottom/bottom.toml
│   ├── btop/btop.conf
│   ├── fish/config.fish
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

覆盖方式：

```bash
chezmoi apply --data email=other@example.com
# 或
CHEZMOI_DATA_EMAIL=other@example.com chezmoi apply
```

## 备份 / 回滚

```bash
chezmoi diff                     # 改动前先看一眼
chezmoi apply --dry-run          # 只打印不改文件
git -C ~/.local/share/chezmoi log --oneline
git -C ~/.local/share/chezmoi revert <commit>
chezmoi apply --force            # 让目标回到 source 状态
```

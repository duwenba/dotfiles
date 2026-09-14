---
name: github-cli
description: 使用 GitHub CLI（gh）完成 GitHub 工作流：仓库管理、issue/PR 全流程、release、gist、GitHub Actions、代码搜索与 gh api 调用。处理任何 GitHub 相关任务（查看/创建/修改仓库、issue、PR、release、workflow）时加载本 skill。
---

# GitHub CLI (gh)

用 `gh` 操作 GitHub。本机已安装 gh 2.97.0 并登录（账号 duwenba，git 协议为 ssh）。

## 前置检查

```bash
gh auth status          # 确认登录状态和 token 权限
gh --version
```

如果未登录：`gh auth login`（选择 GitHub.com → SSH → 按提示完成浏览器授权）。

## 通用约定

- **本机协议是 SSH**，clone 仓库用 `gh repo clone owner/repo`（自动走 ssh），不要手动拼 https URL。
- **非交互模式**：agent 的 bash 没有 TTY，凡是会触发交互提示的命令加 `--yes`（跳过确认）和 `--no-pager`（避免进入分页器），例如 `gh pr merge --squash --yes --no-pager`。
- **JSON 输出**：优先用 `--json <字段> -q <jq表达式>` 拿到机器可读结果，配合 jq 提取字段。示例：
  ```bash
  gh pr list --json number,title,headRefName -q '.[] | "\(.number) \(.title)"'
  ```
- **模板快捷写法**：`-t` 是 `--template`（Go 模板），`-q` 是 `--jq`。用 `gh <cmd> --json` 可查看可用字段列表（`gh pr view --json` 不带字段会列出所有字段）。
- **当前目录仓库**：在仓库目录内运行时 `gh` 会自动识别 owner/repo；也可用 `-R owner/repo` 显式指定任意仓库。
- 输出是纯文本时可能被截断/分页，需要完整内容时加 `--no-pager` 或重定向到文件再 read。

## 仓库（repo）

```bash
gh repo clone owner/repo [dir]      # clone（ssh 协议）
gh repo create name --public --clone   # 新建仓库并 clone
gh repo create name --source=. --push   # 把当前目录变成新仓库并推送
gh repo fork owner/repo --clone --remote=true
gh repo view owner/repo              # 查看仓库信息
gh repo view --web                   # 浏览器打开
gh repo list owner --limit 50 --json name,description,stargazerCount
```

## Issue 全流程

```bash
gh issue list -R owner/repo [--state open|closed|all] [--label bug] [--assignee @me]
gh issue list --search "is:open label:bug"        # 高级搜索语法
gh issue view 123 [--comments]                    # 查看 issue（含评论）
gh issue create -t "标题" -b "正文" [-l bug -a @me -R owner/repo]
gh issue edit 123 -t "新标题" --add-label "needs-review"
gh issue close 123 --reason completed|not_planned
gh issue reopen 123
gh issue comment 123 -b "评论内容" [--edit-last]
gh issue develop 123 -b fix/issue-123             # 基于 issue 开分支
```

## PR 全流程

```bash
gh pr list [-R owner/repo] [--state open|merged|closed|all] [--draft] [-a @me]
gh pr view 456 [--comments]                       # 查看 PR
gh pr create -t "标题" -b "正文" -B main -H feat/x \
  [--draft] [-l bug] [-a @me] [-R owner/repo]
gh pr checkout 456                                # 切到 PR 分支（自动建本地分支）
gh pr diff 456                                    # 查看 diff
gh pr edit 456 -t "新标题" --add-label "reviewed"
gh pr comment 456 -b "LGTM"                       # 评论
gh pr review 456 -a | -r | -c -b "评价"            # approve / request-changes / comment
gh pr merge 456 --squash|--rebase|--merge --delete-branch --yes --no-pager
gh pr ready 456                                   # draft -> ready
gh pr close 456 --comment "关闭原因"
gh pr checks 456 --watch                          # 查看 CI 状态并等待
gh pr status                                      # 我参与的 PR/issue 概览
```

## Release

```bash
gh release list [--limit 20]
gh release create v1.0.0 --title "v1.0.0" --notes "变更说明" [./asset.tar.gz]
gh release create v1.0.0 --generate-notes          # 自动生成 changelog
gh release view v1.0.0
gh release download v1.0.0 -p "*.tar.gz" -D ./dist  # 按模式下载 asset
gh release upload v1.0.0 ./asset.zip
gh release delete v1.0.0 --yes
```

## Gist

```bash
gh gist create file.py [-d "描述"] [-p]            # -p 创建 secret gist
gh gist list
gh gist view <id>                                  # 查看 gist 内容
gh gist edit <id> file.py                          # 更新 gist 文件
```

## GitHub Actions

```bash
gh run list [--workflow ci.yml] [--status failure] [--limit 20]
gh run view <run-id> [--log]                       # 查看运行日志
gh run view <run-id> --log-failed                  # 只看失败步骤日志
gh run watch <run-id>                              # 等待运行完成
gh run rerun <run-id> [--failed]                   # 重跑（默认全部）
gh run cancel <run-id>
gh workflow list                                   # 列出仓库 workflow
gh workflow run ci.yml -f param=value              # 手动触发
gh workflow enable/disable ci.yml
```

## 搜索

```bash
gh search repos "lang:rust stars:>1000" --limit 20
gh search code "TODO" -R owner/repo
gh search issues "memory leak" --state open
gh search prs "bugfix" --state merged
gh search commits "fix typo" -R owner/repo
```

## gh api（覆盖所有未列出的场景）

REST 或 GraphQL 都能调。在 git 仓库目录内运行时，`{owner}`/`{repo}` 会被自动替换；**不在 git 仓库目录时必须写完整 `owner/repo`**，否则报错：

```bash
gh api repos/cli/cli -q .default_branch                       # 非仓库目录：写完整名字
gh api repos/{owner}/{repo}/issues?per_page=100 \             # 仓库目录内：可用占位符
  -q '.[] | "\(.number) \(.title)"'
gh api -X PATCH repos/cli/cli -f description="新描述"
gh api graphql -f query='
  query($q: String!) { search(query: $q, type: ISSUE, first: 10) {
    edges { node { ... on Issue { number title url } } } } }' \
  -F q="repo:owner/repo is:open"
```

- `-f key=value` 发字符串参数（自动转 POST），`-F` 做类型转换/传 JSON，`--method GET` 可强制 GET。
- 复杂/高频操作（分支保护、deployments、code review 统计等）优先用 `gh api` + GraphQL，一次取足数据。

## 常用 jq 片段

```bash
gh repo view owner/repo --json stargazerCount,issues,defaultBranchRef \
  -q '{stars: .stargazerCount, openIssues: .issues.totalCount, branch: .defaultBranchRef.name}'
gh pr list --json number,title,mergedAt -q \
  'map(select(.mergedAt != null)) | sort_by(.mergedAt) | reverse | .[0:5]'
```

## 安全与注意

- **不要**把 token（`gh auth status` 里的 `gho_*`）写进任何文件、日志或回复。
- `gh` 交互式命令（`gh pr create` 不带参数、`gh release create` 等）在无 TTY 下会失败，**必须**通过 flags 提供全部参数。
- 删除类操作（`gh release delete`、`gh repo delete`、`gh pr close`）先用 view 确认对象存在且是目标对象，再加 `--yes` 执行。
- 修改他人仓库的默认分支、合并保护规则等敏感操作前，先查清仓库归属和权限（`gh api repos/{owner}/{repo} -q '{owner: .owner.login, archived: .archived, default_branch: .default_branch}'`）。

# TwiCC 离线安装包（Linux x86_64）

本安装包用于在**完全断网（air-gapped）**的 Linux x86_64 机器上安装定制版 TwiCC
（offline-mode 分支：图标本地化 + 外部网络开关 + 离线模式）。安装过程不需要任何网络，
也不需要 npm / Node.js；目标机器上没有 Python 3.13 也可以（包里带了便携版 Python）。

## 1. 包里有什么

| 路径 | 内容 |
|---|---|
| `install.sh` | 安装/升级脚本（可重复执行） |
| `wheels/` | TwiCC 本体 wheel（前端已构建在内，版本号形如 `1.97.1+offline1`）和全部运行时依赖 wheel（按 `uv.lock` 锁定，CPython 3.13、manylinux x86_64） |
| `codex-runtime/` | Codex CLI 运行时（原本首次启动时从 GitHub 下载，这里预先打包） |
| `python/` | 可选：便携版 CPython 3.13（python-build-standalone，需 glibc ≥ 2.17） |
| `twicc.service.example` | systemd 用户服务模板 |
| `BUNDLE-INFO.txt` | 版本、提交号、glibc 最低要求等信息 |
| `SHA256SUMS` | 包内每个文件的校验和 |

Claude Code CLI 已经包含在 `claude-agent-sdk` 的 wheel 里（`claude_agent_sdk/_bundled/claude`
原生二进制），不需要单独安装 Node.js 或 `@anthropic-ai/claude-code`。

## 2. 系统要求

- Linux x86_64，glibc 发行版（不支持 Alpine/musl）。glibc 最低版本见 `BUNDLE-INFO.txt`；1.97.1 版本的包需要 **glibc ≥ 2.27**（pillow 需 2.27，Claude Code 二进制需 2.26，Codex 二进制为静态链接、无要求），即 Ubuntu 18.04+、Debian 10+、RHEL/Rocky/Alma 8+、openEuler 20.03+ 等；**CentOS 7（glibc 2.17）不支持**。查看本机版本：`ldd --version`
  （查看本机版本：`ldd --version`）。
- Python 3.13+（系统没有就自动使用包内的便携版）。
- 可选：`tmux`（终端功能）、`git`（Git 面板）、`bubblewrap`（Codex 沙箱在部分系统上需要）。
- 约 2 GB 磁盘空间（Claude 和 Codex 二进制解压后较大）。

## 3. 拷贝到目标机器

在有网的机器上先校验，再用 U 盘 / 内网传输拷贝过去：

```bash
sha256sum -c twicc-offline-1.97.1-linux-x86_64.tar.gz.sha256
```

在目标机器上：

```bash
tar -xzf twicc-offline-1.97.1-linux-x86_64.tar.gz
cd twicc-offline-1.97.1-linux-x86_64
sha256sum -c SHA256SUMS --quiet      # 可选：确认文件完整
```

## 4. 安装

```bash
./install.sh                          # 默认装到 ~/.twicc-venv
# 或者：
./install.sh --prefix /opt/twicc      # 装到指定目录（需要对该目录有写权限）
./install.sh --bundled-python         # 强制使用包内便携版 Python
./install.sh --systemd                # 同时安装 systemd 用户服务
./install.sh --help                   # 查看全部选项
```

脚本会：

1. 找到 Python 3.13（`python3.13` / `python3`），找不到就把便携版解压到 `<prefix>-python`；
2. 在 `<prefix>` 创建虚拟环境，用 `pip install --no-index --find-links wheels` 只从包内安装；
3. 把 Codex 运行时放进 `~/.cache/twicc/codex-runtime/`（Codex 无需联网下载）；
4. 如果 `~/.twicc/.env` 里还没有 `TWICC_OFFLINE`，就追加一行 `TWICC_OFFLINE=1`；
5. （`--systemd` 时）写入 `~/.config/systemd/user/twicc.service`。

> 注意：使用便携版 Python 时，虚拟环境依赖 `<prefix>-python` 目录，不要删除它。

## 5. 启动与访问

```bash
~/.twicc-venv/bin/twicc --offline
```

浏览器打开 **http://localhost:3500**（端口可在 `~/.twicc/.env` 里用 `TWICC_PORT=xxxx` 修改）。

- 服务监听 `0.0.0.0`，但**没有设置密码时只接受本机访问**。要从其他机器访问，先设置密码：
  `~/.twicc-venv/bin/twicc password set`，然后重启。
- 后台常驻（systemd 用户服务）：

  ```bash
  ./install.sh --systemd
  systemctl --user enable --now twicc
  journalctl --user -u twicc -f
  sudo loginctl enable-linger "$USER"   # 注销后继续运行
  ```

- 日志：`~/.twicc/logs/backend.log`。

## 6. 关于 Claude Code / Codex 在内网的使用

TwiCC 只是 Claude Code 和 Codex 的网页界面，两个 CLI 都已随包安装，但**它们本身仍需要访问模型服务**：

- 完全断网时，需要内网可达的模型接口，例如：
  - Claude Code：在 `~/.twicc/.env` 或环境中配置 `ANTHROPIC_BASE_URL`（内网网关）及对应凭据，
    或 Bedrock / Vertex 的内网端点；
  - Codex：在 `~/.codex/config.toml` 中配置自定义 `model_providers`（如内网 OpenAI 兼容服务）。
- 登录认证（`claude` / `codex` 的 OAuth 登录）需要访问官方服务，内网环境请改用 API Key / 网关方式，
  或在有网机器上登录后复制 `~/.claude`、`~/.codex` 的凭据（注意安全）。
- 离线模式会为 Claude Code 自动设置 `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1`，关闭其遥测、错误上报和自动更新检查。

## 7. 确认没有对外流量

1. 看启动日志，应有：`Offline mode (TWICC_OFFLINE): every outbound network feature is off`
   ```bash
   grep "Offline mode" ~/.twicc/logs/backend.log
   ```
2. 查看前端拿到的开关状态（全部应为 `false`）：
   ```bash
   curl -s http://localhost:3500/api/bootstrap/ | python3 -c "import json,sys; print(json.load(sys.stdin)['network'])"
   ```
   （设置了密码时需要先登录，可改在浏览器开发者工具的 Network 面板里看 `/api/bootstrap/`。）
3. 抓包或看连接：
   ```bash
   ss -tnp | grep -i python          # 除了本机/内网连接外不应有对外连接
   sudo tcpdump -i any -n 'not net 127.0.0.0/8 and not net 10.0.0.0/8 and not net 192.168.0.0/16'
   ```
4. 浏览器开发者工具 → Network：除 `localhost:3500` 外不应有任何请求（图标、更新日志都走本地）。
5. 更彻底的验证：在无网络的命名空间里运行（需要内核允许用户命名空间）：
   ```bash
   unshare -rn sh -c 'ip link set lo up; ~/.twicc-venv/bin/twicc --offline'
   ```

各开关的说明见 TwiCC 源码中的 `docs/offline-mode.md`（`TWICC_NO_VERSION_CHECK`、
`TWICC_NO_CHANGELOG_FETCH`、`TWICC_NO_STATUS_PAGE`、`TWICC_NO_PRICE_SYNC`、`TWICC_NO_USAGE_SYNC`、
`TWICC_NO_OPENROUTER`、`TWICC_NO_CODEX_RUNTIME_DOWNLOAD`，以及总开关 `TWICC_OFFLINE`）。

## 8. 升级

拿到新版离线包后，解压并在新目录里用**同样的参数**再执行一次 `install.sh`：

```bash
tar -xzf twicc-offline-<新版本>-linux-x86_64.tar.gz
cd twicc-offline-<新版本>-linux-x86_64
./install.sh --prefix ~/.twicc-venv
systemctl --user restart twicc        # 如果用了 systemd
```

虚拟环境会被复用，TwiCC 会被替换为新包的版本；`~/.twicc` 里的数据、设置和 `.env` 保持不变。

## 9. 卸载

```bash
systemctl --user disable --now twicc 2>/dev/null; rm -f ~/.config/systemd/user/twicc.service
rm -rf ~/.twicc-venv ~/.twicc-venv-python ~/.cache/twicc
# 数据目录（会话索引、设置）：确认不需要后再删除 ~/.twicc
```

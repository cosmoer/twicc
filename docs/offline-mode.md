# Offline mode and outbound network switches

TwiCC runs locally, but a few of its features talk to third-party services on
their own. Each one can be turned off, and one master switch turns them all off.
Everything is **on by default**: without any of these variables TwiCC behaves as
it always did.

Set the variables like any other configuration, in `~/.twicc/.env` (or the
process environment), then restart TwiCC. Values `1`, `true` and `yes` turn a
switch on (case-insensitive).

## Master switch

```bash
twicc --offline            # or: twicc run --offline
TWICC_OFFLINE=1 twicc      # same thing, also accepted in ~/.twicc/.env
```

`TWICC_OFFLINE=1` turns off every feature below. In addition it sets
`CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1` (unless already set) for the
Claude Code processes TwiCC launches, so the CLI skips its own telemetry,
error reporting and auto-update checks.

The startup log (`backend.log`) states the offline mode, or lists the features
turned off individually.

## Individual switches

| Variable | Turns off | When off |
|---|---|---|
| `TWICC_NO_VERSION_CHECK` | The PyPI query (`pypi.org/pypi/twicc/json`) every 15 minutes for a newer TwiCC | No "update available" notice |
| `TWICC_NO_CHANGELOG_FETCH` | The "What's new" dialog reading `CHANGELOG.md` (and its image fallback) from `raw.githubusercontent.com` | The dialog reads the `CHANGELOG.md` shipped with the build, served by the backend at `/api/changelog/`; images come from the bundled `whats-new/` assets only |
| *(telemetry)* | Anonymous telemetry POSTs to `twicc-telemetry.twidi.com` | The regular opt-out is **Settings → General** (`TWICC_NO_TELEMETRY=1` only makes that setting start disabled). `TWICC_OFFLINE` forces telemetry off whatever the setting says |
| `TWICC_NO_STATUS_PAGE` | Polling the Claude (`status.claude.com`) and OpenAI (`status.openai.com`) status pages every 2 minutes | No upstream incident banner |
| `TWICC_NO_PRICE_SYNC` | The daily download of OpenRouter's public model catalogue (`openrouter.ai/api/v1/models`) used for model prices | Costs use the prices already in the database, else the built-in default prices |
| `TWICC_NO_USAGE_SYNC` | Background polling of the Anthropic / ChatGPT usage endpoints for the quota gauges | Gauges update only when you click **Refresh now** |
| `TWICC_NO_OPENROUTER` | Every OpenRouter call made with `TWICC_OPENROUTER_API_KEY`: OpenRouter summaries and titles, the speech adaptation, OpenRouter Text to Speech and its model list | The key is treated as not set: the OpenRouter choices behave as with no key configured |
| `TWICC_NO_CODEX_RUNTIME_DOWNLOAD` | The first-launch download of the Codex CLI runtime from GitHub Releases | Codex works only if the runtime is already in `~/.cache/twicc/codex-runtime/`; otherwise starting Codex fails with a clear error |

## What these switches do not cover

- **The agents themselves.** Claude Code and Codex talk to Anthropic and OpenAI:
  that is the product. Codex's own analytics are configured in Codex's
  `config.toml`.
- **Features that only reach a host you configured or asked for**, and do
  nothing until you do: push notifications (Apprise URLs, the Android app's web
  push), peer messaging (peers you added), MCP event webhooks and the OAuth
  metadata of an MCP client connecting to TwiCC, artifact network requests you
  approve in the consent prompt, the Browser pane's reachability probe of the
  URL you open, and the daily quota warm-up (off unless a time is set).
- **Links** you click in the interface (GitHub, documentation, status pages).

Icons and fonts are bundled with the frontend; the interface requests nothing
from a CDN.

# Security policy

## Supported versions

Pegasus is a small, single-maintainer project. The latest published GitHub release on `main` is the only supported version. Pinned versions older than the current minor are not actively patched.

## What's in scope

- Vulnerabilities in `install.sh`, `install.ps1`, `connect.sh`, `desktop-apps.sh`, or `bin/pegasus` that allow command injection, privilege escalation, arbitrary file write outside `~/Design-Projects` / `~/.pegasus` / `~/.claude`, or token exfiltration.
- Supply-chain risks in the curl-pipe-bash one-liner: tampering, downgrade attacks, or anything that breaks the integrity of what a fresh installer pulls from `raw.githubusercontent.com/jerickevans-gif/Pegasus/main`.
- XSS or sensitive-data exposure in the dashboard at `dashboard.html` (including `localStorage` profile fields).
- Anything that causes the service worker (`sw.js`) to serve attacker-controlled content under the Pages origin.

## What's out of scope

- The inherent risk of `curl … | bash` as an installation method. Pegasus is open source and reviewable; you can `curl -O install.sh && less install.sh && bash install.sh` if you'd rather inspect first. This is documented behavior, not a vulnerability.
- Risks from the third-party tools Pegasus *installs* (Claude Code, OpenCode, Surge, Homebrew, VS Code extensions, MCP servers). Report those upstream.
- Aesthetic / UX issues, missing features, or "AI does the wrong thing" — those are bugs, not security issues.
- Anything that requires a malicious local user already having write access to your home directory.

## Inherent risks (documented, not bugs)

- The installer writes to `~/.zshrc` / `~/.bashrc` to add `~/.local/bin` to PATH. Review if you have unusual shell configurations.
- MCP servers Pegasus enables may request OAuth scopes (Figma, Google, Slack, etc.). Permissions are granted per-service when you explicitly authenticate; revoke at the source.
- API tokens (Anthropic, GitHub PAT, etc.) are user-managed. Pegasus does not centrally store, transmit, or log them.

## Reporting a vulnerability

**Preferred:** GitHub Security Advisories — open a private advisory at <https://github.com/jerickevans-gif/Pegasus/security/advisories/new>. This is the most reliable path; it creates a private collaboration channel and a CVE-eligible workflow.

**Alternative:** email <jerick@eigenhitchens.com> with subject `[Pegasus security]`. PGP not yet available.

Please include:
- Affected file + line range or `pegasus` subcommand
- A minimal reproduction (one-liner or short script if possible)
- Your assessment of severity and exploitation prerequisites

## Response time

This is a side project. Realistic targets:

| Severity | Initial response | Patch target |
|---|---|---|
| Critical (RCE, secret exfiltration) | 24 hours | 7 days |
| High (privilege escalation, persistent XSS) | 72 hours | 30 days |
| Medium / low | 1 week | next release window |

If you don't hear back within the initial-response window, please escalate via a public issue tagged `[security][unresponded]` so it gets visibility.

## Recognition

If you'd like public credit after disclosure, mention it in the report and you'll be listed in the release notes for the patch.

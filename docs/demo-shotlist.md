# Pegasus demo recording — shot list

A 60-second screen recording for the README. Use QuickTime (Cmd-Shift-5) at 1920×1080. Export as MP4, then convert to GIF with `gifski` or `ffmpeg` if needed for GitHub README inline-play.

## Script (60 seconds total)

| Time | Visual | Voiceover / on-screen text |
|---|---|---|
| 0:00–0:04 | Terminal: `curl -fsSL https://raw.githubusercontent.com/jerickevans-gif/Pegasus/main/install.sh \| bash` | "One command. Designer laptop, AI studio." |
| 0:04–0:08 | Install scrolls: skills installing, MCPs installing, dashboard opening | (text overlay) "Installs Claude Code + 31 skills + 13 templates + dashboard" |
| 0:08–0:14 | Browser opens to dashboard. Cursor hovers over the 🎨 / 💼 / ⊕ track tabs, clicks 💼 | "Two tracks: design or job search. Filter everything." |
| 0:14–0:20 | Scroll to Profile section, fill in 4 fields quickly, watch checklist tick | "Tell it about you once. Skills personalize forever." |
| 0:20–0:26 | Click 🎯 "Find me jobs to apply to today" → toast appears → page scrolls to Job Results | "One click builds the prompt. Paste into Claude." |
| 0:26–0:34 | Switch to Claude Code. Paste prompt. Claude scrolls a markdown table. Drag the resulting `.md` onto the dashboard | "Claude returns a ranked shortlist." |
| 0:34–0:42 | Job cards animate in, color-coded by score. Click a green-95 card → opens apply URL | "Each job scored. Apply in one click." |
| 0:42–0:50 | ⌘K palette opens, fuzzy-search "audit", select ux-ui-audit skill, paste into Claude | "300 commands and skills. Search anything." |
| 0:50–0:58 | Toggle theme button (system → light → dark) so viewer sees both modes | "Light. Dark. System. Whatever." |
| 0:58–1:00 | Final frame: github.com/jerickevans-gif/Pegasus | "Pegasus. Free. MIT." |

## Setup before recording

```bash
# Reset to clean state so demo flows naturally
rm -rf ~/.pegasus ~/.claude/skills /tmp/demo-recording
mkdir -p /tmp/demo-recording

# Pre-fill clipboard with install command for tab completion
echo 'curl -fsSL https://raw.githubusercontent.com/jerickevans-gif/Pegasus/main/install.sh | bash' | pbcopy

# Have Claude Code already open in a clean terminal split
```

## Recording tips

- **Resolution:** 1920×1080. GitHub will inline-play MP4 up to 10MB.
- **Cursor:** use a cursor-highlight tool (`Mouseposé` or `Cursor Highlighter`) so motion reads from a thumbnail.
- **Cuts:** trim every "thinking" pause to <0.3s. The whole video should feel like one breath.
- **Audio:** no voiceover for the README version — just on-screen text overlays. Faster to consume from a card view.

## Output spec

- `docs/demo.mp4` — the 60s video, ≤10MB. Linked from README hero.
- `docs/demo.gif` — same content, ≤2MB. Fallback for renderers that can't inline MP4.

## Why this isn't recorded yet

Headless agent can't drive a screen recorder, browser, or terminal session interactively. This shot list exists so a human collaborator can shoot it in one sitting. If you want, I can also generate a frame-by-frame storyboard (still images) using the dashboard at each step.

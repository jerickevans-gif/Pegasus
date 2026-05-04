# CLAUDE.md — Podcast page

A dark-mode podcast site with episode list, audio players, platform links, about section.

## Working with me

- "Add a new episode" — I'll insert a new `<article>` with the right metadata.
- "Switch to light mode" — I'll flip stone-950/50/300/400 to light-mode equivalents.
- "Add a transcript per episode" — I'll add an expandable details element under each.
- "Auto-pull from RSS" — I'll add a small fetch script that reads your RSS feed and renders episodes dynamically.

## Audio source

Replace each `<source src="">` with the actual MP3 URL. Most podcast hosts (Transistor, Captivate, Anchor, Buzzsprout) give you a direct MP3 URL for each episode.

## Footer

The "Made with Pegasus" link is optional — delete it freely.

## Deploy

`pegasus deploy` ships it.

# CLAUDE.md — Landing page

A single-page launch site (the kind you spin up in an afternoon to validate an idea or collect early-access signups).

## Stack

- One `index.html`. Tailwind via CDN. No build step.
- Inter (Google Fonts).
- The signup form is currently fake (just shows a thanks message). Wire it to a real backend when you're ready — common options:
  - **Formspree** (`https://formspree.io`) — change the form's `action` to your endpoint.
  - **ConvertKit / Mailchimp / Beehiiv** — embed their signup form snippet.
  - **A simple `mailto:`** — quickest, just opens the user's email client.

## Working with me on this

- The headline + subhead drive everything else. Iterate on those first.
- For social proof (logos, testimonials), add a section between the form and the footer.
- For a video demo, use `<video src="..." autoplay muted loop>` or embed YouTube/Loom.

## Preview / Deploy

`npx serve .` for local preview, `pegasus deploy` to push live.

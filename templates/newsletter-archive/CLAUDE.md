# CLAUDE.md — Newsletter archive

Landing page + past-issues archive for a newsletter. Email signup form is fake by default — wire to your real provider.

## Wire up signup

The form action is empty. Replace with your provider's endpoint:
- **Buttondown:** `<form action="https://buttondown.email/api/emails/embed-subscribe/<your-username>" method="post">`
- **ConvertKit:** use their embed snippet
- **Mailchimp:** use their embed snippet
- **Substack/Beehiiv/Ghost:** they each have an embed; paste it inline

## Past issues

Hand-edit the `<ol>` for now. To auto-pull from your hosting provider's RSS:
- "Add a fetch script that loads the latest 10 issues from this RSS URL: ..."

## Footer

The "Made with Pegasus" link is optional — designers commonly remove it.

## Deploy

`pegasus deploy`.

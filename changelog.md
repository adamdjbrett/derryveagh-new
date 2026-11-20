## 2026-11-19 — Project attribution, citations and feeds

- Added IndieWeb entry and author markup to the homepage, articles and post listings. Source bylines on primary texts now flow into the public byline, metadata and feeds. One unattributed eyewitness account is labeled “Uncredited.”
- Added Zotero citation fields, Dublin Core and linked Schema.org records to public page heads. The records distinguish the website, the digital humanities research project, creator Robert Spiegelman and sponsor Indigenous Values Initiative. The root and article JSON sidecars use the same identities.
- Set the canonical origin to https://derryveagh.com and added discovery links for the Atom, RSS, JSON and twtxt feeds. All four list the same ten latest posts. XMIT sets explicit media types for Atom, RSS and JSON Feed.
- Added plain-text credits, refreshed the humans file and retained the public crawl and sitemap declarations in robots.txt.

The production build and output checks passed for 88 public page heads, 59 post sidecars and all seven requested endpoints. The bylines for the Glenveagh verse, Bloomfield excerpts and Underwood ballad were checked against the attributed texts and author record. [Glenveagh Castle](https://www.ireland-fun-facts.com/glenveagh-castle.html) · [University College Cork](https://celt.ucc.ie/document/E850006-002/) · [Dictionary of Irish Biography](https://www.dib.ie/biography/underwood-thomas-neilson-a8764)

## 2026-11-19

- Set the XMIT and HTML referrer policies to `strict-origin-when-cross-origin`. HTTPS requests to Cloudflare Insights carry the site origin while keeping page paths private.
- Allow Cloudflare Insights scripts and requests, YouTube players, and Font Awesome styles, fonts, and kit requests in the public pages’ Content Security Policy.
- Remove the retired Universal Analytics tag and retain the active GA4 measurement tag.
- Pin Ruby 4.0.10 for local builds and CI, and lock Jekyll 4.4.1 with its dependencies for macOS and Linux.
- Load Minimal Mistakes 4.28.1 from the installed theme gem and retain the site’s custom templates and styles.
- Send the site origin on YouTube embeds to address player error 153.
- Use the public introduction already linked on the page. The former embedded upload is private.
- Link feature images to their card destinations and keep their links above the card overlay.
- Replace the Font Awesome kit that returned HTTP 403 with the versioned public icon stylesheet.

### Verification

The production build passed under Ruby 4.0.10 and Bundler 4.1.0. A Chrome crawl of 90 non-redirect pages found no first-party console errors. All same-site asset paths referenced by the 95 generated HTML files resolved. Chrome and Firefox both received a readable HTTP 200 response from the reported Cloudflare beacon URL.

The YouTube introduction played in Chrome and Firefox. Feature image links matched their card destinations in both browsers.

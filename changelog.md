## 2026-11-19 — Standalone theme, plugin reduction and minification

- Imported the 20 missing runtime theme files from the checksum-verified Minimal Mistakes 4.28.1 package. Retained the site’s existing theme overrides and compiled JavaScript. The Jekyll configuration explicitly disables theme-gem loading. The README documents independent builds and preview.
- Replaced the two custom Ruby plugins with Liquid. Per-post JSON files share the page metadata template. A three-line source file declares each companion URL, and the build verifier checks it against the post.
- Reduced the site bundle to two Jekyll plugins, `jekyll-paginate` and `jekyll-redirect-from`. Local templates generate Atom and the XML sitemap alongside the existing RSS, JSON Feed and twtxt templates. GitHub Pages supplies additional built-in plugins in its hosted runtime.
- Minified HTML during rendering while preserving the contents of scripts, styles and preformatted blocks. Sass continues to emit compressed CSS.

Production Jekyll 4.4.1 and GitHub Pages 232 with Jekyll 3.10.0 both built the site locally and passed metadata and feed verification. The Jekyll 4 comparison preserved the structured data on 88 themed pages and all 59 post metadata documents, the 90 sitemap URLs, and the redirect map. Themed HTML was 11.5% smaller. Chrome opened the homepage and introduction without console errors, followed all three feature image targets in hit testing, and played the introduction.

Enabled Ruby’s YJIT compiler for the XMIT build step. Across three local production builds of each version, median Jekyll time went from 0.71 seconds to 0.85 seconds. These figures cover the Jekyll build and exclude dependency installation and deployment.

## 2026-11-19 — Cloudflare beacon and XMIT upload

- Verified that the live homepage’s Cloudflare beacon returned HTTP 200 with 31,853 bytes in Firefox and Chrome. Its SHA-512 matched the integrity attribute and its response allowed anonymous cross-origin access. The digest in the Firefox error matched zero bytes.
- Added one retry when XMIT reports a chunk upload failure with `tls: bad record MAC`. The supplied deployment log shows that Jekyll and the output checks passed before this transfer failed.

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

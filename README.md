# Archival Version of [derryveagh.com](https://derryveagh.com)

[![Deploy Jekyll to XMIT](https://github.com/adamdjbrett/derryveagh-new/actions/workflows/xmit-deploy.yml/badge.svg)](https://github.com/adamdjbrett/derryveagh-new/actions/workflows/xmit-deploy.yml)

## Build this site

Use the Ruby version in `.ruby-version` and run the following from this repository.

```sh
bundle install
RUBY_YJIT_ENABLE=1 JEKYLL_ENV=production bundle exec jekyll build
bundle exec ruby _scripts/verify_metadata.rb
```

Run `bundle exec jekyll serve` for a live preview. Jekyll reads the layouts, includes, Sass, data, and JavaScript from this repository. Existing project files take precedence in any future upstream update. Missing theme files were imported from [Minimal Mistakes 4.28.1](https://github.com/mmistakes/minimal-mistakes/tree/4.28.1).

The two Jekyll plugins provide numbered archive pages and redirects. The feeds, sitemap, citation fields, JSON-LD, and HTML compression use Liquid. Sass compresses the compiled CSS.

Each published post has a three-line source file under `_pages/post-metadata/`. For a new post at `/texts/example/`, create `_pages/post-metadata/example.json` with the following content. Update its permalink when moving a post. The shared layout reads the post’s current metadata, and the verifier checks its output against the page head.

```yaml
---
permalink: /texts/example/metadata.json
---
```


hosted on [xmit.co](https://xmit.co)
archive of derryveagh.com

# To Do
  - fix colors
  - gallery cover images
  - redirects
  - footer (all four sites)

### Options
I can do a sidebar but on mobile it really pushes the content down where it isn’t visible

### Done
- add videos
  - home.swf done
  - home3.swf done
  - allfilm.swf broken
  - slideshow.swf broken
- image archive index
    - add config.yml
    - use image-archive template
## Colors
  - Background: Dark Brown \#130F0C
  - Alt: sidebar Brown \#292212
  - Title: Green \#004F2F
  - Accent: Orange \#004F2F
  - Alt: Brown \#B9B195

  - Font color: \#af916
  - Link color: \#676C4D

## missing
  - Thatching Matters

---
title: Documentation site maintenance
parent: Setup
nav_order: 10
---

# Documentation site maintenance

The README is the Jekyll homepage and `docs/` contains the detail pages. The site uses Just the Docs, with its default page layout set in `_config.yml`.

## Theme and deployment

`remote_theme: just-the-docs/just-the-docs@latest` selects the latest release. The `jekyll-remote-theme` dependency requires version 0.5.2 or newer for this support.

`.github/workflows/docs.yml` resolves the latest stable theme release through GitHub's API on each build and temporarily pins the build configuration to that tag. The source configuration keeps `@latest`; the workflow does not commit theme updates. Failed release resolution stops the build.

- Pushes to `main` build and deploy the site.
- Pull requests build without deploying.
- Manual dispatch builds the selected ref and deploys only when that ref is `main`.

GitHub Pages must use **GitHub Actions** under **Settings → Pages → Build and deployment → Source**. The workflow and site changes must reach GitHub before the first new deployment can run. An upstream theme release alone does not trigger a build; push a change or dispatch the workflow to rebuild.

The workflow runs `bundle exec jekyll build` and uploads `_site` for deployment. It does not run the deferred package, helper, client or documentation test suites. A successful build is not evidence that those tests passed.

## Local preview

With Ruby and Bundler available:

```sh
bundle install
bundle exec jekyll serve
```

Open the address printed by Jekyll, including `/agent-helm/`. Restart the preview to resolve a newer theme release. The existing `bundle exec rake test` command remains available when testing resumes.

## Appearance and links

The header offers **System**, **Light** and **Dark**. System follows the operating system's colour preference, including changes while the page is open. Explicit choices are saved under `agent-helm-theme` in browser storage and shared across tabs. If storage is blocked, switching still works for the current page. With JavaScript disabled, the control stays hidden and the default theme remains usable.

The selector lives in `_includes/header_custom.html`, its script in `assets/js/theme-switcher.js` and its styles in `_sass/custom/custom.scss`. `_includes/head_custom.html` loads the preference early and retains the existing Mermaid rendering.

Links use normal browser behaviour: same-tab navigation by default, with modifier keys, middle-click and context menus left to the reader. The theme's external navigation and auxiliary links explicitly disable forced new tabs. README links remain ordinary Markdown links with absolute documentation URLs so they also work on GitHub and in the distributed plugin package. GitHub controls its own README renderer.

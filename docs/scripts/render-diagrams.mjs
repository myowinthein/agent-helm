import { chromium } from 'playwright-core';
import { dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import { allowOnlyOrigin, chromeExecutable, listenOnLoopback, staticFiles } from './browser.mjs';

const root = resolve(dirname(fileURLToPath(import.meta.url)), '../node_modules/mermaid/dist');
const executablePath = await chromeExecutable('build diagrams');

let input = '';
for await (const chunk of process.stdin) input += chunk;
const diagrams = JSON.parse(input);
const files = staticFiles(root, { contentType: () => 'text/javascript' });
const { server, origin } = await listenOnLoopback((request, response) => {
  if (new URL(request.url, 'http://localhost').pathname === '/') {
    response.setHeader('Content-Type', 'text/html');
    response.end('<!doctype html><html><head><meta charset="utf-8"></head><body></body></html>');
    return;
  }
  return files(request, response);
});
let browser;
try {
  browser = await chromium.launch({ executablePath, headless: true });
  const page = await browser.newPage({ viewport: { width: 1280, height: 900 } });
  await allowOnlyOrigin(page, origin);
  await page.goto(origin);
  const rendered = await page.evaluate(async diagrams => {
    const { default: mermaid } = await import('/mermaid.esm.min.mjs');
    mermaid.initialize({ startOnLoad: false, theme: 'neutral', securityLevel: 'loose', deterministicIds: true });
    const output = {};
    for (const [id, source] of Object.entries(diagrams)) {
      const result = await mermaid.render(`diagram-${id}`, source);
      const svg = new DOMParser().parseFromString(result.svg, 'image/svg+xml').documentElement;
      const [, , width, height] = svg.getAttribute('viewBox').split(/\s+/).map(Number);
      // Keep direct SVG views readable; the guide's image CSS scales its preview.
      svg.setAttribute('width', width);
      svg.setAttribute('height', height);
      for (const theme of ['light', 'dark']) {
        const view = document.createElementNS('http://www.w3.org/2000/svg', 'view');
        view.id = `theme-${theme}`;
        view.setAttribute('viewBox', svg.getAttribute('viewBox'));
        svg.append(view);
      }
      // Embedded SVG media queries inherit the page's selected color-scheme.
      const selector = `#diagram-${id}`;
      const palettes = {
        light: `--diagram-text: #27262b;
          --diagram-surface: #f5f6fa;
          --diagram-line: #5c5962;
          --diagram-background: #fff;`,
        dark: `--diagram-text: #e6e1e8;
          --diagram-surface: #302d36;
          --diagram-line: #a6a1ad;
          --diagram-background: #27262b;`,
      };
      const colors = `<style>
        ${selector} {
          ${palettes.light}
          background-color: var(--diagram-background);
        }
        @media (prefers-color-scheme: dark) {
          ${selector} {
            ${palettes.dark}
          }
        }
        ${selector}:has(> #theme-light:target) { ${palettes.light} }
        ${selector}:has(> #theme-dark:target) { ${palettes.dark} }
        ${selector} text, ${selector} span, ${selector} p, ${selector} .label,
        ${selector} .cluster text, ${selector} .cluster span {
          fill: var(--diagram-text);
          color: var(--diagram-text);
        }
        ${selector} .node > :is(rect, circle, ellipse, polygon, path), ${selector} .cluster rect {
          fill: var(--diagram-surface);
          stroke: var(--diagram-line);
        }
        ${selector} .flowchart-link, ${selector} .edgePath .path {
          stroke: var(--diagram-line);
        }
        ${selector} .marker, ${selector} .arrowheadPath {
          fill: var(--diagram-line);
          stroke: var(--diagram-line);
        }
        ${selector} .edgeLabel, ${selector} .edgeLabel rect, ${selector} .labelBkg {
          background-color: var(--diagram-surface);
          fill: var(--diagram-surface);
          opacity: 1;
        }
      </style>`;
      output[id] = new XMLSerializer().serializeToString(svg).replace('</svg>', `${colors}</svg>`);
    }
    return output;
  }, diagrams);
  process.stdout.write(JSON.stringify(rendered));
} finally {
  await browser?.close();
  await new Promise(resolve => server.close(resolve));
}

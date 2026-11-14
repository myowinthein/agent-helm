import { createServer } from 'node:http';
import { access, readFile } from 'node:fs/promises';
import { join, resolve, sep } from 'node:path';

// Shared by the diagram renderer and the browser checks, which both drive a
// local Chrome against a loopback server that serves no other origin.
export async function chromeExecutable(purpose) {
  const candidates = [
    process.env.HELM_DOCS_CHROME,
    '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome',
    '/usr/bin/google-chrome',
    '/usr/bin/chromium',
    process.env.PROGRAMFILES && join(process.env.PROGRAMFILES, 'Google/Chrome/Application/chrome.exe'),
  ].filter(Boolean);
  for (const path of candidates) {
    try { await access(path); return path; } catch {}
  }
  throw new Error(`Chrome is required to ${purpose}. Set HELM_DOCS_CHROME to its executable.`);
}

export function staticFiles(root, { rewrite = pathname => pathname, contentType }) {
  return async (request, response) => {
    try {
      const pathname = rewrite(decodeURIComponent(new URL(request.url, 'http://localhost').pathname));
      const path = resolve(root, `.${pathname}`);
      if (!path.startsWith(root + sep)) throw new Error('Outside the served directory');
      response.setHeader('Content-Type', contentType(path));
      response.end(await readFile(path));
    } catch {
      response.writeHead(404).end();
    }
  };
}

export async function listenOnLoopback(handler) {
  const server = createServer(handler);
  await new Promise(resolve => server.listen(0, '127.0.0.1', resolve));
  return { server, origin: `http://127.0.0.1:${server.address().port}` };
}

export function allowOnlyOrigin(target, origin) {
  return target.route('**/*', route => new URL(route.request().url()).origin === origin ? route.continue() : route.abort());
}

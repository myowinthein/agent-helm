"""Opt-in loopback preview of the built site, with isolated theme fault controls.

Uses the actual built HTML/CSS/JavaScript. The blocked route injects Storage's
SecurityError before startup; it does not change browser or OS privacy settings.
"""
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from urllib.parse import urlsplit

SITE = Path(__file__).resolve().parents[1] / "_site"
CONTROLS = """<aside aria-label="Helm test controls" style="position:fixed;bottom:0;right:0;z-index:10000;background:white;color:black;padding:1rem;border:2px solid gray">
<button id="invalid" onclick="localStorage.setItem('agent-helm-theme','invalid-fixture');document.getElementById('test-status').textContent='invalid done'">Save invalid theme</button>
<button id="remove" onclick="localStorage.removeItem('agent-helm-theme');document.getElementById('test-status').textContent='remove done'">Remove theme key</button>
<button id="clear" onclick="localStorage.clear();document.getElementById('test-status').textContent='clear done'">Clear test-origin storage</button>
<a href="/__helm_checks__/theme">Normal storage</a>
<a href="/__helm_checks__/blocked">Blocked storage</a>
<output id="test-status">Ready</output>
</aside>"""
FAULT = """<script>Object.defineProperty(window,'localStorage',{get(){
throw new DOMException('Synthetic blocked storage','SecurityError');}});</script>"""


class Handler(SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=str(SITE), **kwargs)

    def do_GET(self):
        route = urlsplit(self.path).path
        if route in ("/__helm_checks__/theme", "/__helm_checks__/blocked"):
            page = (SITE / "docs/setup/codex.html").read_text()
            page = page.replace("</body>", CONTROLS + "</body>")
            if route.endswith("/blocked"):
                page = page.replace("<head>", "<head>" + FAULT, 1)
            raw = page.encode()
            self.send_response(200)
            self.send_header("Content-Type", "text/html; charset=utf-8")
            self.send_header("Content-Length", str(len(raw)))
            self.end_headers()
            self.wfile.write(raw)
        else:
            super().do_GET()

    def translate_path(self, path):
        if path.startswith("/agent-helm/"):
            path = path[len("/agent-helm"):]
        return super().translate_path(path)

    def log_message(self, *_):
        pass


if __name__ == "__main__":
    if not (SITE / "docs/setup/codex.html").is_file():
        raise SystemExit("Build the site before starting browser acceptance.")
    server = ThreadingHTTPServer(("127.0.0.1", 0), Handler)
    print(f"http://127.0.0.1:{server.server_port}/__helm_checks__/theme", flush=True)
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        pass
    finally:
        server.server_close()

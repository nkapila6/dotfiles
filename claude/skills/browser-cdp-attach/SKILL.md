---
name: browser-cdp-attach
description: Attach a harness's native CDP browser tool (omp's browser) to an already-running terminal-browser instead of launching a headless one. Use when you need the browser tool and a terminal-browser is open.
---

If the harness has a browser tool that can attach over CDP (omp's `browser` takes
`app.cdp_url`), attach it to the running terminal-browser so the user sees what you do.

1. `terminal-browser ls --json` and take the CDP port of the browser you want.
2. Pass `http://127.0.0.1:<port>` as the CDP url.
3. If attaching fails or no browser is running, use the `terminal-browser action` CLI instead.

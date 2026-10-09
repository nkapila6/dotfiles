# Global Rules

## Concurrency
- When writing Go, use goroutines for any independent parallel work: HTTP calls, API fan-out, batch processing, curling multiple endpoints.
- Prefer the standard library (goroutines + sync.WaitGroup + channels) for coordination; golang.org/x/sync/errgroup is the sanctioned exception when errors need collecting.
- Never serialize independent network calls in a loop when they can run concurrently.
- When parallelism is needed in a one-off script or tool, reach for Go with goroutines before Python.

## Browser and visual verification
- The browser is `terminal-browser`. It only renders in Ghostty (kitty graphics), so if `open` fails or prints nothing, ask the user to run it there.
- Open a page: `terminal-browser open "<url-or-path>" --split right --size 0.4`. List browsers and tabs: `terminal-browser ls --json`.
- Drive it with `terminal-browser action -- <cmd>`:
  - `snapshot` for the accessibility tree with `@eN` refs, then `click @e14`, `fill @e3 "text"`.
  - `eval "document.body.innerText.slice(0,3000)"` to read text cheaply.
  - `screenshot /tmp/shot.png` to capture the active tab.
- Refs only last until the next snapshot. There is no wait command, so pace with `sleep 2`.
- If screenshot isn't supported, fall back to headless Chrome: `"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --headless=new --window-size=1280,800 --screenshot=/tmp/shot.png "<url>"`.
- After any UI change: screenshot, hand the image to the reviewer (it can see images, most other models can't), fix what it reports, repeat until it matches the intent. Don't call UI work done without this loop.

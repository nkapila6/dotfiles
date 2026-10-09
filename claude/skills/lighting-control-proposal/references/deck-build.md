# Deck build: stack, design system, commands

## Stack

Only two things are hard requirements: **Node with pptxgenjs**, and **LibreOffice
plus Poppler** for visual QA. Everything else has a fallback.

| Need | First choice | Fallback if unavailable |
|---|---|---|
| Generate the pptx | `pptxgenjs` via Node | none, this one is required |
| Confirm the file opens | bundled `validate.py` if present | python-pptx open plus a LibreOffice convert (see below) |
| Render to images | `soffice` headless then `pdftoppm` | none practical, get LibreOffice |
| Deliver the file | whatever the host uses to hand files to the user | tell the user the path |

### pptxgenjs

Try to require it before installing. In some sandboxes it is already installed
globally and resolves from any directory:

```bash
node -e "require('pptxgenjs'); console.log('present')" \
  || npm install -g pptxgenjs
```

A local `npm install pptxgenjs` in the working directory works equally well and
is the safer default on an unknown host.

### Validation

`validate.py` unpacks the OOXML package and checks every part against the
ISO/IEC 29500-4:2016 XSD schemas, plus structural checks on relationships,
content types and charts. It is vendored into this skill at `assets/office/`. There
is no `pip install` for it. Use it directly. `--with defusedxml --with lxml`
pulls the two runtime dependencies into an ephemeral environment, so nothing
is installed persistently:

```bash
uv run --with defusedxml --with lxml python assets/office/validate.py deck.pptx
```

If it is not, use the round-trip test instead. It catches the failure mode that
actually matters, which is PowerPoint refusing to open the file:

```bash
uv run --with python-pptx python -c "from pptx import Presentation; Presentation('deck.pptx'); print('opens')"
# then confirm LibreOffice can convert it, which the render step does anyway
```

For stricter checking, `uv run --with xmlschema python ...` and validate
`ppt/slides/*.xml` against `pml.xsd` from the freely published ECMA-376 schema
set.

### Rendering

The portable command needs an explicit LibreOffice profile directory. Without
it, a non-root or sandboxed user hits "User installation could not be completed"
and nothing converts:

```bash
soffice --headless -env:UserInstallation=file:///tmp/lo_profile \
        --convert-to pdf deck.pptx --outdir .
```

Some sandboxes additionally block `AF_UNIX` sockets, which LibreOffice needs
internally. Where that is the case the pptx skill ships a wrapper that detects
the restriction and applies an `LD_PRELOAD` shim. Prefer it when it exists:

```bash
uv run --with defusedxml --with lxml python assets/office/soffice.py \
       --headless --convert-to pdf deck.pptx
```

If bare `soffice` hangs or exits without producing a PDF, that socket
restriction is the likely cause and the wrapper is the fix.

## Build and QA loop

```bash
mkdir -p work && cd work
# write build.js, then:
node build.js
# validate, by whichever route is available above
# render:
rm -f slide-*.jpg
pdftoppm -jpeg -r 110 deck.pdf slide
ls -1 "$PWD"/slide-*.jpg
# then look at every image
```

Re-render after every fix. The PDF does not regenerate itself.

To re-render a single slide during iteration, use `-f N -l N`:

```bash
pdftoppm -jpeg -r 110 -f 4 -l 4 deck.pdf slide
```

### Optional further reading

Anthropic's pptx skill (`github.com/anthropics/skills`, under `skills/pptx`)
carries a fuller list of pptxgenjs footguns and OOXML editing guidance. It is
source-available rather than open source. The office scripts this skill needs are
vendored under `assets/office/`, so this skill does not depend on the pptx skill
being installed; the rest of that skill is optional further reading. The
gotchas that matter for this deck are reproduced below.

## pptxgenjs gotchas that bit this deck

- Set `pres.layout = "LAYOUT_WIDE"` before adding slides. Canvas is 13.333 x 7.5
  inches. Coordinates past the edge are written, not clamped, so the shape
  silently vanishes.
- Hex colours never take a `#` and never carry alpha. `color: "1F2933"`. Both
  `"#1F2933"` and 8-digit hex corrupt the file.
- pptxgenjs mutates option objects in place. Build a fresh `shadow` object per
  call, never share one across two `add*` calls. Use a `shadow()` factory.
- `rectRadius` only works on `ROUNDED_RECTANGLE`, not `RECTANGLE`.
- Shadow `offset` must be zero or positive.
- Bullets: `bullet: true` per item, `breakLine: true` on every item except the
  last, and space them with `paraSpaceAfter`, not `lineSpacing`.
- Text boxes have built-in padding. Set `margin: 0` whenever text must align
  with a shape at the same x.
- Speaker notes go in `slide.addNotes()`, never a text box.

## Design system

Neutral, engineering-document register. It should look like it came from a
consultancy, not a marketing team.

| Token | Hex | Use |
|---|---|---|
| Ink | `1F2933` | Dark backgrounds, headings, emphasis blocks |
| Charcoal | `36454F` | Body text |
| Slate | `7A8A99` | Rules, arrows, captions |
| Light | `F2F4F5` | Card fills on white |
| Alt card | `EDEEF0` | The competitor column, one step cooler than ours |
| Accent | `B06A2C` | Kickers, numbered circles, the one number that matters |

Typography: **Cambria** for headings and large numbers, **Calibri** for body.
Both ship with Office and render true to width in LibreOffice, so the visual QA
is trustworthy. Titles 30 to 44pt, section headers 14 to 15pt bold, body 12.5 to
13.5pt, captions 10 to 11pt.

Motif: rounded cards, radius 0.08, soft shadow, plus a small numbered circle.
Repeat it on every slide.

Never use accent stripes, colour bars, or a rule under the title. They read as
AI-generated filler and undercut the engineering register.

Structure: dark cover, light content slides, dark closing slide.

## Slide construction helpers

`assets/example_build.js` is a complete, validated 12-slide comparison deck.
It defines four helpers worth reusing:

- `contentSlide(title, kicker)` — title, kicker, auto-incrementing corner numeral
- `card(s, {x, y, w, h, fill})` — rounded card with shadow
- `bullets(s, items, {x, y, w, h})` — correctly spaced bullet block
- `shadow()` — fresh shadow object per call, avoiding the mutation bug

Layout patterns used across the deck, so no two slides look the same: stat
callout row, two-column comparison cards, striped row table, vertical flow
diagram with arrows, 2x2 numbered card grid, five-step horizontal flow, and a
native `addTable` matrix.

## Speaker notes

Put a note on every slide saying why the slide exists, not what it says. The
deck is often handed to someone else to present.

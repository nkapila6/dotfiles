---
name: lighting-control-proposal
description: Build a technical proposal deck for a lighting control system (DALI, Helvar, Casambi, KNX, Zigbee, wired or wireless), with or without a competing bid to compare against. Use this whenever the user mentions a lighting control quote, tender, bid, BOQ, luminaire or driver counts, DALI addresses, sensors and wall panels, or asks for a pptx or presentation to send alongside a lighting quotation. Also use it when the user is simply arguing a lighting control system's merits against another system, even if no deck is mentioned yet, because the address-capacity audit in this skill is the part that decides those arguments.
---

# Lighting control proposal deck

Produces a clean, technically defensible pptx that accompanies a lighting control
quotation. Works in two modes: **comparison** (a competitor's bid exists) and
**solution** (no competition, the deck justifies the design on its own merits).

The single most valuable thing this skill does is not the deck. It is the
capacity audit in Step 2. Lighting control bids are won and lost on address
arithmetic, and both sides of a bid are wrong surprisingly often. Do that audit
before designing a single slide.

---

## Step 1: Ask for the full scope

Never start from a partial BOQ. A deck built on an incomplete device count will
contain a capacity claim that collapses under review, which is worse than no deck.

Use the host's interactive-input tool for the multiple-choice parts if one is available; otherwise ask in chat. Gather:

**Device counts (all of them, because they all consume addresses)**
- Luminaires or DALI drivers
- Wall control points, and whether they are scene plates, rotary, or touch
- Sensors, and whether presence only or presence plus daylight
- Non-DALI loads: phase-dim interfaces, relay modules, 0-10V, DMX
- Emergency luminaires, and whether automatic testing is required
- Tunable white or colour (DALI DT8) fittings

**Project context**
- New build or retrofit, and whether containment for control cabling exists
- Number of floors, zones or rooms, and whether they are one contiguous system
- Is there a project Ethernet backbone, and who owns it
- Is BMS or third-party integration required now or later

**Commercial context**
- Who reads the deck: end client, MEP consultant, main contractor, or a supplier
  reselling onward. This changes the deck more than any technical input.
- Price position relative to the competition, if known
- Branded or neutral output

If the user has already given some of this in conversation, extract it and ask
only for the gaps. Do not re-ask what they have told you.

---

## Step 2: Ask whether there is a competitor

Do not assume a competitive bid. Many proposals are sole-source, and a comparison
deck sent into a sole-source situation invents an opponent and looks defensive.

Ask directly: **is there a competing proposal, and do you have its BOQ?**

Three cases:

| Case | Mode | What the deck does |
|---|---|---|
| Competitor BOQ known | Comparison | Audits both, side by side, spec facts only |
| Competitor exists, BOQ unknown | Solution, hardened | Justifies the design against the requirements a competent alternative would also have to meet, without naming anyone |
| No competitor | Solution | Explains the design, the capacity headroom, and the handover |

In solution mode, drop the comparison slides entirely. Do not pad them with a
strawman. Replace them with design rationale, zoning, control narrative and
commissioning scope.

---

## Step 3: Ground every product claim in a web search

**Never state a device limit, address count, protocol capability, or product
feature from memory.** Product lines change, model numbers look alike, and a
single wrong capacity figure destroys the credibility of the whole document.
The audience for these decks is frequently a lighting engineer who will check.

Search before writing, for both sides of the bid:

- Manufacturer product pages for every model number in either BOQ. Confirm what
  the model actually is, not what the number suggests. Sensor part numbers in
  particular differ by one digit between a bare PIR and a multisensor.
- The controller or gateway datasheet, for the number of buses, networks or
  subnets and the addresses per bus.
- The competitor gateway's own documentation for what may be connected to it.
  Wireless gateways that sit on a DALI bus frequently accept drivers only.
- Any app, cloud or licensing claim you intend to make on either side.

Then cite the source on the slide itself, in small muted text. A capacity claim
with a named source is an engineering statement. The same claim without one is
marketing, and gets discounted as such.

`references/product-data.md` holds verified figures from previous jobs as a
starting point for what to search for. **Treat it as a checklist of things to
confirm, never as a citable source.**

---

## Step 4: Run the capacity audit

Compute the total addressable device count on each side:

```
luminaires + wall plates + sensors + load interfaces = total addresses required
```

Wall plates and sensors are the step people miss. On standard DALI and on
proprietary single-master buses such as Helvar DIGIDIM, control devices consume
short addresses from the same 64 as the drivers. Only DALI-2 multi-master gives
control devices their own separate 64.

Then check three things:

1. **Addresses.** Total required against total available, per bus and in
   aggregate. Flag any bus over 64.
2. **Bus current.** Typically 250 mA per DALI line. Budget roughly 2 mA per
   driver, 10 mA per panel, 5 mA per sensor as a first pass, then confirm
   against the actual driver datasheet. An address-compliant design that
   exceeds bus current is still a failed design.
3. **Device compatibility.** Confirm the control devices are supported by the
   chosen controller. Some controllers support DALI-2 control gear but not
   DALI-2 control devices, which quietly rules out third-party panels and
   sensors.

Report failures on **both** sides to the user before building anything. Finding
a hole in the competitor's BOQ is only useful if your own survives the same test.
Present the fix options and let the user choose; do not silently correct their
bill of quantities.

---

## Step 5: Match the deck to the audience

**End client or consultant.** Technical depth, compliance framing, direct
advocacy. First person is fine.

**A supplier or reseller selling onward.** This is a sales-enablement document,
not a pitch. Three consequences:

- Neutral voice throughout, no first person, so they can rebrand and forward it.
- Attack the product spec, never the brand. They very likely sell the competing
  brand on other jobs. "This gateway addresses 64 drivers" is a fact they can
  repeat. "That system is amateur hour" burns their other supply line and makes
  you the problem.
- Every claim must survive being repeated by someone who does not understand it.
  That means published numbers and arithmetic, not adjectives.

**Price.** If the proposal is the cheaper one, do not lead with it. Cheaper and
better reads as a scope omission. Put price last, once, with a one-line
structural explanation of why the gap exists.

---

## Step 6: Build the deck

Slide skeleton for **comparison mode** (12 slides):

1. Cover, neutral, project and client only
2. Scope as the yardstick: stat callouts and the total device count
3. Capacity check: the decisive slide, arithmetic against published limits, sourced
4. What sits on which bus: row comparison of drivers, panels, sensors, command path
5. The two topologies drawn side by side
6. Where the wireless or app layer actually sits
7. Commissioning and what gets handed over
8. Who holds the system after handover, framed as questions to ask the other supplier
9. Expansion path, tied back to spare capacity
10. Where the competing approach genuinely wins
11. Summary comparison matrix, one page a salesperson can work from alone
12. Recommendation, price last

Slide skeleton for **solution mode** (9 slides):

1. Cover
2. Scope and the total device count
3. Capacity and headroom: what is used, what is spare, sourced
4. System topology
5. Control narrative: zones, scenes, sensor strategy, override behaviour
6. User interfaces: wall plates, app, integration
7. Commissioning and handover deliverables
8. Expansion path
9. Recommendation and commercial summary

**Slide 10 in comparison mode is not optional.** A comparison with no
concessions reads as marketing and gets discounted wholesale by anyone
technical. State plainly where the other approach is better, then state the
project facts that make it the wrong fit here.

Frame competitor weaknesses one of two ways only: as a published spec fact with
a citation, or as a question worth putting to their supplier. Never as an
accusation.

For the tech stack, design system and build commands, read
`references/deck-build.md` first. It covers what is required versus what has a
fallback, so the deck can be built on a host that lacks the bundled Office
tooling. A complete working generator is in `assets/example_build.js` and is the
fastest starting point.

---

## Step 7: QA before delivery

Non-negotiable, in this order:

1. `node build.js`
2. Confirm the file opens, by whichever route the host supports. See
   `references/deck-build.md`; there is no pip-installable validator, so the
   fallback is a python-pptx open plus a successful LibreOffice convert.
3. Render to images and **look at every slide**
4. Re-check the arithmetic on the capacity slide against the BOQ one final time

Then deliver the pptx file to the user (use the host's file-presenting capability if available, otherwise give them the file path), and tell the user in the chat message which
assumptions the deck bakes in that they still need to confirm. Bus current
assumptions and subnet splits are the usual candidates.

---

## Tone

Write the deck and the accompanying message straight to the point. No em dashes.
No agency polish. The user is a lighting engineer sending this to other lighting
people, and over-polished copy reads as though someone who does not understand
the system wrote it.

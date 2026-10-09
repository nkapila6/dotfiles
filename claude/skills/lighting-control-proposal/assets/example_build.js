/* Complete, validated 12-slide comparison deck. Reuse the helpers (shadow, contentSlide,
   card, bullets) and the layout patterns; replace all content. Built and verified with:
     node example_build.js
      uv run --with defusedxml --with lxml python assets/office/validate.py <out>.pptx  -> All validations PASSED
   If that validator is unavailable, confirm with python-pptx open + LibreOffice convert. */
const pptxgen = require("pptxgenjs");

const INK = "1F2933";
const CHAR = "36454F";
const SLATE = "7A8A99";
const LIGHT = "F2F4F5";
const WHITE = "FFFFFF";
const ACC = "B06A2C";
const MUTED = "5A6872";

const HF = "Cambria";
const BF = "Calibri";

const pres = new pptxgen();
pres.layout = "LAYOUT_WIDE";
pres.author = "Lighting Controls";
pres.title = "Office Project - Lighting Control System Comparison";

const W = 13.333;
const M = 0.7;
const CW = W - M * 2;

let idx = 0;

function shadow() {
  return { type: "outer", angle: 90, blur: 8, offset: 1, color: "9AA5AD", opacity: 0.25 };
}

function contentSlide(title, kicker) {
  idx += 1;
  const s = pres.addSlide();
  s.background = { color: WHITE };
  if (kicker) {
    s.addText(kicker.toUpperCase(), {
      x: M, y: 0.42, w: CW - 1.0, h: 0.28,
      fontFace: BF, fontSize: 11, bold: true, color: ACC, charSpacing: 1.6, margin: 0,
    });
  }
  s.addText(title, {
    x: M, y: kicker ? 0.72 : 0.55, w: CW - 1.0, h: 0.75,
    fontFace: HF, fontSize: 30, bold: true, color: INK, margin: 0, valign: "top",
  });
  s.addShape(pres.ShapeType.ellipse, {
    x: W - M - 0.42, y: 0.45, w: 0.42, h: 0.42, fill: { color: LIGHT },
  });
  s.addText(String(idx), {
    x: W - M - 0.42, y: 0.45, w: 0.42, h: 0.42,
    fontFace: BF, fontSize: 12, bold: true, color: MUTED, align: "center", valign: "middle", margin: 0,
  });
  return s;
}

function card(s, o) {
  s.addShape(pres.ShapeType.roundRect, {
    x: o.x, y: o.y, w: o.w, h: o.h,
    fill: { color: o.fill || LIGHT }, rectRadius: 0.08, line: { color: o.fill || LIGHT, width: 0 },
    shadow: shadow(),
  });
}

function bullets(s, items, o) {
  const arr = items.map((t, i) => ({
    text: t,
    options: { bullet: true, breakLine: i !== items.length - 1 },
  }));
  s.addText(arr, {
    x: o.x, y: o.y, w: o.w, h: o.h,
    fontFace: BF, fontSize: o.size || 13.5, color: o.color || CHAR,
    lineSpacing: 18, paraSpaceAfter: 7, margin: 0, valign: "top",
  });
}

/* ---------------------------------------------------------- 1. Cover */
{
  const s = pres.addSlide();
  s.background = { color: INK };
  s.addShape(pres.ShapeType.rect, { x: 0, y: 0, w: 0.0001, h: 0.0001, fill: { color: INK } });
  s.addText("OFFICE PROJECT", {
    x: M, y: 2.25, w: CW, h: 0.35,
    fontFace: BF, fontSize: 13, bold: true, color: ACC, charSpacing: 2.4, margin: 0,
  });
  s.addText("Lighting Control System", {
    x: M, y: 2.7, w: CW, h: 0.85,
    fontFace: HF, fontSize: 44, bold: true, color: WHITE, margin: 0,
  });
  s.addText("Technical comparison of two proposed control architectures", {
    x: M, y: 3.62, w: 9.6, h: 0.5,
    fontFace: BF, fontSize: 17, color: "C3CCD3", margin: 0,
  });
  s.addShape(pres.ShapeType.line, {
    x: M, y: 4.55, w: 3.2, h: 0, line: { color: "44525E", width: 1 },
  });
  s.addText("Prepared for Example Client", {
    x: M, y: 4.75, w: 6, h: 0.32,
    fontFace: BF, fontSize: 14, bold: true, color: WHITE, margin: 0,
  });
  s.addText("113 luminaires  ·  11 control points  ·  20 sensors  ·  2 decorative circuits", {
    x: M, y: 5.12, w: 9.5, h: 0.32,
    fontFace: BF, fontSize: 12, color: "8A97A1", margin: 0,
  });
  s.addNotes("Neutral cover. Branding assets to be added before issue.");
}

/* ---------------------------------------------------------- 2. Scope */
{
  const s = contentSlide("The system both offers are measured against", "Scope");
  const stats = [
    ["113", "DALI luminaires", "Individually addressable control gear"],
    ["11", "Wall control points", "Scene recall and manual override"],
    ["20", "Ceiling sensors", "Presence and daylight"],
    ["2", "Decorative circuits", "Phase-dimmed, 400 W each"],
  ];
  const cw = 2.95, gap = 0.24;
  stats.forEach((st, i) => {
    const x = M + i * (cw + gap);
    card(s, { x, y: 1.85, w: cw, h: 2.35 });
    s.addText(st[0], {
      x: x + 0.25, y: 2.02, w: cw - 0.5, h: 0.9,
      fontFace: HF, fontSize: 46, bold: true, color: INK, margin: 0,
    });
    s.addText(st[1], {
      x: x + 0.25, y: 2.95, w: cw - 0.5, h: 0.35,
      fontFace: BF, fontSize: 14, bold: true, color: CHAR, margin: 0,
    });
    s.addText(st[2], {
      x: x + 0.25, y: 3.32, w: cw - 0.5, h: 0.7,
      fontFace: BF, fontSize: 11.5, color: MUTED, margin: 0,
    });
  });
  card(s, { x: M, y: 4.5, w: CW, h: 1.35, fill: INK });
  s.addText("146", {
    x: M + 0.4, y: 4.72, w: 1.5, h: 0.9,
    fontFace: HF, fontSize: 42, bold: true, color: WHITE, margin: 0,
  });
  s.addText([
    { text: "addressable devices on the control network\n", options: { bold: true, color: WHITE, fontSize: 15 } },
    { text: "Every luminaire, wall plate, sensor and dimmer interface has to be reachable and individually controllable. This is the number every capacity claim in this document is checked against.", options: { color: "B9C4CC", fontSize: 12.5 } },
  ], {
    x: M + 2.0, y: 4.75, w: CW - 2.4, h: 0.95,
    fontFace: BF, lineSpacing: 16, margin: 0, valign: "top",
  });
  s.addNotes("Establish the yardstick before either system is discussed. 113 + 11 + 20 + 2 = 146.");
}

/* ---------------------------------------------------------- 3. Capacity */
{
  const s = contentSlide("Address capacity against the 64-address limit", "Capacity check");
  const colw = (CW - 0.35) / 2;

  card(s, { x: M, y: 1.8, w: colw, h: 4.05 });
  s.addText("Wired DALI, as proposed", {
    x: M + 0.3, y: 2.0, w: colw - 0.6, h: 0.32,
    fontFace: BF, fontSize: 14, bold: true, color: INK, margin: 0,
  });
  s.addText("192 addresses available", {
    x: M + 0.3, y: 2.42, w: colw - 0.6, h: 0.5,
    fontFace: HF, fontSize: 26, bold: true, color: INK, margin: 0,
  });
  bullets(s, [
    "Three DALI subnets: one 910 application controller (two subnets) plus one 905 (one subnet)",
    "146 devices distributed 51 / 51 / 44, every subnet inside the 64-address limit",
    "All 113 luminaires individually addressable, no broadcast grouping required",
    "46 spare addresses available at handover",
  ], { x: M + 0.3, y: 3.05, w: colw - 0.6, h: 2.6 });

  card(s, { x: M + colw + 0.35, y: 1.8, w: colw, h: 4.05, fill: "EDEEF0" });
  s.addText("Wireless mesh, as quoted", {
    x: M + colw + 0.65, y: 2.0, w: colw - 0.6, h: 0.32,
    fontFace: BF, fontSize: 14, bold: true, color: INK, margin: 0,
  });
  s.addText("64 drivers per gateway", {
    x: M + colw + 0.65, y: 2.42, w: colw - 0.6, h: 0.5,
    fontFace: HF, fontSize: 26, bold: true, color: ACC, margin: 0,
  });
  bullets(s, [
    "One SAL-1064 gateway is quoted; the manufacturer states a maximum of 64 DALI driver addresses per unit",
    "113 luminaires are in scope, a shortfall of 49 addresses",
    "Either a second gateway is added, or luminaires share addresses in broadcast groups and lose individual control",
    "Sensors and switches are additional radio nodes, not carried on this count",
  ], { x: M + colw + 0.65, y: 3.05, w: colw - 0.6, h: 2.6 });

  s.addText("Source: Casambi product documentation, Salvador Series 1000 (SAL-1016 / 1032 / 1064).", {
    x: M, y: 6.05, w: CW, h: 0.3,
    fontFace: BF, fontSize: 10, italic: true, color: SLATE, margin: 0,
  });
  s.addNotes("This is the slide that decides the comparison. It is arithmetic against a published limit, not opinion.");
}

/* ---------------------------------------------------------- 4. Which bus */
{
  const s = contentSlide("What actually sits on the DALI bus", "Architecture");
  s.addText("A gateway that converts DALI drivers into a wireless network is not the same thing as a DALI control system. The distinction matters at handover, not on day one.", {
    x: M, y: 1.75, w: CW - 0.6, h: 0.5,
    fontFace: BF, fontSize: 14, color: MUTED, margin: 0,
  });

  const rows = [
    ["Luminaire drivers", "On the wired bus, addressed", "On the wired bus, addressed"],
    ["Wall control points", "On the wired bus, addressed", "Bluetooth radio nodes"],
    ["Sensors", "On the wired bus, addressed", "Bluetooth radio nodes"],
    ["Commands travel", "Controller to device, wired", "Radio mesh, then gateway to driver"],
  ];
  const y0 = 2.58, rh = 0.82, c0 = 3.5, c1 = 4.4, c2 = 4.4;
  s.addText("Wired DALI, as proposed", {
    x: M + c0 + 0.2, y: y0 - 0.42, w: c1 - 0.4, h: 0.3,
    fontFace: BF, fontSize: 12, bold: true, color: INK, margin: 0,
  });
  s.addText("Wireless mesh, as quoted", {
    x: M + c0 + c1 + 0.2, y: y0 - 0.42, w: c2 - 0.4, h: 0.3,
    fontFace: BF, fontSize: 12, bold: true, color: INK, margin: 0,
  });
  rows.forEach((r, i) => {
    const y = y0 + i * rh;
    if (i % 2 === 0) {
      s.addShape(pres.ShapeType.rect, { x: M, y: y, w: CW, h: rh, fill: { color: "F7F8F9" }, line: { width: 0 } });
    }
    s.addText(r[0], {
      x: M + 0.2, y: y, w: c0 - 0.4, h: rh,
      fontFace: BF, fontSize: 13, bold: true, color: CHAR, valign: "middle", margin: 0,
    });
    s.addText(r[1], {
      x: M + c0 + 0.2, y: y, w: c1 - 0.4, h: rh,
      fontFace: BF, fontSize: 13, color: CHAR, valign: "middle", margin: 0,
    });
    s.addText(r[2], {
      x: M + c0 + c1 + 0.2, y: y, w: c2 - 0.4, h: rh,
      fontFace: BF, fontSize: 13, color: CHAR, valign: "middle", margin: 0,
    });
  });
  card(s, { x: M, y: 6.05, w: CW, h: 0.85, fill: INK });
  s.addText("The gateway manufacturer is explicit that DALI switches and sensors must not be connected to a Salvador. On that side of the comparison the wired bus carries luminaires only.", {
    x: M + 0.35, y: 6.17, w: CW - 0.7, h: 0.62,
    fontFace: BF, fontSize: 13, color: "D5DDE2", valign: "middle", margin: 0,
  });
  s.addNotes("Answers the claim that the wireless offer is 'on the DALI backbone'. It is on one end of it, in one direction.");
}

/* ---------------------------------------------------------- 5. Topology */
{
  const s = contentSlide("The two topologies side by side", "Architecture");
  const colw = (CW - 0.35) / 2;

  function stack(x, title, sub, boxes, tint) {
    card(s, { x, y: 1.8, w: colw, h: 4.5, fill: tint });
    s.addText(title, {
      x: x + 0.3, y: 1.98, w: colw - 0.6, h: 0.3,
      fontFace: BF, fontSize: 14, bold: true, color: INK, margin: 0,
    });
    s.addText(sub, {
      x: x + 0.3, y: 2.28, w: colw - 0.6, h: 0.3,
      fontFace: BF, fontSize: 11.5, italic: true, color: MUTED, margin: 0,
    });
    boxes.forEach((b, i) => {
      const y = 2.72 + i * 0.88;
      s.addShape(pres.ShapeType.roundRect, {
        x: x + 0.3, y: y, w: colw - 0.6, h: 0.66,
        fill: { color: b[2] }, rectRadius: 0.06, line: { color: b[2], width: 0 },
      });
      s.addText([
        { text: b[0] + "   ", options: { bold: true, color: b[3], fontSize: 12.5 } },
        { text: b[1], options: { color: b[3], fontSize: 11.5 } },
      ], {
        x: x + 0.5, y: y, w: colw - 1.0, h: 0.66,
        fontFace: BF, valign: "middle", margin: 0,
      });
      if (i < boxes.length - 1) {
        s.addShape(pres.ShapeType.line, {
          x: x + colw / 2, y: y + 0.66, w: 0, h: 0.22,
          line: { color: SLATE, width: 1.25, endArrowType: "triangle" },
        });
      }
    });
  }

  stack(M, "Wired DALI, as proposed", "Radio at the interface layer only", [
    ["Ethernet backbone", "project LAN", INK, WHITE],
    ["910 + 905 controllers", "3 DALI subnets", "DDE2E6", INK],
    ["Wired DALI bus", "192 addresses", "DDE2E6", INK],
    ["113 luminaires, 11 plates, 20 sensors, 2 dimmers", "all addressed", "DDE2E6", INK],
  ], LIGHT);

  stack(M + colw + 0.35, "Wireless mesh, as quoted", "Radio in the control path", [
    ["Bluetooth mesh", "approx. 148 nodes", INK, WHITE],
    ["11 switches, 20 sensors", "radio nodes, off the bus", "E4E6E8", INK],
    ["Salvador gateway", "64 driver addresses", "E4E6E8", INK],
    ["113 luminaires", "exceeds one gateway", "E4E6E8", INK],
  ], "EDEEF0");

  s.addNotes("Same information as the previous slide, drawn. Use whichever lands better with the audience.");
}

/* ---------------------------------------------------------- 6. Mobile */
{
  const s = contentSlide("Wireless control, at the layer where it belongs", "User experience");
  s.addText("Mobile control is not a reason to put radio in the control path. The proposed system delivers app control over the project Ethernet backbone while every command to a luminaire stays wired.", {
    x: M, y: 1.75, w: CW - 0.4, h: 0.55,
    fontFace: BF, fontSize: 14, color: MUTED, margin: 0,
  });

  const items = [
    ["SceneSet app", "Connects directly to the application controller over Ethernet or Wi-Fi. Supported on the 905, 910, 920 and 950."],
    ["Scene control", "Recall and modify scenes across lighting groups, including DALI Type 8 tunable white and colour."],
    ["No licence fee", "The app is free to use once the controller is commissioned and on the network."],
    ["HelvarNet over TCP/IP", "Open command interface for BMS, room booking and third-party integration later in the building's life."],
  ];
  const cw2 = (CW - 0.3) / 2, ch = 1.75;
  items.forEach((it, i) => {
    const x = M + (i % 2) * (cw2 + 0.3);
    const y = 2.5 + Math.floor(i / 2) * (ch + 0.28);
    card(s, { x, y, w: cw2, h: ch });
    s.addShape(pres.ShapeType.ellipse, { x: x + 0.3, y: y + 0.32, w: 0.34, h: 0.34, fill: { color: ACC } });
    s.addText(String(i + 1), {
      x: x + 0.3, y: y + 0.32, w: 0.34, h: 0.34,
      fontFace: BF, fontSize: 12, bold: true, color: WHITE, align: "center", valign: "middle", margin: 0,
    });
    s.addText(it[0], {
      x: x + 0.78, y: y + 0.3, w: cw2 - 1.1, h: 0.35,
      fontFace: BF, fontSize: 14.5, bold: true, color: INK, margin: 0,
    });
    s.addText(it[1], {
      x: x + 0.78, y: y + 0.68, w: cw2 - 1.1, h: 0.9,
      fontFace: BF, fontSize: 12.5, color: CHAR, lineSpacing: 16, margin: 0,
    });
  });
  s.addNotes("This is the answer to 'but their system has an app'. So does this one, without moving the control path onto radio.");
}

/* ---------------------------------------------------------- 7. Commissioning */
{
  const s = contentSlide("Commissioning and what gets handed over", "Delivery");
  const colw = (CW - 0.35) / 2;

  card(s, { x: M, y: 1.85, w: colw, h: 3.9 });
  s.addText("Wired DALI, as proposed", {
    x: M + 0.3, y: 2.05, w: colw - 0.6, h: 0.32,
    fontFace: BF, fontSize: 14, bold: true, color: INK, margin: 0,
  });
  bullets(s, [
    "Addressing schedule issued per subnet, luminaire by luminaire",
    "Configuration held in the controllers on site and in a project file",
    "Project file transfers to the client, any competent integrator can pick it up",
    "Faults are traceable to a physical address on a physical bus",
  ], { x: M + 0.3, y: 2.5, w: colw - 0.6, h: 3.1 });

  card(s, { x: M + colw + 0.35, y: 1.85, w: colw, h: 3.9, fill: "EDEEF0" });
  s.addText("Wireless mesh, as quoted", {
    x: M + colw + 0.65, y: 2.05, w: colw - 0.6, h: 0.32,
    fontFace: BF, fontSize: 14, bold: true, color: INK, margin: 0,
  });
  bullets(s, [
    "Devices are commissioned through the app on site",
    "Configuration is held in the network and its associated account",
    "Continued access depends on holding network sharing rights",
    "Diagnosing an unresponsive node means diagnosing an RF path",
  ], { x: M + colw + 0.65, y: 2.5, w: colw - 0.6, h: 3.1 });

  s.addText("Support calls land on the supplier, not the manufacturer. The question worth asking of either system is what a second engineer inherits in year three.", {
    x: M, y: 6.0, w: CW, h: 0.5,
    fontFace: BF, fontSize: 13.5, italic: true, color: MUTED, margin: 0,
  });
  s.addNotes("Aimed squarely at the reseller's own support exposure.");
}

/* ---------------------------------------------------------- 8. Ownership */
{
  const s = contentSlide("Who holds the system after handover", "Ownership");
  const items = [
    ["Hardware on site", "Controllers sit in the panel and hold the configuration. Daily operation needs no cloud service and no account."],
    ["Documented record", "The project file is a deliverable. It can be archived, reissued and picked up by a different contractor."],
    ["Access is not a subscription", "Nothing about routine control depends on continued access to a manufacturer's platform."],
  ];
  const cw3 = (CW - 0.5) / 3;
  items.forEach((it, i) => {
    const x = M + i * (cw3 + 0.25);
    card(s, { x, y: 1.9, w: cw3, h: 2.7 });
    s.addShape(pres.ShapeType.ellipse, { x: x + 0.3, y: 2.15, w: 0.4, h: 0.4, fill: { color: INK } });
    s.addText(String(i + 1), {
      x: x + 0.3, y: 2.15, w: 0.4, h: 0.4,
      fontFace: BF, fontSize: 13, bold: true, color: WHITE, align: "center", valign: "middle", margin: 0,
    });
    s.addText(it[0], {
      x: x + 0.3, y: 2.7, w: cw3 - 0.6, h: 0.4,
      fontFace: BF, fontSize: 14.5, bold: true, color: INK, margin: 0,
    });
    s.addText(it[1], {
      x: x + 0.3, y: 3.15, w: cw3 - 0.6, h: 1.2,
      fontFace: BF, fontSize: 12.5, color: CHAR, lineSpacing: 16, margin: 0,
    });
  });
  card(s, { x: M, y: 4.9, w: CW, h: 1.2, fill: LIGHT });
  s.addText("The equivalent question on the wireless offer is a fair one to put to its supplier: who holds administrator rights to the network, what happens if those rights are lost, and what is the documented route back to a working system.", {
    x: M + 0.35, y: 5.05, w: CW - 0.7, h: 0.9,
    fontFace: BF, fontSize: 13, color: CHAR, lineSpacing: 17, valign: "middle", margin: 0,
  });
  s.addNotes("Framed as a question to ask rather than an accusation. Keeps it defensible.");
}

/* ---------------------------------------------------------- 9. Expansion */
{
  const s = contentSlide("Where the system goes next", "Expansion");
  const steps = [
    ["Today", "146 devices across three subnets, 46 addresses spare"],
    ["Fit-out changes", "Re-grouping and re-scening in software, no rewiring"],
    ["Additional floors", "Further controllers join the same Ethernet workgroup"],
    ["Building systems", "BMS and third-party control over Ethernet I/O and HelvarNet"],
    ["Uncabled areas", "Wireless nodes added where containment is not viable"],
  ];
  const bw = (CW - 4 * 0.22) / 5;
  steps.forEach((st, i) => {
    const x = M + i * (bw + 0.22);
    card(s, { x, y: 2.35, w: bw, h: 2.5, fill: i === 0 ? INK : LIGHT });
    s.addText(st[0], {
      x: x + 0.22, y: 2.58, w: bw - 0.44, h: 0.4,
      fontFace: BF, fontSize: 13.5, bold: true, color: i === 0 ? WHITE : INK, margin: 0,
    });
    s.addText(st[1], {
      x: x + 0.22, y: 3.05, w: bw - 0.44, h: 1.5,
      fontFace: BF, fontSize: 12, color: i === 0 ? "C3CCD3" : CHAR, lineSpacing: 15, margin: 0,
    });
    if (i < steps.length - 1) {
      s.addShape(pres.ShapeType.line, {
        x: x + bw + 0.02, y: 3.6, w: 0.18, h: 0,
        line: { color: SLATE, width: 1.25, endArrowType: "triangle" },
      });
    }
  });
  s.addText("Nothing above requires the control architecture to be replaced. That is the practical difference between spare capacity and a system quoted at its ceiling.", {
    x: M, y: 5.3, w: CW - 0.5, h: 0.5,
    fontFace: BF, fontSize: 13.5, italic: true, color: MUTED, margin: 0,
  });
  s.addNotes("Ties expansion back to slide 3. Spare capacity is the recurring theme.");
}

/* ---------------------------------------------------------- 10. Fair hearing */
{
  const s = contentSlide("Where the wireless approach is the better answer", "A fair hearing");
  s.addText("These are real advantages and they should be weighed honestly. They matter most on work this project is not.", {
    x: M, y: 1.75, w: CW - 0.4, h: 0.4,
    fontFace: BF, fontSize: 14, color: MUTED, margin: 0,
  });
  const items = [
    ["No control cabling to sensors and switches", "Removes a first-fix trade and the containment that goes with it."],
    ["Faster on small installations", "Fewer devices, fewer terminations, quicker to energise."],
    ["Strong on retrofit", "Closed ceilings and occupied buildings, where new bus cable is disruptive or impossible."],
    ["Low configuration threshold", "App-driven set-up needs less specialist software and less training."],
  ];
  const cw4 = (CW - 0.3) / 2;
  items.forEach((it, i) => {
    const x = M + (i % 2) * (cw4 + 0.3);
    const y = 2.35 + Math.floor(i / 2) * 1.5;
    card(s, { x, y, w: cw4, h: 1.28 });
    s.addText(it[0], {
      x: x + 0.3, y: y + 0.22, w: cw4 - 0.6, h: 0.35,
      fontFace: BF, fontSize: 14, bold: true, color: INK, margin: 0,
    });
    s.addText(it[1], {
      x: x + 0.3, y: y + 0.6, w: cw4 - 0.6, h: 0.55,
      fontFace: BF, fontSize: 12.5, color: CHAR, lineSpacing: 15, margin: 0,
    });
  });
  card(s, { x: M, y: 5.55, w: CW, h: 1.1, fill: INK });
  s.addText("This project is a new-build office fit-out with containment already in the programme, 146 devices, and a client who will hold the system for the life of the building. On those three facts the wired argument holds.", {
    x: M + 0.35, y: 5.68, w: CW - 0.7, h: 0.85,
    fontFace: BF, fontSize: 13, color: "D5DDE2", lineSpacing: 17, valign: "middle", margin: 0,
  });
  s.addNotes("Do not cut this slide. A comparison with no concessions gets discounted wholesale by anyone technical.");
}

/* ---------------------------------------------------------- 11. Matrix */
{
  const s = contentSlide("Summary comparison", "Side by side");
  const head = ["", "Wired DALI, as proposed", "Wireless mesh, as quoted"];
  const rows = [
    ["Address capacity", "192 available, 146 used", "64 drivers per gateway, 113 in scope"],
    ["Individual luminaire control", "All 113", "Requires a second gateway"],
    ["Sensors and switches", "Wired, on the addressed bus", "Bluetooth radio nodes"],
    ["Control path", "Wired and deterministic", "RF mesh to a gateway"],
    ["Mobile control", "SceneSet over Ethernet or Wi-Fi", "Manufacturer app over Bluetooth"],
    ["Configuration record", "Project file, transferable", "App and network sharing rights"],
    ["BMS and third-party", "Ethernet I/O and HelvarNet", "Gateway plus cloud API"],
    ["Control cabling required", "Yes, luminaires and controls", "Luminaires only"],
    ["Spare capacity at handover", "46 addresses", "None as quoted"],
  ];
  const body = [
    head.map((h, i) => ({
      text: h,
      options: {
        bold: true, color: WHITE, fill: { color: INK }, fontSize: 12,
        align: i === 0 ? "left" : "left", valign: "middle",
      },
    })),
    ...rows.map((r, ri) =>
      r.map((c, ci) => ({
        text: c,
        options: {
          bold: ci === 0,
          color: ci === 0 ? INK : CHAR,
          fill: { color: ri % 2 === 0 ? "F7F8F9" : WHITE },
          fontSize: 11.5,
          valign: "middle",
        },
      }))
    ),
  ];
  s.addTable(body, {
    x: M, y: 1.75, w: CW,
    colW: [3.4, 4.25, 4.28],
    rowH: 0.44,
    border: { type: "solid", color: "E1E5E8", pt: 1 },
    fontFace: BF,
    margin: [4, 8, 4, 8],
  });
  s.addNotes("One page the salesperson can work from without reading the rest of the deck.");
}

/* ---------------------------------------------------------- 12. Close */
{
  idx += 1;
  const s = pres.addSlide();
  s.background = { color: INK };
  s.addText("RECOMMENDATION", {
    x: M, y: 0.85, w: CW, h: 0.35,
    fontFace: BF, fontSize: 12, bold: true, color: ACC, charSpacing: 2.4, margin: 0,
  });
  s.addText("Compliant on capacity, documented at handover, and the lower-cost offer", {
    x: M, y: 1.3, w: CW - 1.2, h: 1.1,
    fontFace: HF, fontSize: 32, bold: true, color: WHITE, margin: 0,
  });
  const pts = [
    ["Compliant today", "Three subnets carry all 146 devices individually addressed, with 46 addresses spare. The alternative as quoted is 49 driver addresses short."],
    ["Transferable tomorrow", "The system is handed over as documented hardware and a project file, not as access rights to an account."],
    ["Lower cost", "One wired controller pair with passive wall plates and sensors is less hardware than 146 individually radio-enabled nodes. The saving is structural, not a reduction in scope."],
  ];
  const cw5 = (CW - 0.6) / 3;
  pts.forEach((p, i) => {
    const x = M + i * (cw5 + 0.3);
    s.addShape(pres.ShapeType.roundRect, {
      x, y: 2.75, w: cw5, h: 2.5,
      fill: { color: "2B3945" }, rectRadius: 0.08, line: { color: "2B3945", width: 0 },
    });
    s.addText(p[0], {
      x: x + 0.3, y: 3.0, w: cw5 - 0.6, h: 0.4,
      fontFace: BF, fontSize: 15, bold: true, color: WHITE, margin: 0,
    });
    s.addText(p[1], {
      x: x + 0.3, y: 3.48, w: cw5 - 0.6, h: 1.6,
      fontFace: BF, fontSize: 12.5, color: "B9C4CC", lineSpacing: 16, margin: 0,
    });
  });
  s.addShape(pres.ShapeType.line, { x: M, y: 5.65, w: 3.2, h: 0, line: { color: "44525E", width: 1 } });
  s.addText("Full bill of quantities, addressing schedule and commercial summary are issued with the accompanying quotation.", {
    x: M, y: 5.85, w: CW - 1.0, h: 0.5,
    fontFace: BF, fontSize: 13, color: "8A97A1", margin: 0,
  });
  s.addNotes("Price is mentioned once, last, with the reason for the gap stated so it does not read as a scope omission.");
}

pres.writeFile({ fileName: process.argv[2] || "deck.pptx" })
  .then(f => console.log("wrote " + f));

# Product data: a search checklist, not a source

Everything below was correct when a previous job was quoted. Product lines
change. **Re-verify every figure by web search before it goes on a slide, and
cite the manufacturer page you verified it against.** Use this file to know what
to look for and which traps to check, not as evidence.

## Address capacity fundamentals

- Standard DALI, and proprietary single-master buses such as Helvar DIGIDIM:
  64 addresses per line, **shared** between control gear and control devices.
  Wall plates and sensors eat driver addresses.
- DALI-2 multi-master: 64 control gear plus a **separate** 64 input devices per
  line. This is often the cheapest fix for a design that is a dozen addresses
  over on a single-master controller.
- Bus current: typically 250 mA per line. First-pass budget: 2 mA per driver,
  10 mA per wall panel, 5 mA per sensor. Confirm against the driver datasheet.

## Controllers, wired

Verify the number of buses and whether **control devices** are supported, which
is a different question from whether control gear is supported.

| Model | Buses | Trap to confirm |
|---|---|---|
| Helvar 905 | 1 | |
| Helvar 910 | 2 | Does not support DALI-2 control devices, so third-party panels and sensors are out |
| Helvar 945 | 2 DALI-2 multi-master | Separate input device address space |
| Helvar 950 | 4 DALI-2 | Flagship, check current lineup before quoting |

Two smaller controllers can be cheaper than one larger one when the shortfall is
small. Three subnets from a 910 plus a 905 is a legitimate answer.

## Gateways, wireless on a DALI bus

Casambi Salvador Series 1000 (SAL-1016 / 1032 / 1064) addresses 16, 32 or 64
DALI drivers respectively. Two things to confirm and then state on the slide:

1. **Drivers only.** Casambi's own documentation states DALI switches and
   sensors must not be connected to a Salvador. Any switches and sensors in that
   BOQ are Bluetooth radio nodes, not DALI devices. This is the answer to the
   claim that such a system is "wireless on the DALI backbone": the bus carries
   luminaires only, in one direction, from a gateway.
2. **Network node ceiling.** Casambi networks cap at 250 nodes and each wired
   driver behind a gateway counts as one. Compute the node total, not just the
   driver total.

A gateway quoted below the luminaire count is the most common and most decisive
error in these bids. Either a second gateway is missing from the price, or the
luminaires are being broadcast-grouped and lose individual addressing. Both are
bad answers and the slide should say so plainly.

## Sensor traps

Part numbers one digit apart are frequently a bare PIR versus a multisensor with
light sensing. Quoting the PIR against a competitor's presence-plus-daylight
sensor loses the daylight harvesting argument outright.

- Helvar 320 is PIR only. Helvar 321 is the multisensor.
- Tridonic basicDIM Wireless is Casambi-based, not a neutral third party. Its
  sensor does presence and ambient light dependent control.

Always confirm which of the two a BOQ actually names, on both sides.

## Wall panel traps

Helvar DIGIDIM panel suffixes encode finish. 135B is the black module, 135W is
white. Pairing a black module with a white frame is an easy ordering error to
carry all the way to site.

Confirm the module and the frame are the same finish before the deck claims a
finish.

## App and integration claims

Verify before asserting. Previously confirmed for Helvar Imagine controllers:

- SceneSet connects directly to the application controller over Ethernet or
  Wi-Fi, supports the 905, 910, 920 and 950, handles scene recall and
  modification plus DALI Type 8 tunable white and colour, and has no licence fee.
- HelvarNet over TCP/IP is the open command interface for BMS and third-party
  integration.

This pairing is the answer to "but their system has an app". Mobile control sits
at the user interface layer over the project Ethernet backbone while the control
path to each luminaire stays wired. That is a stronger position than either
"we have no app" or "radio everywhere".

## Emergency lighting

If emergency is in scope, it usually decides the job on its own. Confirm DALI
DT1 support and automatic test scheduling on both sides, and give it a dedicated
slide. If it is out of scope, say so once and move on.

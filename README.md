# VL.Cartography

**Maps and geographic data in [vvvv gamma](https://vvvv.org), taught from the ground up.**

This package contains **no nodes**. It installs the libraries that do, and adds the chapters that
show them working together:

| library | what it does |
|---|---|
| [VL.Mapsui](https://github.com/rednotfound/VL.Mapsui) | draws a real map — tiles, layers, styles, picking |
| [VL.NetTopologySuite](https://github.com/rednotfound/VL.NetTopologySuite) | geometry: points, lines, polygons, and operations on them |
| [VL.GeoJSON](https://github.com/rednotfound/VL.GeoJSON) | reads and writes the format the data actually arrives in |

Install this one and all three arrive. The chapters appear in vvvv's Help Browser.

> **Status: early.** Nothing here is on nuget.org yet.

---

## Why a separate package

GIS is a large topic, and **anything worth showing needs more than one library**. Reading a GeoJSON
file, projecting it, styling it by geometry type and drawing it on a map touches three packages —
and no single one of them can declare the other two without pretending to be something it is not.
A map engine has no business requiring a GeoJSON reader; a GeoJSON reader has no business requiring
a map engine. They compose through NetTopologySuite, which is a library they share rather than an
agreement they made.

So the examples need a home of their own. That home is this package, and the shape is the one
[VL.ExtendedTutorials](https://www.nuget.org/packages/VL.ExtendedTutorials) and
[VL.TheBigBang](https://github.com/chkw-rks/VL.TheBigBang) already use: no assembly, an empty entry
document, everything in `help\`, and a nuspec that declares the libraries being taught.

**And the examples are not documentation — they are how the libraries get tested.** On
2026-08-16 a single cross-package patch found three real defects in VL.Mapsui that 212 unit tests
had not: a style that silently erased every polygon, a fix for it that drew two markers on every
point, and a nested style collection that rendered nothing at all. None of them could have been
caught by testing one library alone. **This pack is a standing integration test that happens also
to teach.**

---

## Where a patch belongs

> **One package → that package's own `help\`. Two or more → here.**

It is a rule rather than a habit, and the validator checks it in both directions.

---

## The course

Each chapter runs. Numbered, because the order is load bearing — later chapters assume earlier
ones, which is the case where the vvvv convention puts numbers in the filename rather than leaving
the sequence to `Help.xml`.

| | chapter | the idea |
|---|---|---|
| 01 | A coordinate is not a position | longitude/latitude against metres; why the map draws in mercator; why you cannot measure distance in degrees |
| 02 | Geometry is a type, not a format | point, line, polygon — and WKT and GeoJSON as two spellings of one thing |
| 03 | A feature is geometry plus attributes | the join between space and data, which is what lets a map answer a question |
| 04 | Reading real data | GeoJSON from a file, where real files come from, and what their licences ask of you |
| 05 | Drawing it | one style per geometry type, labels, and two traps that cost a day each |
| 06 | Stacking | draw order is position; bands; and why order alone never reduces a busy map |
| 07 | Asking the map | picking — what is under the cursor, and getting data back out |
| 08 | Scale | thousands of features, and why the frame loop decides between 0.013 ms and 43 |

---

## If you installed VL.GIS

**`VL.GIS 0.2.0-alpha` conflicts with VL.Mapsui and cannot be fixed by uninstalling.** It declares
`BruTile 6`, while `Mapsui.Tiling` requires `BruTile [5.0.6, 6.0.0)`, and the two are not
compatible — `BruTile.Attribution` changed layout between them, so loading both throws
`TypeLoadException`. It also drags in `NetTopologySuite.IO.GeoJSON 3.0.0`, which pins
`NetTopologySuite.Features` to the **floor** of its range, 2.0.0, where VL.GeoJSON needs 2.1.0.

vvvv keeps every package's dependencies in one flat, machine-wide folder, and **uninstalling a
package does not remove them** — nor does reinstalling vvvv, because the folder lives in your user
profile. Delete these by hand:

```
%LOCALAPPDATA%\vvvv\gamma\nugets\BruTile.6.0.0
%LOCALAPPDATA%\vvvv\gamma\nugets\NetTopologySuite.Features.2.0.0
%LOCALAPPDATA%\vvvv\gamma\nugets\NetTopologySuite.IO.GeoJSON.3.0.0
```

Moving them somewhere else first is the reversible version, and is what we did on our own machine.

---

## Licence

MIT for the patches. **Sample data keeps its own licence** — see
[THIRD-PARTY-NOTICES.md](THIRD-PARTY-NOTICES.md). Anything derived from OpenStreetMap is ODbL and
requires attribution wherever it is shown, which chapter 04 treats as part of the lesson rather
than as small print.

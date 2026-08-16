# Third-party notices

The patches in this package are MIT. **The sample data is not** — geographic data almost always
carries a licence, and several of them require attribution wherever the data is *shown*, not
merely wherever it is redistributed. That is a working constraint on anyone building a map, which
is why chapter 04 treats it as part of the lesson.

## Sample data shipped in `help/Assets/`

| file | source | licence | what it asks of you |
|---|---|---|---|
| `cities.geojson` | hand-written for this package | MIT, same as the patches | nothing |

*(Grows as chapters are added. Every asset gets a row before it is committed — an unattributed
file in a shipped package is a licensing defect, not an oversight to fix later.)*

## Data sources worth knowing, and what they cost

Not shipped here, but these are where real data comes from and the terms differ sharply:

- **[Natural Earth](https://www.naturalearthdata.com/)** — public domain. Countries, coastlines,
  rivers, populated places, at three scales. No attribution required, though it is polite. The
  easiest legal starting point for anything global.
- **[OpenStreetMap](https://www.openstreetmap.org/copyright)** — **ODbL**. Free to use, but
  attribution is required *on the map itself*, and derived databases must be shared alike. Extracts
  from Geofabrik and Overpass carry the same terms. VL.Mapsui's `Attribution` widget exists for
  exactly this.
- **National open-data portals** — for example
  [GSI Japan](https://www.gsi.go.jp/kikakuchousei/kikakuchousei40182.html) or
  [data.gov](https://data.gov/) — usually permissive, usually with an attribution clause, and
  usually specific about *how* the attribution must read.

## Tile services

Tiles are not data you hold; they are a service someone pays for.

**OpenStreetMap's tile servers run on donated hardware and their
[tile usage policy](https://operations.osmfoundation.org/policies/tiles/) forbids bulk
downloading.** VL.Mapsui sends a User-Agent naming itself, caches only the tiles that were actually
drawn, and ships every patch with the tile layer switched **off** so that opening a document does
not fetch anything you did not agree to. Those are not conveniences; they are what the policy asks
for.

Any other provider — Mapbox, Stadia, Thunderforest, a national service — has its own terms, its own
key, and its own required credit. `XYZ` will point at any of them. Reading their terms is your
part.

# What this course is based on

The first outline for this pack was **invented** — assembled from whatever the libraries had just
run into, plus general knowledge. Asked what it was based on, the honest answer was "nothing".

So the field was searched, and it has plenty. It also **disagreed with the invented order**, which
is the main reason this document exists: so that "why is it taught in this sequence" has an answer
made of evidence rather than taste, and so that the answer can be re-checked when a chapter is
added.

---

## The sources, and what we may legally do with each

| source | what it is | licence | what we may do |
|---|---|---|---|
| [UCGIS GIS&T Body of Knowledge](https://gistbok.ucgis.org/) | the field's authoritative curriculum taxonomy. Ten knowledge areas, 73 units, 26 of them "core"; begun 1997 as the Model Curricula project and now a living online resource | reference work | **check coverage against it.** It is a degree-programme taxonomy, not a shape to copy |
| [FOSS4G GeoAcademy](https://github.com/FOSS4GAcademy) — GST 101–105 | the FOSS4G community's own curriculum: 35 hands-on labs, funded by the US Department of Labor, aligned to the Geospatial Technology Competency Model, maintained by the Spatial{Query} Lab at Texas A&M – Corpus Christi | **CC-BY 3.0** | **adapt, and borrow wording**, with attribution |
| [QGIS Training Manual](https://docs.qgis.org/latest/en/docs/training_manual/index.html) | the official practical course for QGIS — 20 modules | CC BY-**SA** 3.0 | learn from its sequencing; **do not adapt** — share-alike would spread into our MIT patches |
| [Geocomputation with R](https://r.geocompx.org/) | the programmer-facing book. Lovelace, Nowosad and Muenchow | prose CC-BY-**NC-ND**, code CC0 | **cite and link only.** No adaptation of any kind |

**GeoAcademy is the only one we may lean on as text**, which is what makes it the spine rather than
merely the best of them. When wording is borrowed, it carries their
[attribution block](https://github.com/FOSS4GAcademy/GST101FOSS4GLabs/blob/master/Attribution_Block_for_Lab_Documents.md).

### Standards, which are a different kind of authority

These say what is *true* rather than how to teach it, and the libraries already conform to them:

| | |
|---|---|
| **OGC Simple Features** | the geometry model — Point, LineString, Polygon and their multi- forms. What NetTopologySuite implements, and therefore what a `Geometry` in a patch actually is |
| **RFC 7946 (GeoJSON)** | including §4, which mandates WGS84 longitude and latitude. This is why VL.GeoJSON and VL.Mapsui agree about coordinates without an adapter |
| **EPSG registry** | the coordinate reference system codes. 4326 and 3857 are the two a web map lives between |

---

## The sequencing evidence

Where each source puts the four things a beginner meets first:

| | data model | on screen | styling | **coordinate systems** |
|---|---|---|---|---|
| **GST 101** | Lab 2 | Lab 4 | Lab 4 | **Lab 3** |
| **QGIS Training Manual** | — | **Module 2** | Module 2.4 | **Module 6** |
| **Geocomputation with R** | Ch 2 | Ch 9 | Ch 9 | **Ch 7** |

**All three lead with the data model. Not one leads with coordinate systems.** The QGIS manual is
explicit that CRS comes at Module 6, *after* students have mastered basic mapping.

The invented outline opened with "a coordinate is not a position" — the most abstract and most
off-putting lesson, at the door. It is now chapter 06.

**Where the three disagree, we follow QGIS**: coordinate systems come after the reader has a map on
screen. Two reasons. A vvvv audience is visual and the reward loop is seeing something; and someone
who has already been bitten by a projection is someone who will actually listen to the explanation.
Geocomputation with R agrees by placing reprojection at chapter 7. GST 101 puts it at Lab 3, which
suits an academic course where nobody leaves after week two.

---

## GST 101 as the spine, with what we skip and why

**GST 101 — Introduction to Geospatial Technology**, read rather than skimmed:

| lab | what it actually teaches | us |
|---|---|---|
| **0** Getting to Know FOSS and FOSS4G | what open source is, OSGeo, installing QGIS | **skipped** — a vvvv reader already has their tool |
| **1** GIS Application Paper | a writing assignment about a real-world GIS application | **skipped** — academic assessment |
| **2** Spatial Data Models | vector vs raster; open a shapefile and a Landsat scene, add both to the map, notice vector layers arrive in a random colour | **chapter 01** |
| **3** Coordinate Systems and Map Projections | EPSG codes; shape and area **distortion** across world projections; State Plane; UTM zones; datum | **chapter 06** |
| **4** Displaying Geospatial Data | single symbol vs **categorised by attribute value**; layer order; renaming layers for the legend; composing a print layout | **chapters 04 and 05** |
| **5** Creating Geospatial Data | digitising new features | **out of scope** — `Mapsui.Nts.Editing` is not wrapped |
| **6** Remote Sensing and Analysis | imagery interpretation | **out of scope** — another field |
| **7** Basic Geospatial Analysis | buffers, overlays, selection | **belongs to VL.NetTopologySuite**, not to a drawing course |

Two things this reading changed:

- **Lab 3 is not the abstraction I had planned.** It does not argue that longitude is not metres;
  it puts the same country into several projections and has you *look* at what happens to its shape
  and area. Concrete, visual, and reproducible in a patch.
- **Lab 2's lesson is already on our screen and nobody has named it.** A tile layer *is* raster; a
  feature layer *is* vector. Every existing help patch stacks both. Chapter 01 is mostly a matter
  of pointing at what is already there.

---

## The chapters

| | chapter | based on | exists |
|---|---|---|---|
| 01 | Vector and raster: your two kinds of layer | GST 101 Lab 2 | |
| 02 | A feature is geometry plus attributes | Lab 2 / Lab 4 | |
| 03 | Reading real data — files, and what their licences ask of you | Lab 2 / GST 103 | |
| 04 | Drawing it: one style per geometry type | Lab 4 | **yes**, currently numbered `05` |
| 05 | Stacking: order, bands and visible range | Lab 4 (layer order) | |
| 06 | Coordinate systems and distortion | Lab 3 | |
| 07 | Asking the map: picking | **no precedent** | |
| 08 | Scale and the frame loop | **no precedent** | |

**The shipped chapter still carries its old number**, from the outline where drawing was fifth. It
is renumbered when the chapters before it are written — renaming it now would leave its
cross-references pointing at chapters that do not exist yet, which is worse than a number being
briefly wrong.

### The two with no precedent, and why that is honest rather than convenient

**07 (picking) and 08 (scale and the frame loop) appear in none of the sources.** That is not an
oversight in the sources. A desktop GIS does not have these problems: it is not redrawing at sixty
frames a second, and "what is under the cursor" is a built-in behaviour rather than something a
user wires. They are ours because the host is a real-time visual programming environment, and they
should be labelled as ours rather than presented as received wisdom.

Chapter 08 in particular exists because of a measurement nothing in the GIS literature would
produce: with a thousand features of five hundred vertices each, the same downstream work costs
**0.013 ms per frame** when the data arrives unchanged and **43 ms** when it is rebuilt each frame.
That is a vvvv lesson wearing a GIS coat.

---

## What the curriculum found in the libraries

This pack has two jobs, and this is the second one: **checking the libraries against an outside
standard finds gaps that using them does not.**

- **`GradientTheme` is not wrapped.** GST 101 Lab 4 teaches styling *categorised by an attribute
  value* — a different colour per land-managing agency — and calls it a core skill. VL.Mapsui
  wraps `ThemeStyle` as `StyleByGeometry`, which dispatches on geometry type, but nothing yet
  dispatches on a **value**. A choropleth is not currently possible. That is a real hole, found by
  reading a curriculum rather than by patching.
- **Editing is not wrapped.** GST 101 Lab 5 is digitising; `Mapsui.Nts.Editing` is nine unwrapped
  types. Deliberately out of scope for now, but the curriculum is why we know the size of the gap.

---

## Using this document

Before adding a chapter: find its row above, and if it has no row, say what it is based on or say
plainly that it has none. A chapter with no source is not forbidden — 07 and 08 have none — but it
should be a decision rather than an accident.

**The rule this pack exists for is separate and lives in `CLAUDE.md`:** one package → that
package's own `help\`; two or more → here.

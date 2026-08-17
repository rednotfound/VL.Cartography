# CLAUDE.md

Guidance for Claude Code (claude.ai/code) working in this repository.

## What this is

**VL.Cartography is a course, not a library.** It contributes **no nodes**. It declares the three
libraries it teaches, and holds every patch that needs more than one of them.

| repository | what it is |
|---|---|
| `D:\2026_Projects\vl-mapsui` | draws maps: tiles, layers, styles, picking |
| `D:\2026_Projects\vl-nettopologysuite` | geometry — points, lines, polygons, operations |
| `D:\2026_Projects\vl-geojson` | reads and writes the format data arrives in |
| **here** | the chapters that use two or more of them |

The shape is copied from [VL.ExtendedTutorials](https://www.nuget.org/packages/VL.ExtendedTutorials)
and [VL.TheBigBang](https://github.com/chkw-rks/VL.TheBigBang): **no assembly, an empty entry
document, everything in `help\`, and a nuspec that declares the libraries.** ExtendedTutorials'
entry `.vl` is 1322 bytes of nothing, which is exactly right — the alternative is inventing nodes
so the package has something to contribute.

## The rule this repository exists for

> **A patch that needs ONE package belongs in that package's own `help\`. A patch that needs TWO
> OR MORE belongs here — *except* a spine `Tutorial`, which may need one package when the course's
> sequence requires it, and must say why in its own description.**

Both halves are enforced. `tools\Test-VLPackage.ps1` here fails a chapter that names only one
family package **unless its filename starts `Tutorial `**; vl-mapsui's fails a help patch that names
a foreign `VL.*` one. Neither is a convention to remember.

**The exemption exists because a course with a hole at chapter 1 is worse than a duplicated node.**
Every unit with a payoff inside five minutes — a world you can drag, a basemap you can restyle, the
longitude under the cursor — needs VL.Mapsui and nothing else. The rule was written for a
*library's* `help\`, where a foreign dependency opens red for whoever installed that library alone.
**This pack declares all three packages, so a single-package patch here is duplication, never
breakage** — a far smaller cost than sending a beginner elsewhere for lesson one, which is exactly
how the Gray Book loses people: it has no first lesson, it links out to YouTube.

The exemption is narrow on purpose. **A `Prompt` gets none.**

**Why it matters:** everything under a library's `help\` is packed, so a patch needing a package
that library does not depend on opens red for anyone who installed it alone. And the cure is never
to add the dependency — a map engine has no business requiring a GeoJSON reader. An `examples\`
folder was the first attempt and was worse: nothing there is packed, so **no user ever saw it**.

## And the second reason, which matters more

**The chapters are how the libraries get tested.** On 2026-08-16 one cross-package patch found
three real defects in VL.Mapsui that 218 unit tests had not:

- `SymbolStyle` drew **0 pixels** for a polygon, silently erasing half a dataset
- the first fix stacked two styles and put a second circle on every point
- a nested `StyleCollection` rendered nothing at all — 156 px where the flat one drew 14884

None was reachable by testing one library alone. **This pack is a standing integration test that
happens also to teach**, which is why it has a compile harness and is a package rather than a
folder of files.

## Working rules carried from the sibling repositories

Read `D:\2026_Projects\vl-mapsui\docs\RULES.md` and `docs\VL-PATCH-XML.md` before editing a `.vl`.
The ones that bite hardest here:

1. **Opening a document in vvvv is running it.** Read the value and close. Never leave it running
   unattended, never start it in the background. **Launch only through
   `tools\Open-HelpPatch.ps1`** — this pack needs **six** package repository folders, and vvvv
   ignores a repository that does not exist, so a missing one shows up as an error naming something
   else entirely.
2. **`Enabled` is off by default** on anything that fetches. Whoever opens a chapter has not agreed
   to anything yet; OSM's tile policy is a real constraint, not etiquette.
3. **A `.vl` is UTF-8 with BOM**, every `Id` exactly 22 characters starting `[A-V]`, unique within
   its document. `tools\New-VLId.ps1` generates them — never derive one by editing a character.
4. **Multi-step `.vl` edits go in a script FILE, not an inline command block.** An inline
   here-string terminator with an argument after it wrote PowerShell source into a patch on
   2026-08-16; the XML still parsed, `vvvvc` still compiled it, and only the validator noticed.
5. **Validate before committing, in a separate step.** A check whose result arrives after the push
   is not a gate.

## Before adding a unit, read `docs/CURRICULUM.md`

**The order is derived, not invented — and it has been corrected twice.** The first outline was
invented outright. The second was derived from FOSS4G GeoAcademy's GST 101 and still put a
vocabulary lesson at the door, because GST 101 is a graded university course and its reader cannot
leave. `docs/CURRICULUM.md` carries the sources, their licences, the evidence, and both corrections.

Four things from it that constrain the work:

- **GST 101 is the coverage checklist, not the sequence.** It answers "do we teach what the field
  considers core?" It does not name or order the units.
- **Name a unit by what the reader ends up with; put the concept in the subtitle.** The evidence is
  in-community and free: VL.TheBigBang opens on `Explanation 01. Types and IOBoxes` and renders
  nothing until chapter 8 of 45; the NODE Institute's paid beginner class opens on "create your
  first visual compositions" and is in 3D by session 2.
- **Only [FOSS4G GeoAcademy](https://github.com/FOSS4GAcademy) may be borrowed from as text** —
  CC-BY 3.0, attribution required. QGIS Training Manual is CC BY-**SA** and would spread share-alike
  into our MIT patches; Geocomputation with R is CC-BY-**NC-ND** and may only be cited.
  **The 30DayMapChallenge's licence is unverified** — its day *names* are used as evidence here, but
  check before any prompt description reaches a shipped patch.
- **A unit with no source is allowed but must say so.** Several prompts have none, because a desktop
  GIS has neither a frame loop nor a cursor to ask. A stated decision, not an accident.

## Two tiers, and the filename says which

```
help\Tutorial 01 ….vl     the spine. Ordered, numbered, each adds exactly one capability
help\Prompt ….vl          unordered, unnumbered, skippable, no prerequisites
```

**Numbering is a claim that order matters, so it is spent only on the spine.** Number everything and
the numbers become noise, and a reader arriving at unit 05 feels late — when the entire point of the
prompt tier is that they are not. [The Coding Train](https://thecodingtrain.com/tracks) says the same
in its own words: Main Tracks "you can follow like a course syllabus", Side Tracks "don't necessarily
need to be watched in order".

A **prompt** is phrased as a permission, not an instruction: a material restriction ("two colours
only") or a subject ("out of this world"), never "learn X". Tone from Genuary — *"You don't have to
follow the prompt exactly. Or even at all."*

The prefixes extend vvvv's existing `Explanation` / `HowTo` / `Example` convention, which is already
three-quarters of Diátaxis. `Tutorial` is the genre Diátaxis says those three are missing.

`Help.xml` carries the tags and groups the units into the two tiers, and the validator checks it
against the disk in both directions.

## The dev loop, and the one step that is not optional

Nothing is published. Every node a chapter uses comes off a sibling's `dist\` folder on disk, so
the loop never touches nuget.org:

```
1. close vvvv                        build refuses while it holds the assemblies, and says so
2. change a library -> run THAT library's .\pack.ps1
3. here:  .\tools\Compile-HelpPatches.ps1      <- the integration test
4.        .\tools\Open-HelpPatch.ps1 "name"    -> read -> close
```

**Step 2 is mandatory, and the reason is not obvious.** Every package sits at `0.0.1-alpha` and the
version never changes during development. **NuGet sees a matching version, uses its cache, and
never looks at the feed** — so a library you just rebuilt is silently ignored and you spend half an
hour debugging yesterday's code. All three siblings' `pack.ps1` evict the stale copy from both
`%USERPROFILE%\.nuget\packages` and vvvv's `package-cache`; skipping `pack.ps1` is what reopens the
hole.

**Step 3 is why this pack is worth its weight.** Change a pin name in a library and the compile
here goes red — `VisibleRange doesn't have a pin called "Result"` is a real one from 2026-08-16.
A library's API cannot move without a chapter telling you.

### When to publish

`VL.NetTopologySuite` and `VL.GeoJSON` depend on nothing of ours; `VL.Mapsui` depends on
VL.NetTopologySuite; this pack depends on all three. **Publish in that order or an install fails.**

**But not yet.** A published version is permanent — nuget.org cannot delete, only unlist, and this
family already spent a day on the consequences of one published alpha (`VL.GIS 0.2.0-alpha`, which
declares BruTile 6 and breaks VL.Mapsui; the fix exists in source and was never published). Mean-
while the same `0.0.1-alpha` gets repacked a dozen times a day here, which is flatly incompatible
with permanence.

The signal to publish is **the node surface going a week without moving**, plus enough chapters to
learn from. Until then `Test-Install.ps1` in each library already simulates a real install locally:
NuGet resolves the real dependency graph into a temp folder, and the help patches are compiled
**from the installed package**.

This repository has no `build.ps1` or `pack.ps1` yet — there is nothing to compile. One is needed
before it can be published; `nuget pack VL.Cartography.nuspec` has been verified by hand to produce
the right contents.

## Commands

```powershell
# validate: BOM, ids, references, the cross-package rule, Help.xml, the nuspec
.\tools\Test-VLPackage.ps1

# the real test - compiles every chapter against all three siblings' packages.
# Needs each sibling's pack.ps1 to have run first.
.\tools\Compile-HelpPatches.ps1 -OutputDirectory <abs-dir>
#   exit 0 means the document PARSED. Read the generated C# to see the nodes RESOLVED.

# open one, read it, close it
.\tools\Open-HelpPatch.ps1 -List
.\tools\Open-HelpPatch.ps1 "Drawing GeoJSON"

# after any GUI session - vvvv repins dependency versions and saves Enabled=True
.\tools\Normalize-HelpPatches.ps1
```

`tools\Get-PackageRepositories.ps1` is the single source of truth for the six repository folders
and three feeds. Both other scripts read it. It exists because that list was written out twice next
door and cost two launches.

## Assets

Every file in `help\Assets\` gets a row in `THIRD-PARTY-NOTICES.md` **before** it is committed.
Geographic data almost always carries a licence, and several require attribution wherever the data
is *shown* rather than merely redistributed — which is a working constraint on anyone building a
map, and part of what chapter 04 teaches.

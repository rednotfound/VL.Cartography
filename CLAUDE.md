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
> OR MORE belongs here.**

Both halves are enforced. `tools\Test-VLPackage.ps1` here fails a chapter that names only one
family package; vl-mapsui's fails a help patch that names a foreign `VL.*` one. Neither is a
convention to remember.

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

## Chapters are numbered in the filename

A departure from the sibling libraries, and deliberate. In a library's `help\` the patches are a
flat set of HowTos readable in any order, so numbering files makes every gap look like a broken
install and `Help.xml` does the sequencing. **Here the order is load bearing.**
VL.ExtendedTutorials numbers its Math series the same way — `Explanation 01 Intro` through
`20 FPS Camera` — for the same reason.

`Help.xml` still carries the tags and groups chapters into parts, and the validator checks it
against the disk in both directions.

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

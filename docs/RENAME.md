# Renaming VL.Cartography → VL.Overworld

**A live checklist, written 2026-08-22. Delete this file in the rename commit itself** — a
finished checklist that lingers reads as an unfinished rename.

Why the name changes: the course no longer starts with maps, and *Cartography* is the one word
the third correction (see [CURRICULUM.md](CURRICULUM.md)) made wrong. *Overworld* is the map a
game hands you between levels — vocabulary the audience already owns. Decided in the 2026-08-22
direction review; nothing is published anywhere, so this is the last cheap moment.

**Naming pattern** (mirrors the siblings): GitHub repo `VL.Overworld`, local folder
`vl-overworld`, package id `VL.Overworld`, entry document `VL.Overworld.vl`.

---

## 1. GitHub (needs the repo owner)

```powershell
gh repo rename VL.Overworld -R rednotfound/VL.Cartography
```

GitHub redirects the old URL, but the absolute links in README.md are updated in step 3 anyway.

## 2. Local folder + remote

Close vvvv and any session working in the folder first.

```powershell
Rename-Item D:\2026_Projects\vl-cartography vl-overworld
git -C D:\2026_Projects\vl-overworld remote set-url origin git@github.com:rednotfound/VL.Overworld.git
```

## 3. Inside this repository — the measured hit list (2026-08-22)

Rename the **file pair** (build discovery matches a root `.vl` to a same-named `.nuspec`):

```powershell
git -C D:\2026_Projects\vl-overworld mv VL.Cartography.vl VL.Overworld.vl
git -C D:\2026_Projects\vl-overworld mv VL.Cartography.nuspec VL.Overworld.nuspec
```

Then edit content, anchored, in:

| file | hits | notes |
|---|---|---|
| `VL.Overworld.nuspec` | 8 | id, title, projectUrl, repository url, description. **Keep `cartography`, `gis`, `map` in the tags** — nobody searches nuget for "overworld" |
| `VL.Overworld.vl` | 1 | internal mention |
| `README.md` | 3 | title + the two absolute GitHub links |
| `CLAUDE.md` | 2 | prose mentions |
| `help\Tutorial 09 Real data.vl` | 1 | **inside the canvas narrative** — edit with an anchored unique-match replacement, verify BOM + XML parse afterwards, exactly like every .vl edit |
| `tools\Test-VLPackage.ps1` | 1 | message or anchor string |
| `tools\Compile-HelpPatches.ps1` | 1 | same |
| `tools\Normalize-HelpPatches.ps1` | 1 | same |

## 4. The sibling repository (only vl-mapsui — the other two have zero references)

| file | hits | notes |
|---|---|---|
| `tools\Test-VLPackage.ps1` | 6 | its cross-package rule names where foreign patches live |
| `CLAUDE.md` | 5 | |
| `docs\RULES.md` | 1 | |
| `tools\Compile-HelpPatches.ps1` | 1 | |
| `tools\Open-HelpPatch.ps1` | 1 | |
| `NOTES.md` | 1 | |

## 5. The memory junction (or the next session starts amnesiac)

The shared memory's real home is under the retired `vvvv-gis` project and does not move. The
renamed folder needs its own junction (no admin rights required):

```powershell
New-Item -ItemType Junction `
  -Path  "C:\Users\laval\.claude\projects\D--2026-Projects-vl-overworld\memory" `
  -Target "C:\Users\laval\.claude\projects\D--2026-Projects-vvvv-gis\memory"
```

If the parent `D--2026-Projects-vl-overworld` folder does not exist yet, start one session in the
renamed repo first (it creates the project folder), then create the junction, then restart.
The old `D--2026-Projects-vl-cartography\memory` junction can be deleted afterwards
(`Remove-Item` on the junction itself — it removes the link, not the shared target).

## 6. Prove it, then commit

```powershell
.\tools\Test-VLPackage.ps1                              # discovery must find VL.Overworld.vl + .nuspec
.\tools\Compile-HelpPatches.ps1 -OutputDirectory <abs>  # all nine chapters
git grep -i cartography                                 # only historical mentions should remain
```

Historical mentions (git log, CURRICULUM.md's account of its own corrections, memory files
describing the past) **stay as they are** — history does not get renamed. Then: one commit here,
one in vl-mapsui, delete this file in the former, push both.

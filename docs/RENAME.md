# Renaming VL.Cartography → VL.Overworld — what remains

**Executed 2026-08-22**: GitHub repo renamed (by the user), remote re-pointed, the
`VL.Overworld.vl`/`.nuspec` pair renamed, all measured content references updated in this repo
and vl-mapsui (vl-mapsui's `NOTES.md` mention deliberately kept — it is a dated historical
record), the `D--2026-Projects-vl-overworld` memory junction created.

**One step remains, and only a human can do it** — the running session pins the folder:

1. Close every session and vvvv instance working in `D:\2026_Projects\vl-cartography`.
2. Rename the folder: `Rename-Item D:\2026_Projects\vl-cartography vl-overworld`
   (or F2 in Explorer).
3. Open the next session in `D:\2026_Projects\vl-overworld`. Memory is already wired.

Then, in that session: run `.\tools\Test-VLPackage.ps1` and a full
`.\tools\Compile-HelpPatches.ps1` once more as a smoke test, **delete this file**, and commit.
The old `...projects\D--2026-Projects-vl-cartography\memory` junction may be removed at leisure
(`Remove-Item` deletes the link, never the shared target).

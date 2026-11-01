# Migration ledger

The migrator appends one row per migration. The result is `done` or `not applicable`.
The id is the four-digit migration number, or the file name without `.md` for an older file.
The pack version is the version when the row was written.

| Migration | Result | Pack version |
|---|---|---|
| 0001 | done | 0.46.0 |
| 0002 | done | 0.46.0 |
| 0003 | done | 0.46.0 |
| migrate-adoption-mode-and-about-md | done | 0.46.0 |
| migrate-product-yml-component-paths | done | 0.46.0 |
| retroactive-release-tags | done | 0.46.0 |
| 0004 | not applicable | 0.47.0 |
| 0005 | not applicable | 0.47.0 |
| 0006 | done | 0.46.0 |
| 0007 | done | 0.47.0 |

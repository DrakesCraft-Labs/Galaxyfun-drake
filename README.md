# Galaxyfun

Galaxyfun is DrakesCraft's unified Slimefun space addon for Paper 1.21.1 and Java 21.
It is the maintained successor to the deployed `Galactifun-drake` runtime. The first
release deliberately preserves the existing space worlds, Slimefun item IDs, commands,
and persistent data before any Galactifun2 content is enabled.

## Compatibility contract

- Existing Slimefun IDs and recipes remain unchanged.
- Existing PDC values remain under `galactifun-drake:*` so suits, rockets, aliens and
  chunk metadata stay readable after the visible plugin name changes.
- `/galaxyfun` is the canonical command. `/galactifun-drake`, `/galactifun`, `/gf` and
  `/galactic` remain aliases.
- The legacy `config.yml`, `worlds.yml`, and `uuids.yml` are copied once into the
  Galaxyfun data directory. Original files are never deleted by the plugin.

## Why Galactifun2 is not enabled yet

Galactifun2 contains useful rocket and structure work, but its current startup registers
test Mars, Moon and `galactifun_space` worlds automatically. Those names overlap the
deployed galaxy and could create duplicated world ownership. Galaxyfun keeps that code
out of the runtime until it is converted into opt-in, collision-checked modules.

See [docs/MIGRATION.md](docs/MIGRATION.md) for the replacement procedure and
`scripts/verify-legacy-compatibility.sh` for the preflight checks.

## Build

```bash
./gradlew --no-daemon clean shadowJar
```

The artifact is written to `build/libs/Galaxyfun-11.0-Drake-1.21.1-SNAPSHOT.jar`.

## Production rule

Never run Galaxyfun beside `Galactifun-drake` or Galactifun2. The replacement is a
single-plugin migration with a backup, a controlled restart, and a rollback JAR kept in
place until world, item, rocket and alien checks pass.

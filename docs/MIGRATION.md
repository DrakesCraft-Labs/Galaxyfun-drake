# Galaxyfun migration

Galaxyfun replaces the deployed `Galactifun-drake` addon. It must never be installed
alongside either legacy Galactifun or Galactifun2.

## Preserved state

| State | Legacy location/key | Galaxyfun behavior |
| --- | --- | --- |
| Runtime configuration | `plugins/Galactifun-drake/config.yml` | Copies once if Galaxyfun has no configuration yet. |
| World enablement | `plugins/Galactifun/worlds.yml` | Copies once to `plugins/Galaxyfun/worlds.yml`. |
| Alien UUID registry | `plugins/Galactifun/uuids.yml` | Copies once to `plugins/Galaxyfun/uuids.yml`. |
| Entity, item and chunk PDC | `galactifun-drake:*` | Reads and writes the legacy namespace. |
| Slimefun items and blocks | Existing item IDs | Keeps the IDs unchanged. |
| Commands | `galactifun-drake`, `galactifun`, `gf`, `galactic` | Keeps all aliases and adds `galaxyfun`. |

## Required rollout sequence

1. Stop Minecraft during an approved maintenance window.
2. Back up the active Galactifun JAR and the `Galactifun`, `Galactifun-drake`, and
   `Galactifun2` directories with checksums.
3. Remove the legacy Galactifun and Galactifun2 JARs from the active plugin directory;
   retain them in the rollback directory.
4. Install only the verified Galaxyfun JAR.
5. Start Minecraft and confirm the migration log entries. Do not delete legacy data
   folders during this release.
6. Test one existing space suit, rocket, alien, machine, and each enabled planet before
   declaring the migration complete.
7. Keep the old JARs and data folders through at least one normal backup cycle.

## Galactifun2 intake gate

The following conditions are mandatory before enabling any Galactifun2 module inside
Galaxyfun:

- no unconditional `WorldCreator` calls during startup;
- no test planet registration;
- every new Slimefun item uses the `GF2_` prefix and is collision-tested;
- no `world_galactifun_*` name overlaps an existing Galaxyfun world;
- rocket assembly, item loss and disconnect paths pass a restart test;
- all new content is feature-gated and disabled by default on the first release.

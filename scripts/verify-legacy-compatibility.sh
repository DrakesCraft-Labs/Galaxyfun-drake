#!/usr/bin/env bash
set -euo pipefail

artifact="${1:-build/libs/Galaxyfun-11.0-Drake-1.21.1-SNAPSHOT.jar}"

if [[ ! -f "$artifact" ]]; then
    echo "[ERROR] Artifact not found: $artifact" >&2
    exit 1
fi

plugin_yml="$(unzip -p "$artifact" plugin.yml)"
required_aliases=("galaxyfun" "galactifun-drake" "galactifun" "gf" "galactic")
required_legacy_keys=("galactifun-drake" "space_suit" "oxygen" "cargo" "world_storage")

for alias in "${required_aliases[@]}"; do
    if ! grep -Fq -- "$alias" <<<"$plugin_yml"; then
        echo "[ERROR] Missing command compatibility alias: $alias" >&2
        exit 1
    fi
done

for key in "${required_legacy_keys[@]}"; do
    if ! unzip -Z1 "$artifact" '*.class' | while read -r class_file; do
        unzip -p "$artifact" "$class_file"
    done | strings | grep -F -- "$key" >/dev/null; then
        echo "[ERROR] Missing legacy persistence marker: $key" >&2
        exit 1
    fi
done

echo "[OK] Galaxyfun compatibility preflight passed: $artifact"

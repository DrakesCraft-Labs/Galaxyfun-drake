#!/usr/bin/env bash
set -euo pipefail

if [[ $# -gt 0 ]]; then
    artifact="$1"
else
    artifacts=(build/libs/*.jar)
    if [[ ${#artifacts[@]} -ne 1 || ! -f "${artifacts[0]}" ]]; then
        echo "[ERROR] Expected exactly one built Galaxyfun artifact in build/libs." >&2
        exit 1
    fi
    artifact="${artifacts[0]}"
fi

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

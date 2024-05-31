#!/usr/bin/env bash

set -euo pipefail

readonly path_repo="$(dirname "$(dirname "$BASH_SOURCE")")"
source "$path_repo/libs/nimbro_config/source_configs.sh"

setup_dds() {
    mkdir -p ~/.ros
    cat "$path_repo/libs/nimbro_config/cyclonedds.xml.template" | envsubst >"$CYCLONEDDS_URI"
}

main() {
    setup_dds
}

main "$@"

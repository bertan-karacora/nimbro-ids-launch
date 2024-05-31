#!/usr/bin/env bash

set -euo pipefail

source /repos/nimbro-ids-launch/nimbro_config/source_configs.sh

setup_dds() {
    mkdir -p ~/.ros
    cat "/repos/nimbro-ids-launch/nimbro_config/cyclonedds.xml.template" | envsubst >"$CYCLONEDDS_URI"
}

main() {
    setup_dds
}

main "$@"

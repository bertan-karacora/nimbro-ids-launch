#!/usr/bin/env bash

set -euo pipefail

source /repos/nimbro-ids-launch/config.sh

setup_dds() {
    mkdir -p ~/.ros
    cat "/repos/nimbro-ids-launch/resources/cyclonedds.xml.template" | envsubst >"$CYCLONEDDS_URI"
}

main() {
    setup_dds
}

main "$@"

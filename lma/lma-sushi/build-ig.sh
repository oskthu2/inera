#!/bin/bash
# build-ig.sh
# Bygger FHIR IG med HL7s officiella ig-publisher-base Docker image

set -e

# Ange projektmapp (denna mapp)
WORKDIR=$(pwd)

# Ange Docker-image
IMAGE="hl7fhir/ig-publisher-base:latest"

# Bygg IG
# Om du kör på Windows, byt ut $WORKDIR mot absolut sökväg med / istället för \.
docker run --rm -v "$WORKDIR:/work" -w /work $IMAGE \
  java -jar /usr/local/bin/publisher.jar -ig ig.ini -tx n/a "$@"

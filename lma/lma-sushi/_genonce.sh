#!/bin/bash
# _genonce.sh – Kör SUSHI och IG Publisher i ett steg.
# Kräver: sushi (npm install -g fsh-sushi), java, IG Publisher JAR

set -e

echo "=== Steg 1: SUSHI – genererar FHIR-resurser från FSH ==="
sushi .

echo ""
echo "=== Steg 2: IG Publisher ==="
# Ladda ner publisher.jar vid behov
if [ ! -f publisher.jar ]; then
  echo "Laddar ner IG Publisher..."
  curl -L https://github.com/HL7/fhir-ig-publisher/releases/latest/download/publisher.jar \
       -o publisher.jar
fi

java -jar publisher.jar -ig ig.ini "$@"

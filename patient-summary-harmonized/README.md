# Harmoniserade FHIR-profiler för Patient Summary

Den här mappen innehåller ett första utkast till FHIR-profiler som harmoniserar krav från:

- EURIDICE EU Health Data API (resource-oriented access)
- HL7 EU ePrescription/eDispensation (EPS)
- Xt-EHR:s logiska modell för EHDS Patient Summary

Syftet är att ge en gemensam profilering som kan användas vid nationell anpassning inom Inera-kontext.

## Innehåll

- `sushi-config.yaml` – SUSHI/IG-konfiguration.
- `input/fsh/profiles/` – profiler och harmoniseringsregler.
- `input/fsh/extensions/` – tilläggsextensioner för krav som saknar direkt stöd.
- `input/pagecontent/` – narrativ dokumentation av harmoniseringsprinciper.

## Designprinciper

1. **Basera på etablerade EU-profiler först** (EURIDICE/EPS) och komplettera sedan.
2. **Skärp kardinalitet endast när flera källor stödjer samma krav** eller när Xt-EHR rekommenderar obligatoriskt informationsinnehåll för sammanfattning.
3. **Kodverk prioriteras i följande ordning**:
   - EU-gemensamma bindningar från EPS/EURIDICE
   - SNOMED CT / LOINC / ATC / ICD-10 där relevant
   - Nationellt kodverk via kompletterande ValueSet/CodeSystem
4. **Spårbarhet**: varje regel i profilfilerna märks med kommentar om ursprung (EURIDICE, EPS, Xt-EHR eller kombination).

## Nästa steg

- Validera profilerna mot konkreta exempelinstanser.
- Lägga till svenska nationella värdemängder.
- Publicera som komplett IG med QA-körning i CI.

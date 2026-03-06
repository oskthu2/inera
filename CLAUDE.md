# CLAUDE.md
## Projekt: EHDS-brygga — samverkansinfrastruktur för Inera
### Arkitekturbeslut och kontext
Se följande filer för arkitekturkontext:
- `docs/losningsarkitektur-mvp-ehds.md` — användningsfall, flöden, transaktioner
- `docs/ehds-brygga-krav-pa-t2-infrastruktur.md` — krav på T2-infrastruktur
- `docs/teknisk-arkitektur.md` — tekniska vägval (Kong, HAPI FHIR, mappningslager)
- `docs/iam-positionering.md` — SMART Backend Services vs ENA vs T2
### Mappningsarkitektur (tre lager)
- Lager 1: Datatypbibliotek (rivta-fhir-types) — RIV-TA-datatyper → FHIR-datatyper
- Lager 2a: NamingSystem (FHIR-resurser) — OID ↔ URI systemöversättning
- Lager 2b: ConceptMap (FHIR-resurser) — kodöversättning via $translate
- Lager 3: Attributmappning per TK (YAML) — SOAP-element → FHIR-attribut
### Terminologi
- ConceptMap för kod→kod-översättning
- NamingSystem för OID→URI (identifiersystem OCH kodsystem)
- HAPI FHIR $translate hanterar INTE systemöversättning, bara koder

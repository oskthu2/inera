# Mappningsartefakter — EHDS-brygga

Samlar FHIR-resurser och mappningsregler för FHIR↔SOAP-översättning.
Se [mappningsarkitektur.md](../mappningsarkitektur.md) för tre-lagers-modellen.

## Mappstruktur

```
mappning/
├── README.md                         (denna fil)
├── NamingSystem/                     Lager 2a: OID↔URI-uppslag
│   ├── ns-personnummer.json
│   ├── ns-hsa-id.json
│   ├── ns-icd-10-se.json
│   └── ns-kva.json
├── ConceptMap/                       Lager 2b: kod→kod + fältmappning
│   ├── cm-diagnos-typ.json           diagnos/typ → Condition.category
│   ├── cm-diagnos-status.json        diagnos/registreringsStatus → clinicalStatus
│   └── GetDiagnosis/
│       └── cm-GetDiagnosis-attributmappning.json   (fältnivå, TX-06/TX-09)
└── TK/                               Lager 3: YAML per tjänstekontrakt
    └── GetDiagnosis/
        └── GetDiagnosis-mappning.yaml
```

## Konventioner

### NamingSystem
Varje fil har ett OID och en URI (`preferred: true`). Används av mappningsmotorn
för OID↔URI-omvandling vid identifierare och kodsystem.

### ConceptMap (kod→kod)
Filer under `ConceptMap/` på toppnivå är kodöversättningar som anropas via `$translate`.

**`relationship`-koder:**
| Värde | Innebörd i detta projekt |
|---|---|
| `equivalent` | Direkt 1:1-mappning, ingen logik |
| `inexact` | Nästan ekvivalent, se `comment` för justering |
| `unmatched` | Källkod saknar FHIR-motsvarighet |

### ConceptMap (attributmappning, icke-standard)
Filer under `ConceptMap/<TK>/` dokumenterar fältmappning på attributnivå.
- `element[].code` = SOAP XPath-uttryck
- `target[].code` = FHIR path
- `target[].relationship`:
  - `equivalent` = direkt mappning (ingen transformation)
  - `inexact` = transformation krävs, regel i `comment`
  - `unmatched` = SOAP-fält utan FHIR-motsvarighet (logga/ignorera)
- `target[].comment` = behandlingsregel som körs av mappningsmotorn

## Status

| Artefakt | Status | Källa |
|---|---|---|
| NamingSystem personnummer | ✅ | RIV-TA SE-OID-register |
| NamingSystem HSA-id | ✅ | RIV-TA SE-OID-register |
| NamingSystem ICD-10-SE | ✅ | Socialstyrelsen |
| NamingSystem KVÅ | ✅ | Socialstyrelsen |
| ConceptMap diagnos-typ | ⚠️ delvis | Kodvärden ej bekräftade mot TK-spec |
| ConceptMap diagnos-status | ⚠️ delvis | Kodvärden ej bekräftade mot TK-spec |
| ConceptMap GetDiagnosis attributmappning | ⚠️ delvis | Kräver logisk modell XML |
| YAML GetDiagnosis | ⚠️ utkast | — |

# LMA FHIR Implementation Guide

**Paket:** `sis.se.lma.api` | **Version:** `0.1.0-draft` | **FHIR:** R4 (4.0.1)

FHIR Implementation Guide för SIS/TR API-standard för läkemedelsautomater.

## Struktur

```
lma-sushi/
├── ig.ini                          # IG Publisher entry point
├── sushi-config.yaml               # SUSHI-konfiguration (metadata, sidor, meny)
├── _genonce.sh                     # Convenience build-skript
├── input/
│   ├── fsh/
│   │   ├── profiles/
│   │   │   ├── Patient-Automat.fsh         # LMABrukare + LMAAutomat
│   │   │   ├── Koppling-Overlamnande.fsh   # LMAKoppling + LMALakemedelsoverlamnande
│   │   │   └── Administrering-Pafyllnad.fsh # LMALakemedelsadministrering + LMAPafyllnad
│   │   ├── extensions/
│   │   │   └── Extensions.fsh      # ext-lma-tidPlanerad, anslutningsstatus, batch
│   │   ├── codesystems/
│   │   │   └── CodeSystems.fsh     # 7 CodeSystems (enhetslager + omvårdnadslager)
│   │   ├── valuesets/
│   │   │   └── ValueSets.fsh       # 7 ValueSets med lagerindikation
│   │   └── examples/
│   │       └── Examples.fsh        # 7 exempelinstanser
│   ├── pagecontent/
│   │   ├── index.md                # Startsida
│   │   ├── background.md           # Bakgrund och regelverk
│   │   ├── logical-model.md        # Lagermodell, IHE SDPi/BICEPS, klasser
│   │   ├── mappings.md             # Mappningstabeller logisk modell → FHIR
│   │   ├── profiles.md             # Profilöversikt
│   │   └── artifacts.md           # Artefaktregister + byggdokumentation
│   └── includes/
│       └── menu.xml                # Navigationsmeny
└── [fsh-generated/]                # Skapas av SUSHI (ingår ej i källkod)
```

## Bygga IG:n

### Förutsättningar

- **Node.js** ≥ 18: `node --version`
- **Java** ≥ 11: `java -version`
- **SUSHI:** `npm install -g fsh-sushi` → `sushi --version`

### Steg 1 – SUSHI genererar FHIR-resurser

```bash
cd lma-sushi
sushi .
# Genererar fsh-generated/resources/*.json
```

### Steg 2 – IG Publisher

```bash
# Ladda ner publisher (vid behov)
curl -L https://github.com/HL7/fhir-ig-publisher/releases/latest/download/publisher.jar \
     -o publisher.jar

java -jar publisher.jar -ig ig.ini
```

### Allt i ett

```bash
chmod +x _genonce.sh
./_genonce.sh
```

Resultatet finns i `output/`. Öppna `output/index.html` i en webbläsare.

## Viktig princip: lageruppdelning

Enhetslager-kodurval (tekniska status- och felkoder från automaten) och
omvårdnadslager-kodurval (omvårdnadsbedömda orsaker från personal) är **separata**
och ska **inte blandas**. Se `input/pagecontent/logical-model.md` och
`input/fsh/codesystems/CodeSystems.fsh` för fullständig motivering.

## Licens

CC0-1.0. Se `sushi-config.yaml`.

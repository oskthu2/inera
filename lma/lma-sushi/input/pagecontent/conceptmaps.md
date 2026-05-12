### Terminologimodell och concept maps

Denna sida beskriver hur IG:ns terminologi härletts från informationsmodellen och hur
kodurvalsbindningarna tillämpas som krav på FHIR-profilerna. Metodiken speglar den
tre-lagersmodell som används i EHDS-bryggan och gör det möjligt att ansluta LMA-plattformar
till nationella infrastrukturkomponenter utan att ändra profildefinitionerna.

---

### Från informationsmodell till terminologibindning

Flödet nedan visar hur standardens informationsmodell (kapitel 6) styr varje led fram
till de bindningar som är normativa i IG:ns profiler. Noderna är klickbara och leder
till respektive profil- eller terminologisida.

```mermaid
flowchart TD
    IM("📋 Informationsmodell\nStandard kap. 6")

    subgraph fsh_profiles ["FSH-profiler  (input/fsh/profiles/)"]
        direction TB
        P_KO("Koppling-Overlamnande.fsh\nLMAKoppling · LMALakemedelsoverlamnande")
        P_AP("Administrering-Pafyllnad.fsh\nLMALakemedelsadministrering · LMAPafyllnad")
        P_PA("Patient-Automat.fsh\nLMABrukare · LMAAutomat")
    end

    subgraph fsh_term ["Terminologi  (input/fsh/)"]
        direction TB
        CS("codesystems/CodeSystems.fsh\nlma-overlamningstfall · lma-overlamninsfelkod\nlma-administreringsstatus · lma-administreringsorsak\nlma-driftsstatus · lma-anslutningsstatus · lma-kopplingsstatus")
        VS("valuesets/ValueSets.fsh\nVS-Overlamningstfall · VS-Overlamninsfelkod\nVS-Administreringsstatus · VS-Administreringsorsak")
    end

    subgraph fhir_r5 ["FHIR R5-resurser (utfall)"]
        direction LR
        R1("DeviceAssociation\nLMAKoppling")
        R2("MedicationDispense\nLMALakemedelsoverlamnande")
        R3("MedicationAdministration\nLMALakemedelsadministrering")
        R4("SupplyDelivery\nLMAPafyllnad")
    end

    IM -->|"Klasser & attribut\nmed kardinalitet"| fsh_profiles
    IM -->|"Kodurval per lager\n(enhet / omvårdnad)"| fsh_term
    fsh_profiles -->|"Required / Preferred\nbindningar"| VS
    CS -->|"include codes from"| VS
    fsh_profiles -->|"Profilerar"| fhir_r5

    click R1 "StructureDefinition-LMAKoppling.html" "LMAKoppling-profil"
    click R2 "StructureDefinition-LMALakemedelsoverlamnande.html" "LMALakemedelsoverlamnande-profil"
    click R3 "StructureDefinition-LMALakemedelsadministrering.html" "LMALakemedelsadministrering-profil"
    click R4 "StructureDefinition-LMAPafyllnad.html" "LMAPafyllnad-profil"
    click VS  "artifacts.html#terminology-value-sets" "Alla ValueSets"
    click CS  "artifacts.html#terminology-code-systems" "Alla CodeSystems"
```

---

### Lagerindelad terminologi

Kodurval är **normativt knutna till lager**. Mixen av enhetslager-koder och
omvårdnadslager-koder i samma attribut är **inte tillåten**.

| CodeSystem | Lager | Bunden i profil | Bindningsstyrka | Attribut |
|------------|-------|-----------------|-----------------|---------|
| [lma-overlamningstfall](CodeSystem-lma-overlamningstfall.html) | Enhet | [LMALakemedelsoverlamnande](StructureDefinition-LMALakemedelsoverlamnande.html) | Required | `status` |
| [lma-overlamninsfelkod](CodeSystem-lma-overlamninsfelkod.html) | Enhet | [LMALakemedelsoverlamnande](StructureDefinition-LMALakemedelsoverlamnande.html) | Preferred | `notPerformedReason.concept` |
| [lma-administreringsstatus](CodeSystem-lma-administreringsstatus.html) | Omvårdnad | [LMALakemedelsadministrering](StructureDefinition-LMALakemedelsadministrering.html) | Required | `status` |
| [lma-administreringsorsak](CodeSystem-lma-administreringsorsak.html) | Omvårdnad | [LMALakemedelsadministrering](StructureDefinition-LMALakemedelsadministrering.html) | Preferred | `statusReason` |
| [lma-driftsstatus](CodeSystem-lma-driftsstatus.html) | Enhet | *(DeviceMetric / Observation)* | – | – |
| [lma-kopplingsstatus](CodeSystem-lma-kopplingsstatus.html) | Enhet | [LMAKoppling](StructureDefinition-LMAKoppling.html) | Preferred | `status` |

Separationen garanteras genom att ValueSets inte korsar lagergränsen:
`VS-Overlamninsfelkod` inkluderar **enbart** felkoder från enhetslagret och
`VS-Administreringsorsak` inkluderar **enbart** omvårdnadsbedömda orsaker.

---

### Concept maps mot externa system

När LMA-data utbyts med externa system (t.ex. via EHDS-bryggan eller NPÖ) behövs
explicit kodöversättning. Följande tabeller anger hur LMA-koder mappar till
FHIR-standardterminologi.

#### Överlämnanderesultat → MedicationDispense.status

| LMA-kod | Beskrivning | FHIR R5-kod | System |
|---------|-------------|-------------|--------|
| `lyckad` | Överlämning genomförd | `completed` | `http://hl7.org/fhir/CodeSystem/medicationdispense-status` |
| `misslyckad` | Överlämning ej genomförd | `declined` | samma |
| `okant` | Utfall okänt | `unknown` | samma |

#### Administreringsstatus → MedicationAdministration.status

| LMA-kod | Beskrivning | FHIR R5-kod | System |
|---------|-------------|-------------|--------|
| `genomford` | Administrering genomförd | `completed` | `http://hl7.org/fhir/CodeSystem/medication-admin-status` |
| `ej-genomford` | Ej genomförd | `not-done` | samma |
| `avbruten` | Avbruten | `stopped` | samma |
| `okant` | Okänt | `unknown` | samma |

#### Kopplingsstatus → DeviceAssociation.status

| LMA-kod | Beskrivning | FHIR R5-kod | System |
|---------|-------------|-------------|--------|
| `aktiv` | Aktiv koppling | `attached` | `http://hl7.org/fhir/CodeSystem/deviceassociation-status` |
| `avslutad` | Avslutad koppling | `explanted` | samma |
| `suspenderad` | Tillfälligt inaktiv | `unknown` | samma |

Dessa tabeller utgör grunden för ConceptMap-resurser (FHIR `ConceptMap`) som kan
registreras i en nationell terminologiserver för `$translate`-anrop i realtid.

---

### Profilkrav härledda från informationsmodellen

Nedanstående tabell visar hur modellens semantik direkt styr profilers MustSupport-märkning,
kardinalitet och terminologibindning. Jämför med [Mappning till FHIR](mappings.html) för
fullständiga elementmappningar.

| Informationsmodell → krav | Profil | Element | Kardinalitet | MS | Bindning |
|--------------------------|--------|---------|-------------|----|---------|
| Överlämning **utfall** (enhetslager) | LMALakemedelsoverlamnande | `status` | 1..1 | ✓ | VS-Overlamningstfall Required |
| Överlämning **felkod** (enhetslager) | LMALakemedelsoverlamnande | `notPerformedReason.concept` | 0..1 | ✓ | VS-Overlamninsfelkod Preferred |
| Administrering **status** (omvårdnadslager) | LMALakemedelsadministrering | `status` | 1..1 | ✓ | – (FHIR-standard) |
| Administrering **orsak** (omvårdnadslager) | LMALakemedelsadministrering | `statusReason` | 0..1 | ✓ | VS-Administreringsorsak Preferred |
| Koppling **brukare** (PDL 3 kap.) | LMAKoppling | `subject` | 1..1 | ✓ | Reference(LMABrukare) |
| Koppling **giltighetstid** (PDL) | LMAKoppling | `period.start` | 1..1 | ✓ | – |
| Påfyllnad **batchnr** (LVFS 2012:14) | LMAPafyllnad | `extension[batch]` | 0..1 | ✓ | – |
| Administrering **tidpunkt** (HSLF-FS 2016:40) | LMALakemedelsadministrering | `occurence[x]` | 1..1 | ✓ | – |
| Administrering **utförare** (PDL 3:5§) | LMALakemedelsadministrering | `performer.actor` | 1..1 | ✓ | Reference(Practitioner) m. HSA-id |

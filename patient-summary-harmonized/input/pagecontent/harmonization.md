### Harmoniseringsmetod

Detta IG-spår använder följande källa-till-regel-princip:

1. **EURIDICE EU Health Data API** för åtkomstmönster (document + resource access)
2. **HL7 EU EPS** för Patient Summary-innehåll och constraints
3. **Xt-EHR EHDS Patient Summary logiska modeller** för rekommenderade informationsmängder och strukturell komplettering

---

#### Konkreta regler – patientidentitet och demografi

- `Patient.identifier` skärps till minst ett identifieringsvärde för robust patient-matchning i resource access-flöden.
- `Patient.name` använder EPS-regeln (motsv. `eu-pat-1`): family/given/text eller data-absent-reason.
- `Patient.gender` och `Patient.birthDate` sätts till obligatoriska för kliniskt användbar summary-kärna.

#### Konkreta regler – läkemedelsbehandling

- `MedicationStatement.subject`, `medication[x]` och `status` skärps för säkrare tolkning av läkemedelsbehandling.
- `MedicationStatement.medicationCodeableConcept` tillåter ATC/SNOMED-kodning explicit (öppen slicing). Nationellt primärval: NPL-id via Nationella läkemedelslistan.

#### Konkreta regler – överkänslighet och medicinska varningar

- **Överkänslighet** (EHDSAllergyIntolerance): täcker allergier och överkänsligheter mot substanser. Representeras med `AllergyIntolerance`-resursen (LOINC 48765-2). Nationell källa: UMI överkänslighetsdelen.
- **Medicinska varningar** (EHDSAlert): kliniska varningar som **inte** är överkänslighet – t.ex. säkerhetsvarningar och riskfaktorer. Representeras med `Flag`-resursen (LOINC 75310-3). Nationell källa: UMI varningsdelen.
- Dessa är **två separata informationsmängder** med skilda FHIR-resurser och separata sektioner i Composition, i enlighet med eHälsomyndighetens gap-analys (Dnr 2024/04403, oktober 2025).

#### Konkreta regler – Composition och dokumentstruktur

Composition-profilen definierar obligatoriska och valfria sektioner slicade på LOINC-kod, i enlighet med
Xt-EHR EHDS Patient Summary A.1.7–A.1.13 och eHälsomyndighetens svenska terminologi:

| Sektion (svenska) | EHDS-term | LOINC | Xt-EHR | Kardinalitet |
|---|---|---|---|---|
| Läkemedelsbehandling | EHDSMedicationStatement | 10160-0 | A.1.7 | **1..1** (SHALL) |
| Överkänslighet | EHDSAllergyIntolerance | 48765-2 | A.1.8 | **1..1** (SHALL) |
| Diagnos/problem | EHDSCondition | 11450-4 | A.1.9 | **1..1** (SHALL) |
| Medicinska varningar | EHDSAlert | 75310-3* | – | 0..1 (SHOULD) |
| Åtgärder | EHDSProcedure | 47519-4 | A.1.10 | 0..1 (SHOULD) |
| Vaccinationer/immuniseringar | EHDSImmunization | 11369-6 | A.1.11 | 0..1 (SHOULD) |
| Användning av medicinteknisk produkt | EHDSDeviceUse | 46264-8 | A.1.12 | 0..1 (SHOULD) |
| Diagnostiska resultat | EHDSObservation | 30954-2 | A.1.13 | 0..1 (SHOULD) |

*LOINC 75310-3 "Health concerns" används i avvaktan på Xt-EHR final code binding för EHDSAlert-sektionen.

Obligatoriska sektioner (1..1) tillåter `emptyReason` för fall där information saknas men sektionen ändå måste inkluderas.

#### Konkreta regler – Bundle

`IneraEHDSPatientSummaryBundle` definierar dokumentbundelns sammansättning:

- `type = document` (EURIDICE document access / EPS)
- `identifier` och `timestamp` obligatoriska (Xt-EHR header + EPS)
- Entries slicade per FHIR-profil via `#profile`-diskriminator
- `composition` och `patient` är obligatoriska (1..1); övriga entry-typer är 0..*
- `entry.fullUrl` krävs per profil-slice i enlighet med FHIR-dokumentregler
- Bundle innehåller separata slices för `flag` (EHDSAlert/medicinska varningar) och `device` (EHDSDevice/medicinteknisk produkt) utöver `deviceUseStatement` (EHDSDeviceUse)

---

#### Kardinalitetsprinciper

- `1..1` när både EPS/Xt-EHR och klinisk användning kräver kärnuppgift.
- `0..*` när uppgift är kompletterande eller varierar mellan implementeringar/medlemsstater.

#### Kodverksprinciper

- Primärt bindning till etablerade FHIR/EU value sets.
- Explicita kodsystemspår (ATC/SNOMED) i harmoniserad profil.
- Nationell skärpning görs i separata derived profiler.

---

Se [Resursorienterad åtkomst](resource-oriented-access.html) för en fullständig sektionsmatris, per-resurs API-krav och gap-analysunderlag mot Inera FHIR Core, Cambio Open Services och befintliga RIVTA-tjänstekontrakt.

---

### Nästa iterationer

- Lägg till svenska nationella värdemängder (ICD-10-SE, Socialstyrelsens allergenregister, ATC-SE, KVÅ).
- Validera profilerna mot konkreta FHIR-exempelinstanser.
- Slutför gap-analystabellerna i resursorienterad-åtkomst-sidan med konkreta åtgärdsförslag.
- Bekräfta slutlig LOINC-kod för EHDSAlert-sektionen när Xt-EHR final specification publiceras.
- Lägg till nationellt derived profil för EHDSAlert med svensk UMI-kontextspecifik kodning.

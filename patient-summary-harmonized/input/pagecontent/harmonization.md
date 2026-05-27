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

#### Konkreta regler – läkemedel

- `MedicationStatement.subject`, `medication[x]` och `status` skärps för säkrare läkemedelstolkning.
- `MedicationStatement.medicationCodeableConcept` tillåter ATC/SNOMED-kodning explicit (öppen slicing).

#### Konkreta regler – Composition och dokumentstruktur

Composition-profilen definierar obligatoriska och valfria sektioner slicade på LOINC-kod, i enlighet med
Xt-EHR EHDS Patient Summary A.1.7–A.1.13:

| Sektion | LOINC | Xt-EHR | Kardinalitet |
|---|---|---|---|
| Läkemedelsöversikt | 10160-0 | A.1.7 | **1..1** (SHALL) |
| Allergier och intoleranser | 48765-2 | A.1.8 | **1..1** (SHALL) |
| Problemlista | 11450-4 | A.1.9 | **1..1** (SHALL) |
| Procedurhistorik | 47519-4 | A.1.10 | 0..1 (SHOULD) |
| Immuniseringar | 11369-6 | A.1.11 | 0..1 (SHOULD) |
| Diagnostiska resultat | 30954-2 | A.1.13 | 0..1 (SHOULD) |

Obligatoriska sektioner (1..1) tillåter `emptyReason` för fall där information saknas men sektionen ändå måste inkluderas.

#### Konkreta regler – Bundle

`IneraEHDSPatientSummaryBundle` definierar dokumentbundelns sammansättning:

- `type = document` (EURIDICE document access / EPS)
- `identifier` och `timestamp` obligatoriska (Xt-EHR header + EPS)
- Entries slicade per FHIR-profil via `#profile`-diskriminator
- `composition` och `patient` är obligatoriska (1..1); övriga entry-typer är 0..*
- `entry.fullUrl` krävs per profil-slice i enlighet med FHIR-dokumentregler

---

#### Kardinalitetsprinciper

- `1..1` när både EPS/Xt-EHR och klinisk användning kräver kärnuppgift.
- `0..*` när uppgift är kompletterande eller varierar mellan implementeringar/medlemsstater.

#### Kodverksprinciper

- Primärt bindning till etablerade FHIR/EU value sets.
- Explicita kodsystemspår (ATC/SNOMED) i harmoniserad profil.
- Nationell skärpning görs i separata derived profiler.

---

### Nästa iterationer

- Lägga till `DeviceUseStatement`-profil och medicinteknisk utrustning-sektion (Xt-EHR A.1.12).
- Lägg till svenska nationella värdemängder (ICD-10-SE, Socialstyrelsens allergenregister, ATC-SE).
- Validera profilerna mot konkreta FHIR-exempelinstanser.

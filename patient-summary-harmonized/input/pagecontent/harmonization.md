### Harmoniseringsmetod

Detta IG-spår använder följande källa-till-regel-princip:

1. **EURIDICE EU Health Data API** för åtkomstmönster (document + resource access)
2. **HL7 EU EPS** för Patient Summary-innehåll och constraints
3. **Xt-EHR EHDS Patient Summary logiska modeller** för rekommenderade informationsmängder och strukturell komplettering

#### Konkreta regler i denna iteration

- `Patient.identifier` skärps till minst ett identifieringsvärde för robust patient-matchning i resource access-flöden.
- `Patient.name` använder EPS-regeln (motsv. `eu-pat-1`): family/given/text eller data-absent-reason.
- `Patient.gender` och `Patient.birthDate` sätts till obligatoriska för kliniskt användbar summary-kärna.
- `MedicationStatement.subject`, `medication[x]` och `status` skärps för säkrare läkemedelstolkning.
- `MedicationStatement.medicationCodeableConcept` tillåter ATC/SNOMED-kodning explicit (öppen slicing).

#### Kardinalitetsprinciper

- `1..1` när både EPS/Xt-EHR och klinisk användning kräver kärnuppgift.
- `0..*` när uppgift är kompletterande eller varierar mellan implementeringar/medlemsstater.

#### Kodverksprinciper

- Primärt bindning till etablerade FHIR/EU value sets.
- Explicita kodsystemspår (ATC/SNOMED) i harmoniserad profil.
- Nationell skärpning görs i separata derived profiler.

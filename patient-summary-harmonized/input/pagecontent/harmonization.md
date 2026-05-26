### Harmoniseringsmetod

Denna iteration prioriterar **konkreta MUST/SHALL/SHOULD från Xt-EHR logiska modeller** för de informationsdelar som har direkt motsvarighet i HL7 EU EPS och/eller EURIDICE resource access.

#### Källprioritering

1. Xt-EHR logiska modeller (primär källa för kardinalitet och semantik)
2. HL7 EU EPS profiler/artifakter (kompatibilitet och europeisk profilering)
3. EURIDICE resource-access mönster (åtkomst- och identitetskrav)

#### Spårbarhetsmatris (regel → profil)

- **Xt-EHR EHDSPatientSummary.header 1..1 (SHALL)** → `Composition.status/type/subject/date/author/title` obligatoriska.
- **Xt-EHR EHDSPatientSummary.header.identifier 1..* (SHALL)** → `Composition.identifier 1..*`.
- **Xt-EHR patientdemografi (MUST för klinisk tolkning)** → `Patient.identifier`, `Patient.gender`, `Patient.birthDate`.
- **Xt-EHR/EPS läkemedelsöversikt (SHALL kärninformation)** → `MedicationStatement.subject`, `medication[x]`, `status`.
- **Xt-EHR sektioner med EPS-motsvarighet**:
  - Allergier/intoleranser → `AllergyIntolerance`
  - Problem/diagnoser → `Condition`
  - Utförda procedurer → `Procedure`
  - Immuniseringar → `Immunization`
  - Resultat (observationer) → `Observation`

#### Kodverksstrategi

- Bindningar läggs som `preferred` till FHIR/IPS-värdemängder där EU-överenskomna bindningar ännu inte är stabilt publicerade i EPS CI-build.
- Explicit kodsystemsstöd för läkemedel: ATC + SNOMED-slicing i `MedicationStatement`.
- Nationell skärpning (required/extensible) görs i derived profiler per användningsfall.

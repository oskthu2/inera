### Ändringslogg

---

### 0.3.0 (2026-05-12) – Terminologimodell och FHIR R5-konsolidering

**Ny dokumentation**

- Ny sida [Terminologimodell och concept maps](conceptmaps.html) som beskriver
  hur informationsmodellens kodurval härletts till lagerindelade CodeSystems/ValueSets
  och hur dessa bindningar tillämpas normativt i FHIR-profilerna. Sidan innehåller
  mappningstabeller mot FHIR-standardterminologi (grund för framtida ConceptMap-resurser)
  samt ett flödesdiagram över artefaktkedjan från standard till profil.

**Profil- och mappningskorrigeringar**

- `mappings.md`: Uppdaterade alla R4-specifika termer till R5:
  - `effective[x]` → `occurence[x]` i LMALakemedelsadministrering
  - `statusReason[x]` → `notPerformedReason` i LMALakemedelsoverlamnande
  - `DeviceUseStatement` → `DeviceAssociation` i klassöversikt och profiltabell
  - `medication[x]` (R4) → `medication` (CodeableReference, R5)
- `profiles.md`: Uppdaterad profiltabell med korrekta R5-basresurser.
- `logical-model.md`: Koppling-raden uppdaterad till `DeviceAssociation`.

---

### 0.2.0 (2026-03-15) – Migrering till FHIR R5

**Bryta förändring – FHIR-version uppgraderad från R4 (4.0.1) till R5 (5.0.0)**

Samtliga profiler och exempelinstanser uppdaterade för R5-kompatibilitet:

| Profil | R4-konstrukt | R5-konstrukt |
|--------|-------------|-------------|
| LMAKoppling | `DeviceUseStatement` | `DeviceAssociation` |
| LMAKoppling | `timing[x]` / `timingPeriod` | `period` / `period.start` / `period.end` |
| LMAKoppling | `source` | `operation.operator` |
| LMALakemedelsoverlamnande | `medication[x]` | `medication` (CodeableReference) |
| LMALakemedelsoverlamnande | `statusReason[x]` | `notPerformedReason` (CodeableReference) |
| LMALakemedelsadministrering | `medication[x]` | `medication` (CodeableReference) |
| LMALakemedelsadministrering | `effective[x]` | `occurence[x]` |
| LMALakemedelsadministrering | `partOf` (enbart MedicationAdministration) | `partOf` stöder nu även `MedicationDispense` |

Exempelinstanser uppdaterade med R5-syntax. DeviceAssociation-status `#active` → `#attached`.

---

### 0.1.0 (2025-11-01) – Initialt utkast

Första publicerade utkastet av LMA API-standard FHIR IG för FHIR R4.

**Profiler:** LMABrukare, LMAAutomat, LMAKoppling, LMALakemedelsoverlamnande,
LMALakemedelsadministrering, LMAPafyllnad

**Terminologi:** 7 CodeSystems, 7 ValueSets med strikt lagerindelning
(enhetslager / omvårdnadslager)

**Extensions:** ext-lma-batch (batchnummer LVFS 2012:14)

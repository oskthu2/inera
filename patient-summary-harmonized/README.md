# Harmoniserade FHIR-profiler för EHDS Patient Summary (Inera)

Den här mappen innehåller en komplett första uppsättning harmoniserade FSH-profiler för de Xt-EHR Patient Summary-delar som har motsvarighet i HL7 EU EPS och/eller EURIDICE.

## Källor

- EURIDICE EU Health Data API (resource access)
- HL7 EU EPS artifacts
- Xt-EHR EHDS Patient Summary logiska modeller

## Profiler i scope

- `IneraEHDSPatientSummaryComposition`
- `IneraEHDSPatientSummaryPatient`
- `IneraEHDSPatientSummaryMedicationStatement`
- `IneraEHDSPatientSummaryAllergyIntolerance`
- `IneraEHDSPatientSummaryCondition`
- `IneraEHDSPatientSummaryProcedure`
- `IneraEHDSPatientSummaryImmunization`
- `IneraEHDSPatientSummaryObservationResults`

## Principer

1. Xt-EHR används som primär källa för MUST/SHALL/SHOULD (kardinalitet + semantik).
2. EPS används för europeisk interoperabilitet och profilkompatibilitet.
3. EURIDICE används för åtkomstmönster och identifieringskrav.
4. Varje profil har tydliga kardinaliteter och initiala bindningar.

## Validering

- Bygg med SUSHI när verktyget finns tillgängligt.
- Därefter validering med IG Publisher/validator och exempelinstanser.

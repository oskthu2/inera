### Inera EHDS Patient Summary Harmonized

Denna implementation guide sammanställer profilkrav för Patient Summary genom att harmonisera:

1. **EURIDICE EU Health Data API** (resursorienterad och dokumentorienterad åtkomst)
2. **HL7 EU EPS** (ePrescription/eDispensation Patient Summary-artefakter)
3. **Xt-EHR EHDS Patient Summary logisk modell** (informationsmängd och struktur)

Fokus ligger på:

- Enhetliga kardinaliteter med spårning till källa (EURIDICE / EPS / Xt-EHR)
- Tydligare kodverksstrategi med explicita system-slices (ATC, SNOMED CT, LOINC)
- Spårbarhet för varje regel via källkommentar i FSH-källkod
- Definierade PS-sektioner i Composition och en komplett dokumentbundle

---

### Profiler

| Profil | Basresurs | Syfte |
|---|---|---|
| IneraEHDSPatientSummaryBundle | Bundle | Dokumentbundle för komplett Patient Summary |
| IneraEHDSPatientSummaryComposition | Composition | Dokumenthuvud + slicade sektioner |
| IneraEHDSPatientSummaryPatient | Patient | Patientidentitet och demografi |
| IneraEHDSPatientSummaryMedicationStatement | MedicationStatement | Läkemedelsöversikt |
| IneraEHDSPatientSummaryAllergyIntolerance | AllergyIntolerance | Allergier och intoleranser |
| IneraEHDSPatientSummaryCondition | Condition | Problemlista / diagnoser |
| IneraEHDSPatientSummaryProcedure | Procedure | Procedurhistorik |
| IneraEHDSPatientSummaryImmunization | Immunization | Immuniseringar |
| IneraEHDSPatientSummaryObservationResults | Observation | Diagnostiska resultat |

### Extension

| Extension | Syfte |
|---|---|
| IneraRequirementOrigin | Märker harmoniseringsregelns ursprung (EURIDICE / EPS / Xt-EHR / Nationell) |

---

Se [Harmoniseringsmetod](harmonization.html) för detaljerad redovisning av källhänvisningar och designbeslut.

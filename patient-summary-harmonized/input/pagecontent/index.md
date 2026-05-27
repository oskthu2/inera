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
| IneraEHDSPatientSummaryDeviceUseStatement | DeviceUseStatement | Medicintekniska produkter / implantat (A.1.12) |
| IneraEHDSPatientSummaryObservationResults | Observation | Diagnostiska resultat |
| IneraEHDSPatientSummaryPractitionerRole | PractitionerRole | Preferred HCP / GP (A.1.3) – Xt-EHR-only |
| IneraEHDSPatientSummaryRelatedPerson | RelatedPerson | Legal guardian / kontaktperson (A.1.4) – Xt-EHR-only |
| IneraEHDSPatientSummaryCoverage | Coverage | Försäkring / betalning (A.1.5) – Xt-EHR-only |
| IneraEHDSPatientSummaryConsent | Consent | Föranmälda direktiv – Xt-EHR-only |
| IneraEHDSPatientSummaryCarePlan | CarePlan | Vårdplan / plan of care – Xt-EHR-only |
| IneraEHDSPatientSummaryDiagnosticReport | DiagnosticReport | Strukturerade diagnostiska rapporter – Xt-EHR-only |

### CapabilityStatements

| Artefakt | Scope | Syfte |
|---|---|---|
| IneraEHDSPSServerEURIDICECore | EURIDICE Core | Minimum för cross-border resource access (8 resurser) |
| IneraEHDSPSServerXtEHRFull | Full Xt-EHR PS | Komplett scope inkl. header och valfria sektioner (15 resurser) |

### Extension

| Extension | Syfte |
|---|---|
| IneraRequirementOrigin | Märker harmoniseringsregelns ursprung (EURIDICE / EPS / Xt-EHR / Nationell) |

---

Se [Harmoniseringsmetod](harmonization.html) för källhänvisningar och designbeslut, och [Resursorienterad åtkomst](resource-oriented-access.html) för API-krav och gap-analysunderlag.

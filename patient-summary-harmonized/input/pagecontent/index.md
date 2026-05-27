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

| Profil | EHDS-informationsmängd | Basresurs | Syfte |
|---|---|---|---|
| IneraEHDSPatientSummaryBundle | – | Bundle | Dokumentbundle för komplett Patient Summary |
| IneraEHDSPatientSummaryComposition | – | Composition | Dokumenthuvud + slicade sektioner |
| IneraEHDSPatientSummaryPatient | EHDSPatient | Patient | Patientidentitet och demografi |
| IneraEHDSPatientSummaryMedicationStatement | EHDSMedicationStatement | MedicationStatement | Läkemedelsbehandling (A.1.7) |
| IneraEHDSPatientSummaryAllergyIntolerance | EHDSAllergyIntolerance | AllergyIntolerance | Överkänslighet (A.1.8) – allergier och överkänsligheter |
| IneraEHDSPatientSummaryFlag | EHDSAlert | Flag | Medicinska varningar – kliniska varningar skilda från överkänslighet; UMI-varningsdelen |
| IneraEHDSPatientSummaryCondition | EHDSCondition | Condition | Diagnos/problem (A.1.9) – aktiv problemlista och historiska sjukdomar |
| IneraEHDSPatientSummaryProcedure | EHDSProcedure | Procedure | Åtgärder (A.1.10) – KVÅ, SNOMED CT |
| IneraEHDSPatientSummaryImmunization | EHDSImmunization | Immunization | Vaccinationer/immuniseringar (A.1.11) |
| IneraEHDSPatientSummaryDeviceUseStatement | EHDSDeviceUse | DeviceUseStatement | Användning av medicinteknisk produkt (A.1.12) |
| IneraEHDSPatientSummaryDevice | EHDSDevice | Device | Medicinteknisk produkt med UDI-identifierare per EU MDR (A.1.12) |
| IneraEHDSPatientSummaryObservationResults | EHDSObservation | Observation | Diagnostiska resultat (A.1.13) |
| IneraEHDSPatientSummaryPractitionerRole | EHDSHealthProfessional | PractitionerRole | Patientansvarig/husläkare (A.1.3) – Xt-EHR-only |
| IneraEHDSPatientSummaryRelatedPerson | EHDSRelatedPerson | RelatedPerson | Legalt ombud / kontaktperson (A.1.4) – Xt-EHR-only |
| IneraEHDSPatientSummaryCoverage | EHDSInsurance | Coverage | Försäkring / betalning (A.1.5) – Xt-EHR-only |
| IneraEHDSPatientSummaryConsent | EHDSAdvanceDirective | Consent | Föranmälda direktiv – Xt-EHR-only |
| IneraEHDSPatientSummaryCarePlan | EHDSCarePlan | CarePlan | Vårdplan – Xt-EHR-only |
| IneraEHDSPatientSummaryDiagnosticReport | EHDSDiagnosticReport | DiagnosticReport | Strukturerade diagnostiska rapporter – Xt-EHR-only |

### CapabilityStatements

| Artefakt | Scope | Syfte |
|---|---|---|
| IneraEHDSPSServerEURIDICECore | EURIDICE Core | Minimum för cross-border resource access (10 resurser inkl. Flag och Device) |
| IneraEHDSPSServerXtEHRFull | Full Xt-EHR PS | Komplett scope inkl. header och valfria sektioner (17 resurser); inkluderar och utökar EURIDICE Core via instantiatesCanonical |

### Extension

| Extension | Syfte |
|---|---|
| IneraRequirementOrigin | Märker harmoniseringsregelns ursprung (EURIDICE / EPS / Xt-EHR / Nationell) |

---

Se [Harmoniseringsmetod](harmonization.html) för källhänvisningar och designbeslut, och [Resursorienterad åtkomst](resource-oriented-access.html) för API-krav och gap-analysunderlag.

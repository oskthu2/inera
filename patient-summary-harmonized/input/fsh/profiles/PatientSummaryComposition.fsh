Alias: $LNC = http://loinc.org

Profile: IneraEHDSPatientSummaryComposition
Parent: Composition
Id: inera-ehds-patient-summary-composition
Title: "Inera EHDS Patient Summary Composition"
Description: "Harmoniserad Composition för Patient Summary. MUST/SHALL/SHOULD från Xt-EHR logiska modeller omsatta till FHIR-kardinalitet och bindningar med EPS/EURIDICE-kompatibilitet. Sektioner är slicade på LOINC-kod i enlighet med Xt-EHR EHDS PS A.1.7–A.1.13."

* ^status = #draft
* ^experimental = false

// --- Header (Xt-EHR EHDSPatientSummary.header 1..1 → SHALL) ---
* status 1..1
* type 1..1
* type = $LNC#60591-5
* subject 1..1
* date 1..1
* author 1..*
* title 1..1

// Xt-EHR header.identifier 1..* → SHALL (FHIR Composition tillåter max 1)
* identifier 1..1
* identifier.system 1..1
* identifier.value 1..1

// --- Section-slicing (Xt-EHR EHDS PS A.1.7–A.1.13) ---
// Diskriminator på mönster i section.code (LOINC)
* section ^slicing.discriminator.type = #pattern
* section ^slicing.discriminator.path = "code"
* section ^slicing.rules = #open
* section ^short = "Patient Summary-sektioner – läkemedel, allergier och problemlista är obligatoriska"

* section contains
    medications  1..1 and   // Xt-EHR A.1.7 – SHALL
    allergies    1..1 and   // Xt-EHR A.1.8 – SHALL
    problems     1..1 and   // Xt-EHR A.1.9 – SHALL
    procedures   0..1 and   // Xt-EHR A.1.10 – SHOULD
    immunizations 0..1 and  // Xt-EHR A.1.11 – SHOULD
    devices      0..1 and   // Xt-EHR A.1.12 – SHOULD
    results      0..1 and   // Xt-EHR A.1.13 – SHOULD
    pastHistory  0..1 and   // Xt-EHR: historiska sjukdomar – Xt-EHR-only
    advDir       0..1 and   // Xt-EHR: advance directives – Xt-EHR-only
    planOfCare   0..1       // Xt-EHR: plan of care – Xt-EHR-only

// --- Läkemedelsöversikt (Xt-EHR A.1.7 / LOINC 10160-0) ---
* section[medications].code = $LNC#10160-0
* section[medications].code 1..1
* section[medications].title 1..1
* section[medications].entry 0..*
* section[medications].entry only Reference(IneraEHDSPatientSummaryMedicationStatement)
* section[medications].emptyReason 0..1

// --- Allergier och intoleranser (Xt-EHR A.1.8 / LOINC 48765-2) ---
* section[allergies].code = $LNC#48765-2
* section[allergies].code 1..1
* section[allergies].title 1..1
* section[allergies].entry 0..*
* section[allergies].entry only Reference(IneraEHDSPatientSummaryAllergyIntolerance)
* section[allergies].emptyReason 0..1

// --- Problemlista / diagnoser (Xt-EHR A.1.9 / LOINC 11450-4) ---
* section[problems].code = $LNC#11450-4
* section[problems].code 1..1
* section[problems].title 1..1
* section[problems].entry 0..*
* section[problems].entry only Reference(IneraEHDSPatientSummaryCondition)
* section[problems].emptyReason 0..1

// --- Procedurhistorik (Xt-EHR A.1.10 / LOINC 47519-4) ---
* section[procedures].code = $LNC#47519-4
* section[procedures].code 1..1
* section[procedures].title 1..1
* section[procedures].entry 0..*
* section[procedures].entry only Reference(IneraEHDSPatientSummaryProcedure)

// --- Immuniseringar (Xt-EHR A.1.11 / LOINC 11369-6) ---
* section[immunizations].code = $LNC#11369-6
* section[immunizations].code 1..1
* section[immunizations].title 1..1
* section[immunizations].entry 0..*
* section[immunizations].entry only Reference(IneraEHDSPatientSummaryImmunization)

// --- Medicintekniska produkter / implantat (Xt-EHR A.1.12 / LOINC 46264-8) ---
* section[devices].code = $LNC#46264-8
* section[devices].code 1..1
* section[devices].title 1..1
* section[devices].entry 0..*
* section[devices].entry only Reference(IneraEHDSPatientSummaryDeviceUseStatement)

// --- Diagnostiska resultat (Xt-EHR A.1.13 / LOINC 30954-2) ---
* section[results].code = $LNC#30954-2
* section[results].code 1..1
* section[results].title 1..1
* section[results].entry 0..*
* section[results].entry only Reference(IneraEHDSPatientSummaryObservationResults)

// --- Historiska sjukdomar / tidigare problem (Xt-EHR only / LOINC 11348-0) ---
* section[pastHistory].code = $LNC#11348-0
* section[pastHistory].code 1..1
* section[pastHistory].title 1..1
* section[pastHistory].entry 0..*
* section[pastHistory].entry only Reference(IneraEHDSPatientSummaryCondition)

// --- Föranmälda direktiv (Xt-EHR only / LOINC 42348-3) ---
* section[advDir].code = $LNC#42348-3
* section[advDir].code 1..1
* section[advDir].title 1..1
* section[advDir].entry 0..*
* section[advDir].entry only Reference(IneraEHDSPatientSummaryConsent)

// --- Vårdplan / plan of care (Xt-EHR only / LOINC 18776-5) ---
* section[planOfCare].code = $LNC#18776-5
* section[planOfCare].code 1..1
* section[planOfCare].title 1..1
* section[planOfCare].entry 0..*
* section[planOfCare].entry only Reference(IneraEHDSPatientSummaryCarePlan)

Profile: IneraEHDSPatientSummaryBundle
Parent: Bundle
Id: inera-ehds-patient-summary-bundle
Title: "Inera EHDS Patient Summary Bundle"
Description: "FHIR Bundle av typen 'document' som utgör ett komplett, självständigt Patient Summary-dokument. Harmoniserad mot Xt-EHR EHDS Patient Summary, HL7 EU EPS och EURIDICE Resource Access. Bundelns entry-lista är slicad per profil för tydlig typkontroll."

* ^status = #draft
* ^experimental = false

// FHIR-dokumentbundle: type = document (EPS / EURIDICE document access)
* type 1..1
* type = #document

// Unik dokumentidentifierare (Xt-EHR header.identifier – EURIDICE document access)
* identifier 1..1
* identifier.system 1..1
* identifier.value 1..1

// Tidsstämpel för bundelns generering (EPS + Xt-EHR)
* timestamp 1..1

// --- Entry slicing (diskriminator = resursens konformanta profil) ---
* entry ^slicing.discriminator.type = #profile
* entry ^slicing.discriminator.path = "resource"
* entry ^slicing.rules = #open
* entry 2..*

* entry contains
    composition         1..1 and  // obligatorisk: dokumentets Composition
    patient             1..1 and  // obligatorisk: den summerade patienten
    allergy             0..* and  // Xt-EHR A.1.8 AllergyIntolerance
    condition           0..* and  // Xt-EHR A.1.9 Condition (problemlista)
    medicationStatement 0..* and  // Xt-EHR A.1.7 MedicationStatement
    immunization        0..* and  // Xt-EHR A.1.11 Immunization
    procedure           0..* and  // Xt-EHR A.1.10 Procedure
    device              0..* and  // Xt-EHR A.1.12 DeviceUseStatement
    observation         0..* and  // Xt-EHR A.1.13 Observation (resultat)
    relatedPerson       0..* and  // Xt-EHR header: legal guardian – Xt-EHR-only
    coverage            0..* and  // Xt-EHR header: insurance – Xt-EHR-only
    practitionerRole    0..* and  // Xt-EHR header: preferred HCP – Xt-EHR-only
    consent             0..* and  // Xt-EHR: advance directives – Xt-EHR-only
    carePlan            0..* and  // Xt-EHR: plan of care – Xt-EHR-only
    diagnosticReport    0..*      // Xt-EHR: strukturerade rapporter – Xt-EHR-only

// Composition (EURIDICE, EPS, Xt-EHR: krävs alltid som första entry i dokumentbundle)
* entry[composition].resource 1..1
* entry[composition].resource only IneraEHDSPatientSummaryComposition
* entry[composition].fullUrl 1..1

// Patient (kärna i alla PS-specifikationer)
* entry[patient].resource 1..1
* entry[patient].resource only IneraEHDSPatientSummaryPatient
* entry[patient].fullUrl 1..1

// Allergier och intoleranser
* entry[allergy].resource 1..1
* entry[allergy].resource only IneraEHDSPatientSummaryAllergyIntolerance
* entry[allergy].fullUrl 1..1

// Diagnoser / problemlista
* entry[condition].resource 1..1
* entry[condition].resource only IneraEHDSPatientSummaryCondition
* entry[condition].fullUrl 1..1

// Läkemedelsöversikt
* entry[medicationStatement].resource 1..1
* entry[medicationStatement].resource only IneraEHDSPatientSummaryMedicationStatement
* entry[medicationStatement].fullUrl 1..1

// Immuniseringar
* entry[immunization].resource 1..1
* entry[immunization].resource only IneraEHDSPatientSummaryImmunization
* entry[immunization].fullUrl 1..1

// Procedurer
* entry[procedure].resource 1..1
* entry[procedure].resource only IneraEHDSPatientSummaryProcedure
* entry[procedure].fullUrl 1..1

// Medicintekniska produkter / implantat
* entry[device].resource 1..1
* entry[device].resource only IneraEHDSPatientSummaryDeviceUseStatement
* entry[device].fullUrl 1..1

// Laboratorieresultat / vitala parametrar
* entry[observation].resource 1..1
* entry[observation].resource only IneraEHDSPatientSummaryObservationResults
* entry[observation].fullUrl 1..1

* entry[relatedPerson].resource 1..1
* entry[relatedPerson].resource only IneraEHDSPatientSummaryRelatedPerson
* entry[relatedPerson].fullUrl 1..1

* entry[coverage].resource 1..1
* entry[coverage].resource only IneraEHDSPatientSummaryCoverage
* entry[coverage].fullUrl 1..1

* entry[practitionerRole].resource 1..1
* entry[practitionerRole].resource only IneraEHDSPatientSummaryPractitionerRole
* entry[practitionerRole].fullUrl 1..1

* entry[consent].resource 1..1
* entry[consent].resource only IneraEHDSPatientSummaryConsent
* entry[consent].fullUrl 1..1

* entry[carePlan].resource 1..1
* entry[carePlan].resource only IneraEHDSPatientSummaryCarePlan
* entry[carePlan].fullUrl 1..1

* entry[diagnosticReport].resource 1..1
* entry[diagnosticReport].resource only IneraEHDSPatientSummaryDiagnosticReport
* entry[diagnosticReport].fullUrl 1..1

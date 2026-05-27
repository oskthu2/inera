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
    composition       1..1 and  // obligatorisk: dokumentets Composition
    patient           1..1 and  // obligatorisk: den summerade patienten
    allergy           0..* and  // Xt-EHR A.1.8 AllergyIntolerance
    condition         0..* and  // Xt-EHR A.1.9 Condition (problemlista)
    medicationStatement 0..* and // Xt-EHR A.1.7 MedicationStatement
    immunization      0..* and  // Xt-EHR A.1.11 Immunization
    procedure         0..* and  // Xt-EHR A.1.10 Procedure
    observation       0..*      // Xt-EHR A.1.13 Observation (resultat)

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

// Laboratorieresultat / vitala parametrar
* entry[observation].resource 1..1
* entry[observation].resource only IneraEHDSPatientSummaryObservationResults
* entry[observation].fullUrl 1..1

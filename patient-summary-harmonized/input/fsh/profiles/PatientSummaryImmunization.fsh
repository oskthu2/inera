Profile: IneraEHDSPatientSummaryImmunization
Parent: Immunization
Id: inera-ehds-patient-summary-immunization
Title: "Inera EHDS Patient Summary Immunization"
Description: "Immuniseringsprofil harmoniserad mot Xt-EHR Immunization-sektion och EPS/IPS."

* ^status = #draft
* ^experimental = false

* status 1..1
* vaccineCode 1..1
* vaccineCode from http://hl7.org/fhir/ValueSet/vaccine-code (preferred)
* patient 1..1
* occurrence[x] 1..1

// SHOULD: lot/performer när tillgängligt
* lotNumber 0..1
* performer 0..*

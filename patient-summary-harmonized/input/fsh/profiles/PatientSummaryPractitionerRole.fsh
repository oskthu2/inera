Profile: IneraEHDSPatientSummaryPractitionerRole
Parent: PractitionerRole
Id: inera-ehds-patient-summary-practitioner-role
Title: "Inera EHDS Patient Summary PractitionerRole"
Description: "Profil för patientens föredragna vårdgivare / intygsgivande läkare (Xt-EHR EHDS PS header: preferred healthcare professional). Kopplar Practitioner till Organisation och specialitet. Ej i EURIDICE core – Xt-EHR-only."

* ^status = #draft
* ^experimental = false

// Xt-EHR: identifierbar vårdgivare krävs i header
* practitioner 1..1
* practitioner only Reference(Practitioner)

// Xt-EHR: organisation koppling SHOULD
* organization 0..1
* organization only Reference(Organization)

// SHOULD: specialitet för klinisk kontext
* specialty 0..*
* specialty from http://hl7.org/fhir/ValueSet/c80-practice-codes (preferred)

* active 0..1
* identifier 0..*

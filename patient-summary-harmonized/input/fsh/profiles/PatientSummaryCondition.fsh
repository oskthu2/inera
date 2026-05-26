Alias: $ConditionClinical = http://terminology.hl7.org/CodeSystem/condition-clinical

Profile: IneraEHDSPatientSummaryCondition
Parent: Condition
Id: inera-ehds-patient-summary-condition
Title: "Inera EHDS Patient Summary Condition"
Description: "Problem/diagnosprofil harmoniserad för Xt-EHR ProblemList och EPS Patient Summary."

* ^status = #draft
* ^experimental = false

// SHALL: koppling till patient
* subject 1..1

// SHALL: tillståndet måste kunna förstås kliniskt
* code 1..1
* code from http://hl7.org/fhir/ValueSet/condition-code (preferred)

// SHOULD: status för att tolka om problemet är aktivt/inaktivt
* clinicalStatus 0..1
* clinicalStatus from http://hl7.org/fhir/ValueSet/condition-clinical (preferred)

// SHOULD: onset/recordedDate som tidsankare
* onset[x] 0..1
* recordedDate 0..1

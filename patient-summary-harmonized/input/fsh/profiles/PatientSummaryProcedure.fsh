Profile: IneraEHDSPatientSummaryProcedure
Parent: Procedure
Id: inera-ehds-patient-summary-procedure
Title: "Inera EHDS Patient Summary Procedure"
Description: "Procedureprofil för Xt-EHR History of Procedures med motsvarighet i EPS Patient Summary."

* ^status = #draft
* ^experimental = false

* subject 1..1
* status 1..1
* code 1..1
* code from http://hl7.org/fhir/ValueSet/procedure-code (preferred)

// SHOULD: tidsankare
* performed[x] 0..1

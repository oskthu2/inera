Alias: $ObsCategory = http://terminology.hl7.org/CodeSystem/observation-category

Profile: IneraEHDSPatientSummaryObservationResults
Parent: Observation
Id: inera-ehds-patient-summary-observation-results
Title: "Inera EHDS Patient Summary Observation Results"
Description: "Observationprofil för resultat (lab/vitala parametrar) harmoniserad mot Xt-EHR-sektioner och EPS/IPS."

* ^status = #draft
* ^experimental = false

* status 1..1
* code 1..1
* code from http://hl7.org/fhir/ValueSet/observation-codes (preferred)
* subject 1..1
* effective[x] 1..1
* value[x] 0..1

* category 1..*
* category.coding 1..*
* category.coding.system 1..1
* category.coding.code 1..1

Profile: IneraEHDSPatientSummaryAllergyIntolerance
Parent: AllergyIntolerance
Id: inera-ehds-patient-summary-allergy-intolerance
Title: "Inera EHDS Patient Summary AllergyIntolerance"
Description: "Allergi/intoleransprofil harmoniserad mot Xt-EHR-sektionen Allergies and Intolerances samt EPS/IPS."

* ^status = #draft
* ^experimental = false

* patient 1..1
* clinicalStatus 0..1
* verificationStatus 0..1

// SHALL: klinisk substans/agent behöver uttryckas
* code 1..1
* code from http://hl7.org/fhir/ValueSet/allergyintolerance-code (preferred)

// SHOULD: reaktion och kritikalitet när känt
* criticality 0..1
* reaction 0..*
* reaction.substance 0..1
* reaction.manifestation 1..*

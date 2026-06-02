Profile: IneraEHDSPatientSummaryAllergyIntolerance
Parent: AllergyIntolerance
Id: inera-ehds-patient-summary-allergy-intolerance
Title: "Inera EHDS Patient Summary AllergyIntolerance (EHDSAllergyIntolerance – Överkänslighet)"
Description: "Profil för överkänslighet (EHDSAllergyIntolerance) harmoniserad mot Xt-EHR-sektionen Allergies and Intolerances (A.1.8) samt EPS/IPS. Täcker allergier och överkänsligheter mot substanser. Obs: medicinska varningar som INTE är överkänslighet representeras separat i IneraEHDSPatientSummaryFlag (EHDSAlert). Nationell motsvarighet i Sverige: UMI överkänslighetsdelen i NPÖ GetAlertInformation."

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

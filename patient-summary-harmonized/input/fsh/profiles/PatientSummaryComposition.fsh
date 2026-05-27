Alias: $LNC = http://loinc.org

Profile: IneraEHDSPatientSummaryComposition
Parent: Composition
Id: inera-ehds-patient-summary-composition
Title: "Inera EHDS Patient Summary Composition"
Description: "Harmoniserad Composition för Patient Summary. MUST/SHALL/SHOULD från Xt-EHR logiska modeller omsatta till FHIR-kardinalitet och bindningar med EPS/EURIDICE-kompatibilitet."

* ^status = #draft
* ^experimental = false

// Xt-EHR EHDSPatientSummary.header 1..1 -> SHALL
* status 1..1
* type 1..1
* type = $LNC#60591-5
* subject 1..1
* date 1..1
* author 1..*
* title 1..1

// OBS: Xt-EHR anger header.identifier 1..*, men FHIR Composition.identifier är 0..1.
// Vi bryter inte FHIR-kardinalitet; istället skärper vi till max tillåtna 1..1.
* identifier 1..1
* identifier.system 1..1
* identifier.value 1..1

// SHOULD: sectioner representerar Patient Summary-domäner i Xt-EHR
* section 1..*
* section.title 1..1
* section.code 1..1
* section.entry 0..*

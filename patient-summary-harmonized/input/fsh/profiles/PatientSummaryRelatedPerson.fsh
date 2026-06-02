Profile: IneraEHDSPatientSummaryRelatedPerson
Parent: RelatedPerson
Id: inera-ehds-patient-summary-related-person
Title: "Inera EHDS Patient Summary RelatedPerson"
Description: "Profil för legal ställföreträdare, nödkontakt eller annan auktoriserad representant (Xt-EHR EHDS PS header: legal guardian / authorized representative). Ej i EURIDICE core – Xt-EHR-only."

* ^status = #draft
* ^experimental = false

// Xt-EHR: koppling till patient obligatorisk
* patient 1..1

// Xt-EHR: relation ska anges
* relationship 1..*
* relationship from http://hl7.org/fhir/ValueSet/relatedperson-relationshiptype (preferred)

// SHOULD: identifiering och namn
* identifier 0..*
* name 0..*
* telecom 0..*
* active 0..1

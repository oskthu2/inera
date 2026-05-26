Alias: $DAR = http://hl7.org/fhir/StructureDefinition/data-absent-reason
Alias: $V3NullFlavor = http://terminology.hl7.org/CodeSystem/v3-NullFlavor

Profile: IneraEHDSPatientSummaryPatient
Parent: Patient
Id: inera-ehds-patient-summary-patient
Title: "Inera EHDS Patient Summary Patient"
Description: "Harmoniserad Patient-profil för Patient Summary med explicita regler spårade till EURIDICE Resource Access, HL7 EU EPS och Xt-EHR EHDS Patient Summary."

* ^status = #draft
* ^experimental = false

// EURIDICE Resource Access: Patient används som lookup-kontekst -> identifieringsfält ska alltid kunna bära matchning
* identifier 1..*
* identifier.system 1..1
* identifier.value 1..1

// EPS patient constraint (eu-pat-1): minst en name-komponent eller data-absent-reason
* name 1..*
* name obeys inera-eu-pat-1
* name.family 0..1
* name.given 0..*
* name.text 0..1
* name.extension contains $DAR named dataAbsentReason 0..1
* name.extension[dataAbsentReason].valueCode 1..1
* name.extension[dataAbsentReason].valueCode from http://hl7.org/fhir/ValueSet/data-absent-reason (required)

// Xt-EHR PS: centrala demografiska fält
* gender 1..1
* birthDate 1..1

// Xt-EHR logical model rekommenderar kontakt/kommunikation i summary när tillgängligt
* telecom 0..*
* address 0..*
* communication 0..*

Invariant: inera-eu-pat-1
Description: "family, given, text eller data-absent-reason ska finnas enligt EPS-princip."
Expression: "family.exists() or given.exists() or text.exists() or extension('http://hl7.org/fhir/StructureDefinition/data-absent-reason').exists()"
Severity: #error

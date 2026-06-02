Profile: IneraEHDSPatientSummaryConsent
Parent: Consent
Id: inera-ehds-patient-summary-consent
Title: "Inera EHDS Patient Summary Consent"
Description: "Föranmälda direktiv (advance directives) och patientens informerade samtycke (Xt-EHR EHDS PS: advance directives-sektion, LOINC 42348-3). Inkluderar DNR-beslut, behandlingsavstående och liknande. Ej i EURIDICE core – Xt-EHR-only."

* ^status = #draft
* ^experimental = false

// SHALL: status för att förstå om direktivet är aktivt
* status 1..1

// SHALL: omfång – advance directive
* scope 1..1
* scope from http://hl7.org/fhir/ValueSet/consent-scope (required)

// SHALL: typ av direktiv
* category 1..*
* category from http://hl7.org/fhir/ValueSet/consent-category (preferred)

// SHALL: koppling till patient
* patient 1..1

// SHOULD: datering
* dateTime 0..1

// SHOULD: utfärdande part
* performer 0..*

Profile: IneraEHDSPatientSummaryCoverage
Parent: Coverage
Id: inera-ehds-patient-summary-coverage
Title: "Inera EHDS Patient Summary Coverage"
Description: "Försäkrings- och betalningsinformation (Xt-EHR EHDS PS header: insurance and payment information). Relevant för cross-border behandling och ersättningsfrågor inom EHDS. Ej i EURIDICE core – Xt-EHR-only."

* ^status = #draft
* ^experimental = false

// Xt-EHR: koppling till patient
* beneficiary 1..1

// SHALL: status för att förstå om täckning är aktiv
* status 1..1

// SHOULD: typ av täckning (t.ex. Europeiskt sjukförsäkringskort, nationell försäkring)
* type 0..1
* type from http://hl7.org/fhir/ValueSet/coverage-type (preferred)

// SHOULD: försäkringsgivare / betalare
* payor 0..*

// SHOULD: giltighetsperiod
* period 0..1

* identifier 0..*

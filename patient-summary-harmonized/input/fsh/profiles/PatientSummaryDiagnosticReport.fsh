Profile: IneraEHDSPatientSummaryDiagnosticReport
Parent: DiagnosticReport
Id: inera-ehds-patient-summary-diagnostic-report
Title: "Inera EHDS Patient Summary DiagnosticReport"
Description: "Strukturerade diagnostiska rapporter (laboratoriepaket, röntgensvar) som komplement till enskilda Observation-resurser (Xt-EHR EHDS PS A.1.13 diagnostiska resultat). DiagnosticReport ger sammanhang och rapportenhet; Observation ger enskilda mätvärden. Ej i EURIDICE core – Xt-EHR-only för strukturerade rapporter."

* ^status = #draft
* ^experimental = false

// SHALL: koppling till patient
* subject 1..1

// SHALL: status för rapport
* status 1..1

// SHALL: kategori (laboratory | radiology | cardiology etc.)
* category 1..*
* category from http://hl7.org/fhir/ValueSet/diagnostic-service-sections (preferred)

// SHALL: vad rapporten avser
* code 1..1
* code from http://hl7.org/fhir/ValueSet/report-codes (preferred)

// SHOULD: tidpunkt för provtagning/undersökning
* effective[x] 0..1

// SHOULD: ingående observationer
* result 0..*
* result only Reference(IneraEHDSPatientSummaryObservationResults)

// SHOULD: utfärdande enhet
* performer 0..*

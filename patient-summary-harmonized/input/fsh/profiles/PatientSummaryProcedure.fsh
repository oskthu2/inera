Profile: IneraEHDSPatientSummaryProcedure
Parent: Procedure
Id: inera-ehds-patient-summary-procedure
Title: "Inera EHDS Patient Summary Procedure (EHDSProcedure – Åtgärder)"
Description: "Profil för åtgärder (EHDSProcedure) per Xt-EHR History of Procedures (A.1.10) med motsvarighet i EPS Patient Summary. Avser kirurgiska och terapeutiska ingrepp av klinisk relevans för patientöversikten. Nationell motsvarighet: KVÅ (Klassifikation av vårdåtgärder) som kodverk. Notering: termen 'åtgärder' används genomgående i enlighet med eHälsomyndighetens svenska terminologi för EHDS."

* ^status = #draft
* ^experimental = false

* subject 1..1
* status 1..1
* code 1..1
* code from http://hl7.org/fhir/ValueSet/procedure-code (preferred)

// SHOULD: tidsankare
* performed[x] 0..1

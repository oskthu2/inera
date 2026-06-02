Alias: $ConditionClinical = http://terminology.hl7.org/CodeSystem/condition-clinical

Profile: IneraEHDSPatientSummaryCondition
Parent: Condition
Id: inera-ehds-patient-summary-condition
Title: "Inera EHDS Patient Summary Condition (EHDSCondition – Diagnos/problem)"
Description: "Profil för diagnos/problem (EHDSCondition) harmoniserad mot Xt-EHR A.1.9 (aktiv problemlista) och Xt-EHR historiska sjukdomar (section LOINC 11348-0) samt EPS Patient Summary. Nationell motsvarighet: getDiagnosis via RIVTA/NPÖ. Kodverk: ICD-10-SE (primärt), SNOMED CT. Termen 'diagnos/problem' används i enlighet med eHälsomyndighetens svenska terminologi för EHDS."

* ^status = #draft
* ^experimental = false

// SHALL: koppling till patient
* subject 1..1

// SHALL: tillståndet måste kunna förstås kliniskt
* code 1..1
* code from http://hl7.org/fhir/ValueSet/condition-code (preferred)

// SHOULD: status för att tolka om problemet är aktivt/inaktivt
* clinicalStatus 0..1

// SHOULD: onset/recordedDate som tidsankare
* onset[x] 0..1
* recordedDate 0..1

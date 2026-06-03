Profile: IneraEHDSPatientSummaryCarePlan
Parent: CarePlan
Id: inera-ehds-patient-summary-care-plan
Title: "Inera EHDS Patient Summary CarePlan"
Description: "Vårdplan / plan of care (Xt-EHR EHDS PS: plan of care-sektion, LOINC 18776-5). Inkluderar planerade åtgärder, uppföljningar och behandlingsmål. Ej i EURIDICE core – Xt-EHR-only."

* ^status = #draft
* ^experimental = false

// SHALL: koppling till patient
* subject 1..1

// SHALL: status för plan
* status 1..1

// SHALL: intent (plan | proposal | order)
* intent 1..1

// SHOULD: kategori
* category 0..*
* category from http://hl7.org/fhir/ValueSet/care-plan-category (preferred)

// SHOULD: period för planen
* period 0..1

// SHOULD: planerade aktiviteter
* activity 0..*
* activity.detail 0..1
* activity.detail.code 0..1
// activity.detail.status är 1..1 i FHIR R4-basen; ingen ytterligare begränsning behövs

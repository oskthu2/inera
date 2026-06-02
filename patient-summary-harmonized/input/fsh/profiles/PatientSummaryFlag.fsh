Profile: IneraEHDSPatientSummaryFlag
Parent: Flag
Id: inera-ehds-patient-summary-flag
Title: "Inera EHDS Patient Summary Flag (EHDSAlert – Medicinska varningar)"
Description: "Profil för medicinska varningar (EHDSAlert) per Xt-EHR EHDS Patient Summary. Täcker kliniska varningar som INTE är överkänslighet/allergi – t.ex. säkerhetsvarningar, kritiska riskfaktorer och tillstånd med direkt behandlingskonsekvens. Nationell motsvarighet i Sverige: Uppmärksamhetsinformation (UMI) – varningsdelen (exklusive överkänslighet som täcks av IneraEHDSPatientSummaryAllergyIntolerance). Obs: överkänslighet (EHDS AllergyIntolerance) och medicinska varningar (EHDSAlert) representerar två separata informationsmängder med skilda sektioner i Composition."

* ^status = #draft
* ^experimental = false

// SHALL: flaggans status (Xt-EHR EHDSAlert.alertStatus)
// active | inactive | entered-in-error
* status 1..1

// SHALL: den berörda patienten (Xt-EHR: patient subject)
* subject 1..1
* subject only Reference(IneraEHDSPatientSummaryPatient)

// SHALL: typ av varning – text och/eller kod (Xt-EHR EHDSAlert.alertType / alertDescription)
// Kodverk: SNOMED CT (t.ex. 473010000 "Hypersensitivity condition" bör ej användas här –
//          använd istället AllergyIntolerance-profilen för överkänslighet)
* code 1..1

// SHOULD: kategori för att klassificera varningstypen
// T.ex. drug-intolerance | fall-risk | infection-control | implant-safety
* category 0..*

// SHOULD: period under vilken varningen är giltig (Xt-EHR EHDSAlert.period)
* period 0..1

// SHOULD: den som utfärdat/registrerat varningen (Xt-EHR EHDSAlert.author)
* author 0..1

// SHOULD: prioritet/allvarlighetsgrad för varningen (Xt-EHR EHDSAlert.alertPriority)
// Representeras via standard FHIR flag-priority extension
* extension contains
    http://hl7.org/fhir/StructureDefinition/flag-priority named alertPriority 0..1

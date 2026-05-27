Alias: $SNOMED = http://snomed.info/sct
Alias: $ATC = http://www.whocc.no/atc

Profile: IneraEHDSPatientSummaryMedicationStatement
Parent: MedicationStatement
Id: inera-ehds-patient-summary-medication-statement
Title: "Inera EHDS Patient Summary MedicationStatement"
Description: "Harmoniserad läkemedelsöversikt för Patient Summary med kravspårning till EURIDICE/EPS och Xt-EHR-sektioner för läkemedel."

* ^status = #draft
* ^experimental = false

// EURIDICE Resource Access + PS use case: klinisk post måste vara kopplad till patient
* subject 1..1

// EPS/IPS: representation av läkemedel ska finnas
* medication[x] 1..1
* medication[x] only CodeableConcept or Reference(Medication)

// Miniminivå för säker tolkning av aktuell/avslutad behandling
* status 1..1

// Tidsuppgifter: i summary kan både punkt och period förekomma
* effective[x] 0..1
* effective[x] only dateTime or Period
* dateAsserted 0..1

// Kodverksriktning för harmonisering (skärps nationellt i derived profile vid behov)
* medicationCodeableConcept from http://hl7.org/fhir/ValueSet/medication-codes (preferred)
* medicationCodeableConcept.coding ^slicing.discriminator.type = #value
* medicationCodeableConcept.coding ^slicing.discriminator.path = "system"
* medicationCodeableConcept.coding ^slicing.rules = #open
* medicationCodeableConcept.coding contains ATC 0..* and SNOMED 0..*
* medicationCodeableConcept.coding[ATC].system = $ATC (exactly)
* medicationCodeableConcept.coding[SNOMED].system = $SNOMED (exactly)

// Xt-EHR logical model: doseringsinformation bör följa med när tillgänglig
* dosage 0..*
* dosage.text 0..1

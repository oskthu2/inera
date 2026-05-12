// ============================================================================
// Exempelinstanser – en per profil
// ============================================================================

Instance: example-brukare-01
InstanceOf: LMABrukare
Title: "Exempelbrukare – Erik Svensson"
Description: "Exempelinstans för LMABrukare. Personnummer och namn är fiktiva."
Usage: #example

* identifier[lmaId].system = "https://sis.se/fhir/lma/id/brukare"
* identifier[lmaId].value = "brukare-4711"
* identifier[personnummer].system = "http://electronichealth.se/id/personnummer"
* identifier[personnummer].value = "194501011234"
* active = true
* managingOrganization.identifier.system = "urn:oid:1.2.752.129.2.1.4.1"
* managingOrganization.identifier.value = "SE2321000016-6PF5"
* managingOrganization.display = "Hemtjänst Västerby"
* meta.lastUpdated = "2025-06-01T08:00:00Z"


Instance: example-automat-01
InstanceOf: LMAAutomat
Title: "Exempelautomat – MedRobot 3000"
Description: "Exempelinstans för LMAAutomat med driftsstatus och batterinivå."
Usage: #example

* identifier[+].system = "https://sis.se/fhir/lma/id/automat"
* identifier[=].value = "automat-SE-2024-0042"
* serialNumber = "MR3000-SN-20240042"
* manufacturer = "MedRobot AB"
* modelNumber = "MedRobot 3000"
* version.value = "3.4.1"
* status = #active
* location.display = "Storgatan 12, Lägenhet 3B"


Instance: example-koppling-01
InstanceOf: LMAKoppling
Title: "Exempelkoppling – brukare 4711 till automat 0042"
Description: "Exempelinstans för LMAKoppling. Aktiv koppling sedan 2025-01-15."
Usage: #example

* status = #active
* subject = Reference(example-brukare-01)
* timingPeriod.start = "2025-01-15T09:00:00Z"
* device = Reference(example-automat-01)
* source.identifier.system = "urn:oid:1.2.752.129.2.1.4.1"
* source.identifier.value = "SE2321000016-HSA123"
* source.display = "Leg. sjuksköterska Anna Lindqvist"


Instance: example-overlamnande-01
InstanceOf: LMALakemedelsoverlamnande
Title: "Exempelöverlämning – lyckad, 2025-06-15 08:00"
Description: "Exempelinstans för LMALakemedelsoverlamnande. Planerad och genomförd överlämning."
Usage: #example

* dosageInstruction.timing.event = "2025-06-15T08:00:00Z"
* status = #completed
* medicationCodeableConcept = http://terminology.hl7.org/CodeSystem/data-absent-reason#unknown "Unknown"
* subject = Reference(example-brukare-01)
* performer.actor = Reference(example-automat-01)
* whenHandedOver = "2025-06-15T08:01:23Z"


Instance: example-overlamnande-misslyckad-01
InstanceOf: LMALakemedelsoverlamnande
Title: "Exempelöverlämning – misslyckad, mekaniskt fel"
Description: "Exempelinstans för LMALakemedelsoverlamnande med felkod från enhetslagret."
Usage: #example

* dosageInstruction.timing.event = "2025-06-15T20:00:00Z"
* status = #declined
// Felkod tillhör enhetslagret
* statusReasonCodeableConcept = LMAOverlamninsfelkod#mekaniskt-fel "Mekaniskt fel"
* medicationCodeableConcept = http://terminology.hl7.org/CodeSystem/data-absent-reason#unknown "Unknown"
* subject = Reference(example-brukare-01)
* performer.actor = Reference(example-automat-01)


Instance: example-administrering-01
InstanceOf: LMALakemedelsadministrering
Title: "Exempeladministrering – genomförd av sjuksköterska"
Description: "Exempelinstans för LMALakemedelsadministrering. Kopplar till föregående överlämning."
Usage: #example

* status = #completed
* medicationCodeableConcept = http://terminology.hl7.org/CodeSystem/data-absent-reason#unknown "Unknown"
* subject = Reference(example-brukare-01)
* effectiveDateTime = "2025-06-15T08:05:00Z"
* performer.actor.identifier.system = "urn:oid:1.2.752.129.2.1.4.1"
* performer.actor.identifier.value = "SE2321000016-HSA456"
* performer.actor.display = "Leg. sjuksköterska Karin Holm"
// Obs: länk till LMALakemedelsoverlamnande kan ej uttryckas via partOf i R4
// (partOf tillåter bara Reference(MedicationAdministration|Procedure))


Instance: example-administrering-avbojde-01
InstanceOf: LMALakemedelsadministrering
Title: "Exempeladministrering – brukare avböjde (omvårdnadslager)"
Description: """Exempelinstans för LMALakemedelsadministrering där brukaren avböjde.
Visar korrekt lageruppdelning: orsaken är omvårdnadsbedömd och från omvårdnadslagrets VS."""
Usage: #example

* status = #not-done
// Orsak tillhör omvårdnadslagret – INTE ett tekniskt fel
* statusReason = LMAAdministreringsorsak#brukare-avbojde "Brukare avböjde"
* medicationCodeableConcept = http://terminology.hl7.org/CodeSystem/data-absent-reason#unknown "Unknown"
* subject = Reference(example-brukare-01)
* effectiveDateTime = "2025-06-16T08:10:00Z"
* performer.actor.identifier.system = "urn:oid:1.2.752.129.2.1.4.1"
* performer.actor.identifier.value = "SE2321000016-HSA456"
* performer.actor.display = "Leg. sjuksköterska Karin Holm"


Instance: example-pafyllnad-01
InstanceOf: LMAPafyllnad
Title: "Exempelpåfyllnad – dosrulle batch 2024-LM-9912"
Description: "Exempelinstans för LMAPafyllnad med batchnummer för spårbarhet."
Usage: #example

* status = #completed
* extension[batch].valueString = "2024-LM-9912"
* occurrenceDateTime = "2025-06-14T14:30:00Z"
* suppliedItem.quantity = 28 '1' "doser"
* destination.display = "LMA automat-SE-2024-0042 (Storgatan 12)"
* receiver.identifier.system = "urn:oid:1.2.752.129.2.1.4.1"
* receiver.identifier.value = "SE2321000016-APO789"
* receiver.display = "Farmaceut Maria Johansson, Apoteket Hjärtat"

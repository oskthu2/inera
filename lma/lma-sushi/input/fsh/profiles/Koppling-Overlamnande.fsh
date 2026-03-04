// ============================================================================
// LMAKoppling – DeviceUseStatement
// Lager: enhetslager
// ============================================================================
Profile: LMAKoppling
Parent: DeviceUseStatement
Id: LMAKoppling
Title: "LMA Koppling"
Description: """Kopplingen brukare–automat. Representerar det administrativa
beslutet att en brukare betjänas av en specifik automat under en tidsavgränsad
period. Lager: enhetslager.

**FHIR-migreringsbana:** I FHIR R4 används `DeviceUseStatement`. I FHIR R5/R6
ersätts denna resurs av `DeviceAssociation` med tydligare semantik. IG:ns
profil är designad för att underlätta framtida migrering: logiska attribut
är namngivna i enlighet med R5-resursen."""

// Status
* status 1..1 MS
* status ^short = "Kopplingsstatus"
* status ^comment = """Använd FHIR-koderna från device-statement-status. Konceptmappning: active=aktiv, completed=avslutad, on-hold=pausad."""

// Brukare
* subject 1..1 MS
* subject only Reference(LMABrukare)
* subject ^short = "Brukare (Reference LMABrukare)"

// Giltighetstid
* timing[x] 1..1 MS
* timing[x] only Period
* timing[x] ^short = "Giltighetstid (giltigFrån / giltigTill)"
* timing[x] ^comment = """`timingPeriod.start` = giltigFrån (1..1, obligatorisk).
`timingPeriod.end` = giltigTill (0..1). Null indikerar aktiv koppling.
PDL 3 kap. kräver att kopplingens giltighetstid kan återges."""
* timingPeriod.start 1..1 MS
* timingPeriod.end MS

// Automat
* device 1..1 MS
* device only Reference(LMAAutomat)
* device ^short = "Automat (Reference LMAAutomat)"

// Ansvarig förskrivare
* recordedOn MS
* recordedOn ^short = "Tidpunkt då kopplingen registrerades"

* source MS
* source only Reference(Practitioner)
* source ^short = "Ansvarig förskrivare (HSA-id)"
* source ^comment = "Reference(Practitioner) med HSA-id. Anges om kopplingen är ordinationsbaserad. PDL 3:5§."


// ============================================================================
// LMALakemedelsoverlamnande – MedicationDispense
// Lager: enhetslager
// ============================================================================
Profile: LMALakemedelsoverlamnande
Parent: MedicationDispense
Id: LMALakemedelsoverlamnande
Title: "LMA Läkemedelsöverlämnande"
Description: """Automatens överlämning av läkemedel vid schemalagd tidpunkt.
Lager: enhetslager.

Automaten **överlämnar** – den administrerar inte. Klassen benämns
Läkemedelsöverlämnande för att skilja automatens handling från apotekets
dosförpackande (dosdispensering). Se ANMÄRKNING i standardens avsnitt 6.4.7.

**Lageruppdelning av felkoder:**
- `statusReason` (felkod) tillhör **enhetslagret**: mekaniskt-fel, produkt-slut, sensorfel.
- Dessa koder ska **inte** förekomma i `MedicationAdministration.statusReason`
  (omvårdnadslagret)."""

// Planerad tid – via dosageInstruction.timing.event
// (MedicationDispense.dosageInstruction[0].timing.event[0])
* dosageInstruction 1..* MS
* dosageInstruction.timing MS
* dosageInstruction.timing.event 1..* MS
* dosageInstruction.timing.event ^short = "Planerad tidpunkt för överlämning (SHALL)"
* dosageInstruction.timing.event ^comment = """SHALL anges med minst en planerad överlämnandetidpunkt.
`whenHandedOver` representerar faktisk tidpunkt; planerad tidpunkt anges i
`dosageInstruction.timing.event`. I FHIR R5 tydliggörs strukturen som Dosage.timing.event."""

// Medicinidentitet – krävs av basklass
* medication[x] MS
* medication[x] ^short = "Läkemedel (referens till Dospåse/Medication eller kod)"

// Status – enhetslager
* status 1..1 MS
* status ^short = "Utfäll (enhetslager)"
* status ^comment = """Rapporteras av automaten. Konceptmappning: completed=lyckad, declined=misslyckad, unknown=okänt. Se LMA-koder i CodeSystem/lma-overlamningstfall."""

// Felkod – enhetslager, Preferred
* statusReason[x] MS
* statusReason[x] only CodeableConcept
* statusReason[x] from VS-Overlamninsfelkod (preferred)
* statusReason[x] ^short = "Felkod (enhetslager) – VS-Overlamninsfelkod Preferred"
* statusReason[x] ^comment = """SHOULD anges när status = misslyckad.
Tillhör **enhetslagret**: mekaniskt-fel | produkt-slut | sensorfel | okänt.
Blanda INTE med omvårdnadslager-orsaker (MedicationAdministration.statusReason).

OBS (FHIR R5-notering): `statusReason[x]` bennmns `notPerformedReason` i FHIR R5
för MedicationDispense. Attributet **saknas** i basresursen MedicationAdministration
i både R4 och R5 – där anges orsaken via `statusReason` som är av typen
CodeableConcept[0..*] utan reference-alternativ."""

// Brukare
* subject 1..1 MS
* subject only Reference(LMABrukare)
* subject ^short = "Brukare"

// Automat – performer
* performer 1..* MS
* performer ^short = "Automat som genomförde överlämningen"
* performer.actor 1..1 MS
* performer.actor only Reference(LMAAutomat)
* performer.actor ^short = "Reference(LMAAutomat)"

// Ordination – valfri referens
* authorizingPrescription MS
* authorizingPrescription ^short = "Bakomliggande ordination (valfri)"
* authorizingPrescription ^comment = "MAY referera till MedicationRequest. LMA-system behöver inte ha kännedom om ordinationen."

// Faktisk tidpunkt
* whenHandedOver MS
* whenHandedOver ^short = "Faktisk tidpunkt för överlämning"
* whenHandedOver ^comment = "SHOULD anges om överlämning genomfördes (status=lyckad)."

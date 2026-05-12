// ============================================================================
// LMAKoppling – DeviceAssociation (FHIR R5)
// Lager: enhetslager
// ============================================================================
Profile: LMAKoppling
Parent: DeviceAssociation
Id: LMAKoppling
Title: "LMA Koppling"
Description: """Kopplingen brukare–automat. Representerar det administrativa
beslutet att en brukare betjänas av en specifik automat under en tidsavgränsad
period. Lager: enhetslager.

I FHIR R5 realiseras kopplingen med `DeviceAssociation` som ersatt
`DeviceUseStatement` från R4. Period och utförarinformation hanteras
direkt på resursen. Konceptmappning av status: active→attached, completed→explanted."""

// Status
* status 1..1 MS
* status ^short = "Kopplingsstatus"
* status ^comment = """Använd koderna från deviceassociation-status (R5).
Konceptmappning från R4 device-statement-status: active→attached, completed→explanted."""

// Brukare
* subject 1..1 MS
* subject only Reference(LMABrukare)
* subject ^short = "Brukare (Reference LMABrukare)"

// Giltighetstid
* period 1..1 MS
* period ^short = "Giltighetstid (giltigFrån / giltigTill)"
* period ^comment = """`period.start` = giltigFrån (1..1, obligatorisk).
`period.end` = giltigTill (0..1). Null indikerar aktiv koppling.
PDL 3 kap. kräver att kopplingens giltighetstid kan återges."""
* period.start 1..1 MS
* period.end MS

// Automat
* device 1..1 MS
* device only Reference(LMAAutomat)
* device ^short = "Automat (Reference LMAAutomat)"

// Ansvarig förskrivare – via operation.operator (R5 DeviceAssociation)
* operation MS
* operation.status MS
* operation.operator MS
* operation.operator only Reference(Practitioner)
* operation.operator ^short = "Ansvarig förskrivare (HSA-id)"
* operation.operator ^comment = "Reference(Practitioner) med HSA-id. Anges om kopplingen är ordinationsbaserad. PDL 3:5§."


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
- `notPerformedReason` (felkod) tillhör **enhetslagret**: mekaniskt-fel, produkt-slut, sensorfel.
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
`dosageInstruction.timing.event` (Dosage.timing.event i R5)."""

// Medicinidentitet – CodeableReference i R5
* medication MS
* medication ^short = "Läkemedel (referens till Dospåse/Medication eller kod)"

// Status – enhetslager
* status 1..1 MS
* status ^short = "Utfäll (enhetslager)"
* status ^comment = """Rapporteras av automaten. Konceptmappning: completed=lyckad, declined=misslyckad, unknown=okänt. Se LMA-koder i CodeSystem/lma-overlamningstfall."""

// Felkod – enhetslager, Preferred (notPerformedReason ersätter statusReason[x] i R5)
* notPerformedReason MS
* notPerformedReason.concept from VS-Overlamninsfelkod (preferred)
* notPerformedReason ^short = "Felkod (enhetslager) – VS-Overlamninsfelkod Preferred"
* notPerformedReason ^comment = """SHOULD anges när status = misslyckad.
Tillhör **enhetslagret**: mekaniskt-fel | produkt-slut | sensorfel | okänt.
Blanda INTE med omvårdnadslager-orsaker (MedicationAdministration.statusReason).
`notPerformedReason` (CodeableReference) ersätter `statusReason[x]` från R4."""

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

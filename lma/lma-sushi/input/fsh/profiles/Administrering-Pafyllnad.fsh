// ============================================================================
// LMALakemedelsadministrering – MedicationAdministration
// Lager: omvårdnadslager
// ============================================================================
Profile: LMALakemedelsadministrering
Parent: MedicationAdministration
Id: LMALakemedelsadministrering
Title: "LMA Läkemedelsadministrering"
Description: """Dokumentation av att behörig hälso- och sjukvårdspersonal
administrerade läkemedlet till brukaren (tillförsel till kroppen).
Lager: omvårdnadslager.

Varje post är ett **oföränderligt event** (immutable event). Korrektioner
hanteras via ny post med `partOf`-referens till ursprungsposten.

**Lageruppdelning av orsakskoder:**
Kodurval `VS-Administreringsorsak` tillhör **omvårdnadslagret** och innehåller
enbart omvårdnadsbedömda orsaker: brukare-avböjde, brukare-ej-anträffad,
medicinsk-orsak. Tekniska felkoder från automaten (enhetslager) ingår **inte**
– dessa representeras i `LMALakemedelsoverlamnande.statusReason`."""

// Medicinidentitet – krävs av basklass
* medication[x] MS
* medication[x] ^short = "Läkemedel"

// Status – omvårdnadslager
* status 1..1 MS
* status ^short = "Administreringsstatus (omvårdnadslager)"
* status ^comment = """Tillhör **omvårdnadslagret**. Konceptmappning: completed=genomförd, not-done=ej-genomförd, stopped=avbruten, unknown=okänt."""

// Orsak – omvårdnadslager, Preferred
* statusReason MS
* statusReason from VS-Administreringsorsak (preferred)
* statusReason ^short = "Administreringsorsak (omvårdnadslager) – VS-Administreringsorsak Preferred"
* statusReason ^comment = """Tillhör **omvårdnadslagret**. Inkluderar enbart
omvårdnadsbedömda orsaker: brukare-avböjde | brukare-ej-anträffad | medicinsk-orsak.
Tekniska felkoder (enhetslagret) ingår EJ – se LMALakemedelsoverlamnande.statusReason."""

// Brukare
* subject 1..1 MS
* subject only Reference(LMABrukare)
* subject ^short = "Brukare (Reference LMABrukare)"

// Faktisk tidpunkt – HSLF-FS 2016:40
* effective[x] 1..1 MS
* effective[x] only dateTime
* effective[x] ^short = "Faktisk administreringstidpunkt (HSLF-FS 2016:40)"
* effective[x] ^comment = "SHALL anges. HSLF-FS 2016:40 kräver att administreringstidpunkt dokumenteras."

// Utförande personal – HSA-id obligatoriskt
* performer 1..* MS
* performer ^short = "Utförande personal (HSA-id)"
* performer.actor 1..1 MS
* performer.actor only Reference(Practitioner or PractitionerRole)
* performer.actor ^short = "Reference(Practitioner) med HSA-id"
* performer.actor ^comment = """SHALL vara Reference(Practitioner) med
identifier.system = urn:oid:1.2.752.129.2.1.4.1 (HSA-id). PDL 3:5§."""

// Ordination
* request MS
* request ^short = "Bakomliggande ordination (SHOULD)"
* request ^comment = "SHOULD referera till MedicationRequest. HSLF-FS 2016:40."

// Referens till överlämning
* partOf MS
* partOf only Reference(MedicationAdministration)
* partOf ^short = "Relaterad administrering (SHOULD)"
* partOf ^comment = """SHOULD referera till en annan MedicationAdministration (FHIR R4
begränsar MedicationAdministration.partOf till Reference(MedicationAdministration|Procedure)).
Kopplingen till LMALakemedelsoverlamnande (MedicationDispense) kan inte uttryckas
via partOf i R4 – se standardens avsnitt 6.4.7 för alternativa spårningsstrategier."""

// Metadata – oföränderlig post
* meta.lastUpdated MS
* meta.lastUpdated ^short = "Tidpunkt posten skapades (immutable event)"
* meta.lastUpdated ^comment = "Posten är oföränderlig. meta.lastUpdated sätts vid skapande och ändras inte. HSLF-FS 2016:40."


// ============================================================================
// LMAPafyllnad – SupplyDelivery
// Lager: enhetslager
// ============================================================================
Profile: LMAPafyllnad
Parent: SupplyDelivery
Id: LMAPafyllnad
Title: "LMA Påfyllnad"
Description: """Registrering av att dosrullen eller läkemedelsförrådet fyllts
på i en automat. Lager: enhetslager.

Batchnummer (LVFS 2012:14) ska anges för att möjliggöra spårbarhet vid
läkemedelsåterkallelse."""

// Status – alltid completed
* status 1..1 MS
* status = #completed
* status ^short = "Status (alltid completed)"

// Typ – läkemedelsförsörjning
* type MS
* type ^short = "Typ av leverans"

// Tidpunkt
* occurrence[x] 1..1 MS
* occurrence[x] only dateTime
* occurrence[x] ^short = "Tidpunkt för påfyllnad"
* occurrence[x] ^comment = "SHALL anges."

// Mängd
* suppliedItem MS
* suppliedItem ^short = "Påfyllt läkemedel"
* suppliedItem.quantity MS
* suppliedItem.quantity ^short = "Antal påfyllda doser"
* suppliedItem.quantity ^comment = "MAY anges. Quantity."
* suppliedItem.item[x] MS
* suppliedItem.item[x] ^short = "Läkemedelsidentitet (valfritt)"

// Automat – via destination (Location)
* destination 1..1 MS
* destination only Reference(Location)
* destination ^short = "Automat (via Reference(Location))"
* destination ^comment = """SHALL referera till Location vars
`managingEntity` är Reference(LMAAutomat). Eftersom SupplyDelivery.destination
är Reference(Location) och inte Reference(Device) realiseras automatreferensen
via Location. Se mappningstabell i standarden."""

// Utförare
* receiver 1..1 MS
* receiver only Reference(Practitioner or PractitionerRole)
* receiver ^short = "Utförare (HSA-id)"
* receiver ^comment = """SHALL vara Reference(Practitioner) med HSA-id.
PDL 3 kap. Den person som fysiskt fyllde på automaten."""

// Batchnummer – extension
* extension contains ext-lma-batch named batch 0..1 MS
* extension[batch] ^short = "Batchnummer (LVFS 2012:14)"
* extension[batch] ^comment = "SHOULD anges. Krävs för spårbarhet vid läkemedelsåterkallelse per LVFS 2012:14."

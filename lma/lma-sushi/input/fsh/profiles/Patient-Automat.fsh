// ============================================================================
// LMABrukare – Patient
// Lager: omvårdnadslager
// ============================================================================
Profile: LMABrukare
Parent: Patient
Id: LMABrukare
Title: "LMA Brukare"
Description: """Brukare med insatsen läkemedelsautomat inom socialtjänst och
kommunal hälso- och sjukvård. Lager: omvårdnadslager.

I PDL-kontext benämns samma person *patient*; FHIR-resursen Patient används
i båda sammanhangen. Ankarpunkten för alla personrelaterade händelseresurser."""

// Identifierare – slicad
* identifier 1..* MS
* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "system"
* identifier ^slicing.rules = #open
* identifier ^short = "Unik identifierare"
* identifier contains
    lmaId 1..1 MS and
    personnummer 0..1 MS

* identifier[lmaId] ^short = "LMA-systemets interna id"
* identifier[lmaId] ^definition = "Stabil, systemunik identifierare för brukaren i LMA-plattformen."
* identifier[lmaId].system 1..1
* identifier[lmaId].system = "https://sis.se/fhir/lma/id/brukare"
* identifier[lmaId].value 1..1 MS

* identifier[personnummer] ^short = "Personnummer (PDL 3:2§)"
* identifier[personnummer] ^comment = """SHOULD anges om tillgängligt.
Skyddas av PDL 3:2§ – tillgång kräver ändamålsbegränsad behörighet.
Se avsnitt 6.4.2 i standarden för GDPR art. 5.1.c."""
* identifier[personnummer].system 1..1
* identifier[personnummer].system = "http://electronichealth.se/id/personnummer"
* identifier[personnummer].value 1..1 MS

// Aktivstatus
* active 1..1 MS
* active ^short = "Aktiv insats"
* active ^definition = "true om brukaren har aktiv insats med läkemedelsautomat. false om insatsen är avslutad."

// Namn – tillåtet men ej obligatoriskt (dataminimering GDPR art. 5.1.c)
* name MS
* name ^short = "Namn (valfritt – GDPR art. 5.1.c)"
* name ^comment = "MAY anges. Dataminimeringsprincipen innebär att namn inte ska lagras om ID-referens räcker."

// Kontaktuppgifter
* telecom MS
* telecom ^short = "Kontaktuppgifter (valfritt)"

// Ansvarig enhet
* managingOrganization 1..1 MS
* managingOrganization only Reference(Organization)
* managingOrganization ^short = "Ansvarig enhet (HSA-id)"
* managingOrganization ^comment = """Reference till Organisation med
identifier.system = urn:oid:1.2.752.129.2.1.4.1 (HSA-katalogen).
PDL 1:3§ kräver att ansvarig enhet kan identifieras."""

// Metadata
* meta.lastUpdated 1..1 MS
* meta.lastUpdated ^short = "Tidpunkt för senaste förändring av brukarposten"
* meta.lastUpdated ^comment = "SHALL anges för att möjliggöra inkrementell hämtning. HSLF-FS 2016:40."


// ============================================================================
// LMAAutomat – Device
// Lager: enhetslager
// ============================================================================
Profile: LMAAutomat
Parent: Device
Id: LMAAutomat
Title: "LMA Automat"
Description: """Fysisk läkemedelsautomat registrerad som medicinteknisk produkt
(MDR 2017/745). Lager: enhetslager.

Attributen driftsstatus, anslutningsstatus och batteriNivå tillhör **enhetslagret**
men modelleras **inte** direkt på Device-resursen. De bör i stället antingen:
- hämtas i realtid via `DeviceMetric`-resursen
  (se https://hl7.org/fhir/R4/devicemetric.html), eller
- lagras som `Observation` om de mäts vid en viss frekvens eller händelse.

Se avsnitt 6.1 i standarden för principiell motivering (IHE SDPi/BICEPS)."""

// Identifierare – minst ett, globalt unikt system+värde
// System-URI väljs av implementeraren (inget specifikt system är förskrivet av detta IG).
// Enda kravet: värdet måste vara globalt unikt.
* identifier 1..* MS
* identifier ^short = "Unik identifierare för automaten"
* identifier ^comment = "SHALL innehålla minst en identifierare med system och value. Implementeraren väljer system-URI; kravet är att id:t är globalt unikt."
* identifier.system 1..1 MS
* identifier.value 1..1 MS

// Serienummer (MDR art. 27)
* serialNumber 1..1 MS
* serialNumber ^short = "Tillverkarens serienummer"
* serialNumber ^comment = "Primär fysisk identitet. Obligatoriskt per MDR art. 27."

// Tillverkare (MDR art. 10)
* manufacturer 1..1 MS
* manufacturer ^short = "Tillverkare (juridisk identitet)"
* manufacturer ^comment = "MDR art. 10."

// Modell
* modelNumber 1..1 MS
* modelNumber ^short = "Modellbeteckning"

// Firmwareversion
* version MS
* version ^short = "Firmwareversion (SemVer)"
* version ^comment = "SHOULD anges. Anges enligt SemVer (major.minor.patch). version.type SHOULD sättas till #firmware från http://terminology.hl7.org/CodeSystem/device-version-type."
* version.value 1..1 MS

// Installationsadress
* location MS
* location only Reference(Location)
* location ^short = "Installationsadress (Reference till Location)"
* location ^comment = "SHALL referera till Location med strukturerad adress för automatens placering."

// driftsstatus, anslutningsstatus, batteriNivå – modelleras ej på Device
// Dessa attribut hämtas i realtid via DeviceMetric-resursen
// (https://hl7.org/fhir/R4/devicemetric.html) eller lagras som Observation
// om de mäts vid en viss frekvens eller händelse. Se profildeskription ovan.

// Aktiv period
* statusReason MS
* statusReason ^short = "Statusorsak / period"

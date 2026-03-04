### Mappning till FHIR

Tabellerna nedan visar hur den logiska modellens klasser och attribut mappar till
FHIR R4-resurser och element. Konformitetsnivåer: **SHALL** (obligatorisk),
**SHOULD** (starkt rekommenderad), **MAY** (valfri).

Alla profiler utgår från canonical: `https://sis.se/fhir/lma/StructureDefinition/`

### Klassöversikt

| Logisk klass | FHIR R4-resurs | Profil | Lager |
|--------------|----------------|--------|-------|
| Brukare | `Patient` | [LMABrukare](StructureDefinition-LMABrukare.html) | Omvårdnad |
| Automat | `Device` | [LMAAutomat](StructureDefinition-LMAAutomat.html) | Enhet |
| Koppling | `DeviceUseStatement` | [LMAKoppling](StructureDefinition-LMAKoppling.html) | Enhet |
| Läkemedelsordination | `MedicationRequest` | *(ej profilerad v0.1)* | Omvårdnad |
| Dospåse | `Medication` | *(ej profilerad v0.1)* | Enhet |
| Läkemedelsöverlämnande | `MedicationDispense` | [LMALakemedelsoverlamnande](StructureDefinition-LMALakemedelsoverlamnande.html) | Enhet |
| Läkemedelsadministrering | `MedicationAdministration` | [LMALakemedelsadministrering](StructureDefinition-LMALakemedelsadministrering.html) | Omvårdnad |
| Påfyllnad | `SupplyDelivery` | [LMAPafyllnad](StructureDefinition-LMAPafyllnad.html) | Enhet |
| Åtkomstlogg | `AuditEvent` | *(ej profilerad v0.1)* | Tvärskär. |

### Brukare → Patient

| Logiskt attribut | Krav | FHIR-element | Kommentar |
|-----------------|------|--------------|-----------|
| `id` | SHALL | `Patient.identifier[lmaId]` | system = `https://sis.se/fhir/lma/id/brukare` |
| `personnummer` | SHOULD | `Patient.identifier[personnummer]` | system = `http://electronichealth.se/id/personnummer` — PDL 3:2§ |
| `namn` | MAY | `Patient.name.text` | Dataminimering GDPR art. 5.1.c |
| `ansvarigEnhet` | SHALL | `Patient.managingOrganization` | Reference(Organization) med HSA-id — PDL 1:3§ |
| `aktiv` | SHALL | `Patient.active` | boolean |
| `meta.senastAndrad` | SHALL | `Patient.meta.lastUpdated` | instant (UTC) — HSLF-FS 2016:40 |

### Automat → Device

| Logiskt attribut | Krav | FHIR-element | Kommentar |
|-----------------|------|--------------|-----------|
| `id` | SHALL | `Device.identifier[lmaId]` | Globalt unikt id – implementeraren väljer system-URI |
| `serieNr` | SHALL | `Device.serialNumber` | MDR art. 27 |
| `tillverkare` | SHALL | `Device.manufacturer` | MDR art. 10 |
| `modell` | SHALL | `Device.modelNumber` | |
| `firmwareVersion` | SHOULD | `Device.version.value` | version.type = firmware |
| `installationsAdress` | SHALL | `Device.location` | Reference(Location) |
| `driftsstatus` | SHALL | `DeviceMetric` / `Observation` | Hämtas i realtid via [DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html) eller lagras som `Observation` vid mätning |
| `anslutningsstatus` | SHOULD | `DeviceMetric` / `Observation` | Hämtas i realtid via DeviceMetric eller lagras som `Observation` |
| `batteriNivå` | MAY | `DeviceMetric` / `Observation` | Quantity i % — via DeviceMetric (realtid) eller `Observation` (från mätning) |

### Läkemedelsöverlämnande → MedicationDispense

| Logiskt attribut | Krav | FHIR-element | Kommentar |
|-----------------|------|--------------|-----------|
| `tidPlanerad` | SHALL | `MedicationDispense.dosageInstruction.timing.event` | dateTime — planerad tidpunkt; `whenHandedOver` är faktisk tidpunkt |
| `utfall` | SHALL | `MedicationDispense.status` | VS-Overlamningstfall Required — **enhetslager** |
| `felkod` | MAY | `MedicationDispense.statusReason[x]` | VS-Overlamninsfelkod Preferred — **enhetslager**; kallas `notPerformedReason` i FHIR R5 (saknas i MedicationAdministration) |
| `brukare` | SHALL | `MedicationDispense.subject` | Reference(LMABrukare) |
| `automat` | SHALL | `MedicationDispense.performer.actor` | Reference(LMAAutomat) |
| `ordination` | MAY | `MedicationDispense.authorizingPrescription` | Reference(MedicationRequest) |
| `tidFaktisk` | SHOULD | `MedicationDispense.whenHandedOver` | dateTime |

### Läkemedelsadministrering → MedicationAdministration

| Logiskt attribut | Krav | FHIR-element | Kommentar |
|-----------------|------|--------------|-----------|
| `status` | SHALL | `MedicationAdministration.status` | VS-Administreringsstatus Required — **omvårdnadslager** |
| `orsak` | MAY | `MedicationAdministration.statusReason` | VS-Administreringsorsak Preferred — **omvårdnadslager**, ej tekniska fel |
| `brukare` | SHALL | `MedicationAdministration.subject` | Reference(LMABrukare) |
| `tidFaktisk` | SHALL | `MedicationAdministration.effective[x]` | effectiveDateTime — HSLF-FS 2016:40 |
| `utförare` | SHALL | `MedicationAdministration.performer.actor` | Reference(Practitioner) med HSA-id — PDL 3:5§ |
| `ordination` | SHOULD | `MedicationAdministration.request` | HSLF-FS 2016:40 |
| `läkemedelsöverlämnande` | SHOULD | `MedicationAdministration.partOf` | Reference(MedicationAdministration) — FHIR R4 begränsar partOf till MedicationAdministration\|Procedure |

### Påfyllnad → SupplyDelivery

| Logiskt attribut | Krav | FHIR-element | Kommentar |
|-----------------|------|--------------|-----------|
| `tid` | SHALL | `SupplyDelivery.occurrence[x]` | occurrenceDateTime |
| `automat` | SHALL | `SupplyDelivery.destination` | Reference(Location) kopplad till LMAAutomat |
| `batch` | SHOULD | `SupplyDelivery.extension[batch]` | Extension string — LVFS 2012:14 |
| `antalEnheter` | MAY | `SupplyDelivery.suppliedItem.quantity` | Quantity |
| `utförare` | SHALL | `SupplyDelivery.receiver` | Reference(Practitioner) med HSA-id |

### Spårbarhet – Provenance och AuditEvent

Krav på Provenance och AuditEvent specificeras i standardens kapitel 8. Profilering
avses mot IHE ATNA i en kommande version av IG:n.

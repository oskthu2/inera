### Profilöversikt

Denna version definierar sex FHIR-profiler, tre extensions, sju CodeSystems och sju
ValueSets. Alla kodurval har explicit lagerindikation – se [Mappning till FHIR](mappings.html)
för fulla elementmappningar och bindningar.

### Profiler

| Profil | Basresurs | Lager |
|--------|-----------|-------|
| [LMABrukare](StructureDefinition-LMABrukare.html) | `Patient` | Omvårdnad |
| [LMAAutomat](StructureDefinition-LMAAutomat.html) | `Device` | Enhet |
| [LMAKoppling](StructureDefinition-LMAKoppling.html) | `DeviceUseStatement` | Enhet |
| [LMALakemedelsoverlamnande](StructureDefinition-LMALakemedelsoverlamnande.html) | `MedicationDispense` | Enhet |
| [LMALakemedelsadministrering](StructureDefinition-LMALakemedelsadministrering.html) | `MedicationAdministration` | Omvårdnad |
| [LMAPafyllnad](StructureDefinition-LMAPafyllnad.html) | `SupplyDelivery` | Enhet |

### Extensions

| Extension | Resurs | Syfte |
|-----------|--------|-------|
| [ext-lma-batch](StructureDefinition-ext-lma-batch.html) | `SupplyDelivery` | Batchnummer LVFS 2012:14 |

### Ej profilerade klasser i v0.1

| Klass | Planerad FHIR-resurs | Skäl |
|-------|---------------------|-------|
| Läkemedelsordination | `MedicationRequest` | LMA-system behöver inte ha kännedom om ordinationen |
| Dospåse | `Medication` | Valfri referens; apotekets ansvar |
| Åtkomstlogg | `AuditEvent` | Profileras separat mot IHE ATNA |
| Larm, Påminnelse, Bekräftelse | `DeviceAlert`, `Task` | Option – larmutdelningslager |

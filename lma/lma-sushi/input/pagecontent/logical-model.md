### Lagermodell och klasser

Informationsmodellen definieras i standardens kapitel 6. Denna sida beskriver
hur den avspeglas i IG:ns FHIR-profiler och hur lagerindelningen påverkar
implementeringen.

### Informationsmodell

Klasser med profilerade FHIR-resurser är klickbara och länkar till respektive profil.
Klasser markerade med *«option»* tillhör utökat scope och är ej profilerade i v0.1.

![LMA Informationsmodell](LMA_klassdiagram.svg){: style="max-width:100%"}

### Lagerindelning

| Lager | FHIR-profiler i denna IG | Lager |
|-------|--------------------------|-------|
| **Enhetslager** | LMAAutomat, LMAKoppling, LMALakemedelsoverlamnande, LMAPafyllnad | Enhet |
| **Omvårdnadslager** | LMABrukare, LMALakemedelsadministrering | Omvårdnad |
| **Larmutdelning** *(option)* | *(ej profilerad i v0.1)* | – |

> **Normativt krav:** Kodurval är strikt knutna till lager. Se [Profilöversikt](profiles.html)
> för bindningar och [Mappning till FHIR](mappings.html) för fulla elementmappningar.

### Klassbeskrivningar

Semantiken för varje klass definieras i standardens kapitel 6. Nedanstående
beskriver enbart de FHIR-tekniska valen.

| Logisk klass | FHIR R4-resurs | FHIR-anmärkning |
|--------------|----------------|-----------------|
| Brukare | [`Patient` → LMABrukare](StructureDefinition-LMABrukare.html) | Ankarpunkt för alla personrelaterade resurser |
| Automat | [`Device` → LMAAutomat](StructureDefinition-LMAAutomat.html) | Medicinteknisk produkt per MDR 2017/745 |
| Koppling | [`DeviceUseStatement` → LMAKoppling](StructureDefinition-LMAKoppling.html) | Migreras till `DeviceAssociation` i R5/R6 |
| Läkemedelsöverlämnande | [`MedicationDispense` → LMALakemedelsoverlamnande](StructureDefinition-LMALakemedelsoverlamnande.html) | Enhetslager – inte omvårdnadsdokumentation |
| Läkemedelsadministrering | [`MedicationAdministration` → LMALakemedelsadministrering](StructureDefinition-LMALakemedelsadministrering.html) | Omvårdnadslager – immutable event |
| Påfyllnad | [`SupplyDelivery` → LMAPafyllnad](StructureDefinition-LMAPafyllnad.html) | Batchnummer via extension (LVFS 2012:14) |

### Relationsöversikt

| Från | Relation | Till | Kardinalitet |
|------|----------|------|-------------|
| Koppling | brukare | Brukare | 1 → 1 |
| Koppling | automat | Automat | 1 → 1 |
| Läkemedelsöverlämnande | brukare | Brukare | 0..* → 1 |
| Läkemedelsöverlämnande | automat | Automat | 0..* → 1 |
| Läkemedelsadministrering | brukare | Brukare | 0..* → 1 |
| Påfyllnad | automat | Automat | 0..* → 1 |

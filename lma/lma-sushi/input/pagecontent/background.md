### Bakgrund och syfte

Läkemedelsautomater saknar idag ett gemensamt API-kontrakt, vilket gör integration med
kommunala vård- och omsorgssystem kostsam vid varje upphandling. SIS/TR-standarden och
denna IG adresserar detta genom en gemensam informationsmodell realiserad i HL7 FHIR R4.

### Regelverk

Nedanstående regelverk utgör den normativa grunden för standardens informationsmodell.
Respektive krav redovisas utförligt i standarden.

| Regelverk | Relevans för FHIR-implementeringen |
|-----------|-------------------------------------|
| Patientdatalagen (PDL 2008:355) | Brukaridentifierare, ändamålsbegränsning, åtkomstloggning |
| HSLF-FS 2016:40 | Krav på administreringstidpunkt, utförare och signaturdokumentation |
| MDR 2017/745 | Serienummer och spårbarhet för Device |
| LVFS 2012:14 | Batchnummer på SupplyDelivery |
| GDPR art. 5 | Dataminimering – namn är MAY på Patient |

### Arkitekturprinciper

Informationsmodellen delar upp klasser och kodurval i lager enligt principerna i
IHE SDPi/BICEPS (se standardens kapitel 4). Uppdelningen är normativ i denna IG:
ett lagers kodurval ska **inte** användas i ett annat lagers resurs. Se
[Mappning till FHIR](mappings.html) för konkreta konsekvenser.

Terminologin används med precision enligt standardens kapitel 3. Automaten
**överlämnar** – den administrerar inte.

### Aktörer

| Aktör | FHIR-roll | Exempel |
|-------|-----------|---------|
| LMA-plattform | Server / Resource Provider | Systemleverantörens backend |
| Kommunalt vård- och omsorgssystem | Client / Resource Consumer | Procapita, TES, Pulsen Combine |
| Tillsynsaktör | Client / Audit Consumer | IVO, kommunens MAS |
| Apotek / dosaktör | Client / Writer (påfyllnadstransaktion) | Apotekssystem |

### Relation till andra standarder

| Standard | Relation |
|----------|----------|
| IHE SDPi / BICEPS (ISO/IEEE 11073) | Lagermodellens principiella grund |
| IHE ACMQ | Referens för larmutdelning (option, ej profilerad i v0.1) |
| IHE PCC QEDm | Sökparametrar för MedicationAdministration/MedicationDispense |
| IHE ATNA | Referens för AuditEvent-struktur |
| SMART Backend Services | Rekommenderat auktoriseringsmönster (system-to-system) |

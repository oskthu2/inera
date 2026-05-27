## Resursorienterad FHIR-åtkomst för EHDS Patient Summary

### Bakgrund

EURIDICE EU Health Data API definierar två komplementära åtkomstmönster för EHDS Patient Summary:

| Mönster | Beskrivning | FHIR-artefakt |
|---|---|---|
| **Document access** | En komplett, självständig Bundle (type=document) hämtas från ett enda endpoint | `IneraEHDSPatientSummaryBundle` |
| **Resource access** | Konsumenten ställer separata FHIR-queries per resurstyp mot ett standard REST API | `IneraEHDSPSServerEURIDICECore` / `IneraEHDSPSServerXtEHRFull` |

Båda mönstren ska täcka **samma informationsmängd** enligt Xt-EHR EHDS Patient Summary (A.1.1–A.1.16). Valet av mönster påverkar inte vad som behöver lagras – det påverkar hur och i vilka steg informationen hämtas.

> **OBS om EEHRxF:** Den formella European Electronic Health Record exchange Format (EEHRxF) är ännu inte beslutad inom EHDS-förordningen. Denna specifikation baseras på **Xt-EHR EHDS Patient Summary R1** och **EURIDICE EU Health Data API-specifikationen** som bästa tillgängliga underlag. Profiler och API-krav kan behöva justeras när EEHRxF beslutas.

---

### Varför resursorientering kräver egna API-krav

I document access räcker det att servern kan producera en Bundle – all logik för urval och sammansättning sitter på servern. I resource access måste servern istället:

1. **Exponera varje resurstyp separat** med sökparametrar
2. **Svara korrekt på filtrering** – t.ex. `status=active`, `category=laboratory`, `clinical-status=active`
3. **Tillhandahålla ett CapabilityStatement** som deklarerar vad den stödjer
4. **Stödja paginering** och `_lastUpdated` för delta-synkronisering

Detta ställer tydligare och mer operativa krav på en FHIR-server än document access. Det är också det mönster som är mest relevant för integration mot befintliga journalsystem som exponerar data via API, t.ex. Inera FHIR Core, Cambio Open Services, eller en RIVTA-till-FHIR-brygga.

---

### Sektionsmatris: Xt-EHR logisk modell → FHIR-resurser → API-queries

| Sektion (svenska) | EHDS-term | Xt-EHR | Källa | FHIR-resurs | Primär query | Nyckelfilter |
|---|---|---|---|---|---|---|
| Patientidentitet | EHDSPatient | A.1.1 | EURIDICE + Xt-EHR | `Patient` | `GET /Patient?identifier={id}` | `identifier`, `birthdate` |
| Demografisk info / språk | EHDSPatient | A.1.2 | Xt-EHR-only | `Patient` (extended) | (ingår i Patient-resursen) | `communication` |
| Patientansvarig/husläkare | EHDSHealthProfessional | A.1.3 | Xt-EHR-only | `PractitionerRole` + `Practitioner` | `GET /PractitionerRole?practitioner={id}` | `practitioner`, `organization`, `specialty` |
| Legalt ombud / kontaktperson | EHDSRelatedPerson | A.1.4 | Xt-EHR-only | `RelatedPerson` | `GET /RelatedPerson?patient={id}` | `patient`, `relationship` |
| Försäkring / betalning | EHDSInsurance | A.1.5 | Xt-EHR-only | `Coverage` | `GET /Coverage?patient={id}&status=active` | `patient`, `status` |
| Läkemedelsbehandling | EHDSMedicationStatement | A.1.7 | EURIDICE + Xt-EHR | `MedicationStatement` | `GET /MedicationStatement?patient={id}&status=active` | `patient`, `status`, `medication` |
| Överkänslighet | EHDSAllergyIntolerance | A.1.8 | EURIDICE + Xt-EHR | `AllergyIntolerance` | `GET /AllergyIntolerance?patient={id}&clinical-status=active` | `patient`, `clinical-status`, `code` |
| Diagnos/problem (aktiv) | EHDSCondition | A.1.9 | EURIDICE + Xt-EHR | `Condition` | `GET /Condition?patient={id}&category=problem-list-item` | `patient`, `category`, `clinical-status` |
| Historiska sjukdomar | EHDSCondition | A.1.9 / LOINC 11348-0 | Xt-EHR-only | `Condition` | `GET /Condition?patient={id}&clinical-status=resolved` | `patient`, `clinical-status` |
| Medicinska varningar | EHDSAlert | – | EURIDICE + Xt-EHR | `Flag` | `GET /Flag?patient={id}&status=active` | `patient`, `status`, `category` |
| Åtgärder | EHDSProcedure | A.1.10 | EURIDICE + Xt-EHR | `Procedure` | `GET /Procedure?patient={id}` | `patient`, `status`, `code`, `date` |
| Vaccinationer/immuniseringar | EHDSImmunization | A.1.11 | EURIDICE + Xt-EHR | `Immunization` | `GET /Immunization?patient={id}&status=completed` | `patient`, `status`, `vaccine-code` |
| Användning av medicinteknisk produkt | EHDSDeviceUse | A.1.12 | EURIDICE + Xt-EHR | `DeviceUseStatement`¹ | `GET /DeviceUseStatement?patient={id}&status=active` | `patient`, `status` |
| Medicinteknisk produkt | EHDSDevice | A.1.12 | EURIDICE + Xt-EHR | `Device` | `GET /Device?identifier={udi-di}` (via `_include` från DeviceUseStatement) | `identifier`, `type` |
| Diagnostiska resultat (lab) | EHDSObservation | A.1.13 | EURIDICE + Xt-EHR | `Observation` | `GET /Observation?patient={id}&category=laboratory` | `patient`, `category`, `code`, `date` |
| Vitala parametrar | EHDSObservation | A.1.13 | EURIDICE + Xt-EHR | `Observation` | `GET /Observation?patient={id}&category=vital-signs` | `patient`, `category`, `code` |
| Strukturerade rapporter | EHDSDiagnosticReport | A.1.13 | Xt-EHR-only | `DiagnosticReport` | `GET /DiagnosticReport?patient={id}&category=laboratory` | `patient`, `category`, `date` |
| Funktionsstatus | EHDSObservation | A.1.14 | Xt-EHR-only | `Observation` | `GET /Observation?patient={id}&category=functional-status` | `patient`, `category` |
| Social anamnes (rökning/alkohol) | EHDSObservation | A.1.15 | Xt-EHR-only | `Observation` | `GET /Observation?patient={id}&category=social-history` | `patient`, `category`, `code` |
| Graviditetshistorik | EHDSObservation | A.1.16 | Xt-EHR-only | `Observation` / `Condition` | `GET /Observation?patient={id}&code=82810-3` | `patient`, `code` |
| Föranmälda direktiv | EHDSAdvanceDirective | EHDS PS body | Xt-EHR-only | `Consent` | `GET /Consent?patient={id}&status=active` | `patient`, `status`, `category` |
| Vårdplan | EHDSCarePlan | EHDS PS body | Xt-EHR-only | `CarePlan` | `GET /CarePlan?patient={id}&status=active` | `patient`, `status`, `date` |

**Källkodning:** `EURIDICE + Xt-EHR` = krävs i båda specifikationerna och ingår i `IneraEHDSPSServerEURIDICECore`. `Xt-EHR-only` = ingår endast i `IneraEHDSPSServerXtEHRFull` och saknar EURIDICE-ekvivalent.

De två CapabilityStatements i detta IG speglar denna uppdelning:
- [`IneraEHDSPSServerEURIDICECore`](CapabilityStatement-inera-ehds-ps-server-euridice-core.html) – minimum för cross-border resource access (10 resurser)
- [`IneraEHDSPSServerXtEHRFull`](CapabilityStatement-inera-ehds-ps-server-xtehr-full.html) – komplett Xt-EHR PS scope (17 resurser)

¹ *FHIR R4: `DeviceUseStatement`; FHIR R4B/R5: `DeviceUsage`. Val av FHIR-version påverkar resursnamn.*

---

### Detaljerade krav per resurstyp

#### Patient (SHALL – Xt-EHR A.1.1)

**Stödda interaktioner:** `read`, `search-type`

**Obligatoriska sökparametrar:**
- `identifier` (token) – personnummer (OID `1.2.752.129.2.1.3.1`) och/eller EU-patientidentifierare
- `birthdate` (date) – kompletterande demografisk matchning

**Dataelement som måste finnas (se `IneraEHDSPatientSummaryPatient`):**
- `identifier 1..*` med system + value
- `name` per `eu-pat-1`-invariant (family/given/text eller data-absent-reason)
- `gender 1..1` och `birthDate 1..1`

---

#### MedicationStatement – Läkemedelsbehandling (SHALL – Xt-EHR A.1.7, EHDSMedicationStatement)

**Stödda interaktioner:** `read`, `search-type`

**Obligatoriska sökparametrar:**
- `patient` (reference) – **alltid krävd**
- `status` (token) – `active | completed | stopped | on-hold`

**Rekommenderade sökparametrar:**
- `medication` (token) – NPL-id (nationellt), ATC-SE (`http://www.whocc.no/atc`) eller SNOMED CT-kod
- `effective` (date) – filter på behandlingsperiod

**Semantisk anmärkning:** EHDS PS avser *aktuell läkemedelsbehandling* (`status=active`). Termen "läkemedelsbehandling" (EHDSMedicationStatement) är korrekt EHDS-terminologi per eHälsomyndighetens gap-analys. `MedicationStatement` skiljer sig konceptuellt från `MedicationRequest` (aktiv förskrivning) och `MedicationDispense` (faktisk expediering). Nationell källa: Nationella läkemedelslistan (Pascal) via RIVTA-tjänstkontraktet GetMedicationHistory. NPÖ/Pascal bygger på expedierade recept – tolkning som "aktuell behandling" kräver statuscheckning.

---

#### AllergyIntolerance – Överkänslighet (SHALL – Xt-EHR A.1.8, EHDSAllergyIntolerance)

**Stödda interaktioner:** `read`, `search-type`

**Obligatoriska sökparametrar:**
- `patient` (reference)
- `clinical-status` (token) – `active | resolved | inactive`

**Rekommenderade sökparametrar:**
- `code` (token) – allergensubstans (SNOMED CT, Socialstyrelsens allergenregister, ATC)
- `criticality` (token) – `high | low | unable-to-assess`

**Semantisk anmärkning:** Termen "överkänslighet" (EHDSAllergyIntolerance) är korrekt EHDS-terminologi per eHälsomyndighetens gap-analys. Täcker allergier och överkänsligheter mot substanser. Nationell källa: UMI överkänslighetsdelen via NPÖ:s GetAlertInformation. Medicinska varningar som INTE är överkänslighet (t.ex. smittskyddsvarning, implantatvarning) täcks av `Flag`-resursen (EHDSAlert) – se separat avsnitt nedan.

---

#### Condition – Diagnos/problem (SHALL – Xt-EHR A.1.9, EHDSCondition)

**Stödda interaktioner:** `read`, `search-type`

**Obligatoriska sökparametrar:**
- `patient` (reference)
- `category` (token) – `problem-list-item` för aktiv problemlista; `encounter-diagnosis` för episoddiagnoser

**Rekommenderade sökparametrar:**
- `clinical-status` (token) – `active | resolved | inactive | recurrence`
- `code` (token) – ICD-10-SE (`http://hl7.org/fhir/sid/icd-10`) eller SNOMED CT

**Semantisk anmärkning:** Termen "diagnos/problem" (EHDSCondition) är korrekt EHDS-terminologi per eHälsomyndighetens gap-analys. Avgörande filtreringsbehov är `category=problem-list-item` (långtidsdiagnoser) vs `encounter-diagnosis` (kontaktdiagnoser). Xt-EHR A.1.9 avser primärt aktiv problemlista; historiska sjukdomar är en separat Xt-EHR-only sektion (LOINC 11348-0). Nationell källa: GetDiagnoses via RIVTA/NPÖ. Primärt kodverk: ICD-10-SE (nationell standard); SNOMED CT är EU-rekommenderat.

---

#### Procedure – Åtgärder (SHOULD – Xt-EHR A.1.10, EHDSProcedure)

**Stödda interaktioner:** `read`, `search-type`

**Rekommenderade sökparametrar:**
- `patient` (reference)
- `status` (token) – `completed | in-progress | stopped`
- `code` (token) – KVÅ (primärt nationellt), SNOMED CT eller NordDRG
- `date` (date) – filter på `performed[x]`

**Semantisk anmärkning:** Termen "åtgärder" (EHDSProcedure) är korrekt EHDS-terminologi per eHälsomyndighetens gap-analys. Inget dedikerat RIVTA-tjänstekontrakt för åtgärder idag. Viss täckning finns via GetActivities (kliniska aktiviteter) och i kliniska dokument via GetClinicalDocuments. KVÅ (Klassifikation av vårdåtgärder) är det svenska primära kodverket för åtgärder – saknar direkt mappning till SNOMED-procedurer. NKOO (Nationellt kliniskt orsaksregister) innehåller behandlingsorsaker men inte åtgärdskoder.

---

#### Immunization (SHOULD – Xt-EHR A.1.11)

**Stödda interaktioner:** `read`, `search-type`

**Rekommenderade sökparametrar:**
- `patient` (reference)
- `status` (token) – `completed | not-done`
- `vaccine-code` (token) – ATC-SE vaccinationskod eller SNOMED CT
- `date` (date)

**Semantisk anmärkning:** Nationella vaccinationsregistret (NVR) är auktoritativ källa. NVR exponerar idag inte ett direkt FHIR-API mot kliniska system eller mot Inera-plattformen. Integration kräver antingen en brygglösning mot NVR:s befintliga API eller att data replikeras till journalsystemet.

---

#### DeviceUseStatement – Användning av medicinteknisk produkt (SHOULD – Xt-EHR A.1.12, EHDSDeviceUse)

**Stödda interaktioner:** `read`, `search-type`

**Rekommenderade sökparametrar:**
- `patient` (reference)
- `status` (token) – `active | completed | entered-in-error`

**Semantisk anmärkning:** Termen "användning av medicinteknisk produkt" (EHDSDeviceUse) är korrekt EHDS-terminologi. Beskriver ATT en patient använder/har implanterat en produkt (pacemaker, stent, hörapparat, protes etc.). Refererar till `Device`-resursen (EHDSDevice) för produktdetaljer med UDI-identifierare per EU MDR 2017/745. Saknar idag nationellt register och standardiserat tjänstekontrakt i Sverige. Uppgifter dokumenteras i journalsystem (Cambio, TakeCare, NCS Cross, Cosmic) men utan harmoniserat flöde. Detta är ett **strukturellt gap** mot EHDS PS-krav i nuläget.

#### Device – Medicinteknisk produkt (SHOULD – Xt-EHR A.1.12, EHDSDevice)

**Stödda interaktioner:** `read`, `search-type`

**Rekommenderade sökparametrar:**
- `identifier` (token) – UDI-DI (Device Identifier per EU MDR)
- `type` (token) – produkttyp (SNOMED CT eller ISO/IEEE 11073)

**Semantisk anmärkning:** Termen "medicinteknisk produkt" (EHDSDevice) beskriver PRODUKTEN i sig, med UDI-identifierare (UDI-DI = modellidentifierare; UDI-PI = produktinstans inkl. serienummer, lotnummer, tillverkningsdatum, utgångsdatum). Separeras tydligt från EHDSDeviceUse (användningen). UDI är obligatoriskt per EU MDR 2017/745 för produkter CE-märkta efter 26 maj 2021. Söks normalt via `_include=DeviceUseStatement:device` från en DeviceUseStatement-query snarare än via direkt sökning.

---

#### Observation (SHOULD – Xt-EHR A.1.13, A.1.14, A.1.15)

**Stödda interaktioner:** `read`, `search-type`

**Obligatoriska sökparametrar:**
- `patient` (reference)
- `category` (token) – **kritisk** för att separera informationstyper:

| `category`-värde | Innehåll | Xt-EHR | RIVTA-motsvarighet |
|---|---|---|---|
| `laboratory` | Laboratorieresultat | A.1.13 | GetLaboratoryOrderOutcome (Labportalen) |
| `vital-signs` | Vitala parametrar (temp, puls, BT, SpO2) | A.1.13 | Saknas nationellt standardiserat flöde |
| `functional-status` | Funktionsbedömning (ADL, kognitiv status) | A.1.14 | Delvis i KVÅ-åtgärder, ej standardiserat |
| `social-history` | Rökning (LOINC 72166-2), alkohol (74013-4) | A.1.15 | Saknas standardiserat flöde |

**Rekommenderade sökparametrar:**
- `code` (token) – LOINC-observationskod
- `date` (date)
- `status` (token) – `final | preliminary | amended`

---

#### Flag – Medicinska varningar (SHOULD – EHDSAlert)

**Stödda interaktioner:** `read`, `search-type`

**Obligatoriska sökparametrar:**
- `patient` (reference)
- `status` (token) – `active | inactive | entered-in-error`

**Rekommenderade sökparametrar:**
- `category` (token) – typ av varning (SNOMED CT eller lokalt kodverk)

**Semantisk anmärkning:** Medicinska varningar (EHDSAlert) är en **separat informationsmängd** från överkänslighet (EHDSAllergyIntolerance) per eHälsomyndighetens gap-analys (Dnr 2024/04403, oktober 2025). Täcker kliniska varningar som inte är allergi/överkänslighet – t.ex. säkerhetsvarningar (implantat och MRI-kontraindikation), smittskyddsvarningar, kritiska riskfaktorer. Nationell källa: UMI varningsdelen via NPÖ:s GetAlertInformation (exklusive överkänslighetsdelen som täcks av AllergyIntolerance). Sektionskod i Composition: LOINC 75310-3 (provisorisk; avvaktar Xt-EHR final code binding).

---

#### Xt-EHR-only resurser (ej i EURIDICE Core)

Dessa resurser ingår i Xt-EHR EHDS PS logisk modell men saknar direkt ekvivalent i EURIDICE resource access pattern.

**PractitionerRole + Practitioner (SHOULD – Xt-EHR header)**
- GP / preferred healthcare professional
- Kopplar Practitioner (HSA-id) till Organisation och specialitet
- Söks via `PractitionerRole?practitioner={id}` eller via `Composition.author`-referens
- Nationellt gap: HSA-katalogen innehåller data men exponeras via SOAP-tjänster, inte FHIR

**RelatedPerson (SHOULD – Xt-EHR header)**
- Legal guardian, nödkontakt, auktoriserad representant
- Söks via `RelatedPerson?patient={id}&relationship={kod}`
- Nationellt gap: registreras i journalsystem, inget standardiserat flöde

**Coverage (SHOULD – Xt-EHR header)**
- Försäkring och betalningsinformation (bl.a. Europeiskt sjukförsäkringskort/EHIC)
- Söks via `Coverage?patient={id}&status=active`
- Nationellt gap: Försäkringskassan är källa, saknar FHIR-API mot kliniska system

**DiagnosticReport (SHOULD – Xt-EHR A.1.13 komplement)**
- Strukturerade diagnostiska rapporter (labpaket, röntgensvar) med ingående Observations
- Komplement till enskilda Observation-resurser; ger sammanhang och rapportenhet
- Söks via `DiagnosticReport?patient={id}&category=laboratory&date={range}`
- Nationellt gap: laboratoriesystem (Labportalen) exponerar svar som rapporter, FHIR-stöd varierar

**Consent (MAY – Xt-EHR advance directives)**
- Föranmälda direktiv: DNR-beslut, behandlingsavstående, informerat samtycke
- LOINC-sektionskod 42348-3 i Composition
- Söks via `Consent?patient={id}&status=active&category={direktiv-typ}`
- Nationellt gap: ingen nationell tjänst, registreras lokalt i journalsystem

**CarePlan (MAY – Xt-EHR plan of care)**
- Planerade åtgärder, uppföljningar och behandlingsmål
- LOINC-sektionskod 18776-5 i Composition
- Söks via `CarePlan?patient={id}&status=active`
- Nationellt gap: ingen nationell tjänst, hanteras i respektive journalsystem

---

### Gemensamma serverkrav (alla resurser)

| Krav | Motivering |
|---|---|
| **CapabilityStatement** | Servern måste exponera `/metadata` med deklarerade resurser och sökparametrar |
| **SMART on FHIR** | OAuth2/OIDC med `patient/<Resource>.read` och `system/<Resource>.read` scope |
| **Nationell patientidentifierare** | OID `1.2.752.129.2.1.3.1` i `Patient.identifier.system` |
| **Paginering** | `Bundle.link[next/previous]` för stora svarsvolymer (lab-svar, Observation) |
| **`_lastUpdated`** | Stöds på alla kliniska resurser för delta-synkronisering (EURIDICE-krav) |
| **`_include` / `_revinclude`** | Bör stödjas för att hämta relaterade resurser i ett anrop (t.ex. Medication vid MedicationStatement) |
| **OperationOutcome** | Standardiserade felsvar med FHIR-felkoder |
| **JSON** | Obligatoriskt; XML är valfritt |

---

### Gap-analysunderlag

Tabellen nedan är tänkt att fyllas i vid analys av specifika system. Status-kolumnerna föreslår bedömningsnivåerna: ✅ Fullt stöd / ⚠️ Partiellt stöd / ❌ Saknas / ? Oklart.

#### Funktionellt API-stöd

| EHDS PS-krav (svenska) | EHDS-term | Xt-EHR | Källa | Inera FHIR Core | Cambio Open Services | RIVTA-tjänstekontrakt / nationell källa |
|---|---|---|---|---|---|---|
| Patient READ + search by identifier | EHDSPatient | A.1.1 | EURIDICE + Xt-EHR | ? | ? | NPÖ GetPatient |
| Läkemedelsbehandling search (patient+status) | EHDSMedicationStatement | A.1.7 | EURIDICE + Xt-EHR | ? | ? | GetMedicationHistory (Pascal/Nationella läkemedelslistan); kodverk: NPL-id, ATC-SE, VARA |
| Överkänslighet search (patient+clinical-status) | EHDSAllergyIntolerance | A.1.8 | EURIDICE + Xt-EHR | ? | ? | NPÖ GetAlertInformation (överkänslighetsdelen); UMI |
| Medicinska varningar search (patient+status) | EHDSAlert | – | EURIDICE + Xt-EHR | ? | ? | NPÖ GetAlertInformation (varningsdelen, exkl. överkänslighet); UMI |
| Diagnos/problem search (patient+category+clinical-status) | EHDSCondition | A.1.9 | EURIDICE + Xt-EHR | ? | ? | NPÖ GetDiagnoses; kodverk: ICD-10-SE |
| Åtgärder search (patient+date) | EHDSProcedure | A.1.10 | EURIDICE + Xt-EHR | ? | ? | ❌ direkt; ⚠️ GetActivities (KVÅ via journalsystem) |
| Vaccinationer search (patient+vaccine-code) | EHDSImmunization | A.1.11 | EURIDICE + Xt-EHR | ? | ? | ❌ (NVR, eget API, ej RIVTA) |
| Användning av medicinteknisk produkt search (patient+status) | EHDSDeviceUse | A.1.12 | EURIDICE + Xt-EHR | ? | ? | ❌ (inget nationellt register) |
| Medicinteknisk produkt search / _include | EHDSDevice | A.1.12 | EURIDICE + Xt-EHR | ? | ? | ❌ (inget nationellt register; UDI per EU MDR) |
| Diagnostiska resultat lab (patient+category=laboratory) | EHDSObservation | A.1.13 | EURIDICE + Xt-EHR | ? | ? | GetLaboratoryOrderOutcome (Labportalen) |
| Diagnostiska resultat vital-signs (patient+category=vital-signs) | EHDSObservation | A.1.13 | EURIDICE + Xt-EHR | ? | ? | ❌ (inget standardiserat nationellt flöde) |
| Funktionsstatus (patient+category=functional-status) | EHDSObservation | A.1.14 | Xt-EHR-only | ? | ? | ❌ (delvis i KVÅ, ej standardiserat) |
| Social anamnes (patient+category=social-history) | EHDSObservation | A.1.15 | Xt-EHR-only | ? | ? | ❌ |
| Patientansvarig/husläkare (practitioner) | EHDSHealthProfessional | A.1.3 | Xt-EHR-only | ? | ? | ❌ (HSA-katalog, SOAP-tjänster) |
| Legalt ombud / kontaktperson (patient+relationship) | EHDSRelatedPerson | A.1.4 | Xt-EHR-only | ? | ? | ❌ |
| Försäkring / betalning (patient+status) | EHDSInsurance | A.1.5 | Xt-EHR-only | ? | ? | ❌ (Försäkringskassan, eget API) |
| Strukturerade rapporter (patient+category) | EHDSDiagnosticReport | A.1.13 | Xt-EHR-only | ? | ? | ⚠️ (Labportalen, FHIR-stöd varierar) |
| Föranmälda direktiv (patient+status+category) | EHDSAdvanceDirective | EHDS PS body | Xt-EHR-only | ? | ? | ❌ |
| Vårdplan (patient+status) | EHDSCarePlan | EHDS PS body | Xt-EHR-only | ? | ? | ❌ |

#### Semantisk täckning

| Semantiskt krav | EHDS-term | Inera FHIR Core | Cambio Open Services | RIVTA idag |
|---|---|---|---|---|
| `Patient.identifier` med personnummer OID | EHDSPatient | ? | ? | ✅ |
| `MedicationStatement.medication` med NPL-id/ATC-SE | EHDSMedicationStatement | ? | ? | ⚠️ (VARA-artikel, ATC-SE) |
| `Condition.code` med ICD-10-SE | EHDSCondition | ? | ? | ✅ (ICD-10-SE) |
| `AllergyIntolerance.code` med SNOMED CT | EHDSAllergyIntolerance | ? | ? | ⚠️ (lokala koder/fritext) |
| `Flag.code` för medicinska varningar | EHDSAlert | ? | ? | ⚠️ (UMI, lokala koder) |
| `Observation.code` med LOINC | EHDSObservation | ? | ? | ⚠️ (varierar per lab) |
| `Procedure.code` med KVÅ | EHDSProcedure | ? | ? | ⚠️ (via journaldokument) |
| `Immunization.vaccineCode` med ATC-SE | EHDSImmunization | ? | ? | ❌ (NVR, eget API) |
| `DeviceUseStatement.device` → `Device` med UDI-DI | EHDSDeviceUse/EHDSDevice | ? | ? | ❌ |

#### Infrastruktur

| Infrastrukturkrav | Inera FHIR Core | Cambio Open Services | RIVTA idag |
|---|---|---|---|
| CapabilityStatement (`/metadata`) | ? | ? | ❌ (WSDL, inte FHIR) |
| SMART on FHIR | ? | ? | ❌ (SAML/Sithscertifikat) |
| `_lastUpdated` på kliniska resurser | ? | ? | ❌ |
| `_include` / `_revinclude` | ? | ? | ❌ |
| FHIR paginering | ? | ? | ❌ |
| `$patient-everything` | ? | ? | ❌ |

---

### Förhållandet till HL7 IPS

Xt-EHR EHDS PS och HL7 International Patient Summary (IPS 1.1.0) delar sektionsstruktur men skiljer sig i:

- **IPS** är ett profilbibliotek primärt designat för dokumentbundlar
- **Xt-EHR** lägger explicit till resursorienterat API-mönster (EURIDICE)
- **EHDS** tillför rättighetsreglering (NCP, patientens rätt att hämta summary cross-border)
- **EEHRxF** (kommande) kommer att formalisera vilka av ovanstående som blir bindande krav

Denna IG harmoniserar mot alla tre men profilerar mot FHIR R4 (inte R4B/R5) för kompatibilitet med befintliga svenska implementationer.

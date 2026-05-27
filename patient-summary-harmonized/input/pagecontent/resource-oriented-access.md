## Resursorienterad FHIR-åtkomst för EHDS Patient Summary

### Bakgrund

EURIDICE EU Health Data API definierar två komplementära åtkomstmönster för EHDS Patient Summary:

| Mönster | Beskrivning | FHIR-artefakt |
|---|---|---|
| **Document access** | En komplett, självständig Bundle (type=document) hämtas från ett enda endpoint | `IneraEHDSPatientSummaryBundle` |
| **Resource access** | Konsumenten ställer separata FHIR-queries per resurstyp mot ett standard REST API | `IneraEHDSPatientSummaryServerRequirements` |

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

### Sektionsmatris: Xt-EHR A.1.x → FHIR-resurser → API-queries

| Sektion | Xt-EHR | Krav | FHIR-resurs | Primär query | Nyckelfilter |
|---|---|---|---|---|---|
| Patientidentitet och demografi | A.1.1 | **SHALL** | `Patient` | `GET /Patient?identifier={id}` | `identifier`, `birthdate` |
| Läkemedelsöversikt | A.1.7 | **SHALL** | `MedicationStatement` | `GET /MedicationStatement?patient={id}&status=active` | `patient`, `status`, `medication` |
| Allergier och intoleranser | A.1.8 | **SHALL** | `AllergyIntolerance` | `GET /AllergyIntolerance?patient={id}&clinical-status=active` | `patient`, `clinical-status`, `code` |
| Problemlista / diagnoser | A.1.9 | **SHALL** | `Condition` | `GET /Condition?patient={id}&category=problem-list-item` | `patient`, `category`, `clinical-status`, `code` |
| Procedurhistorik | A.1.10 | SHOULD | `Procedure` | `GET /Procedure?patient={id}` | `patient`, `status`, `code`, `date` |
| Immuniseringar | A.1.11 | SHOULD | `Immunization` | `GET /Immunization?patient={id}&status=completed` | `patient`, `status`, `vaccine-code`, `date` |
| Medicintekniska produkter | A.1.12 | SHOULD | `DeviceUseStatement`¹ | `GET /DeviceUseStatement?patient={id}&status=active` | `patient`, `status` |
| Diagnostiska resultat (lab) | A.1.13 | SHOULD | `Observation` | `GET /Observation?patient={id}&category=laboratory` | `patient`, `category`, `code`, `date`, `status` |
| Vitala parametrar | A.1.13 | SHOULD | `Observation` | `GET /Observation?patient={id}&category=vital-signs` | `patient`, `category`, `code`, `date` |
| Funktionsstatus | A.1.14 | MAY | `Observation` | `GET /Observation?patient={id}&category=functional-status` | `patient`, `category` |
| Social anamnes | A.1.15 | MAY | `Observation` | `GET /Observation?patient={id}&category=social-history` | `patient`, `category`, `code` |
| Graviditetshistorik | A.1.16 | MAY | `Observation` / `Condition` | `GET /Observation?patient={id}&code=82810-3` | `patient`, `code` |

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

#### MedicationStatement (SHALL – Xt-EHR A.1.7)

**Stödda interaktioner:** `read`, `search-type`

**Obligatoriska sökparametrar:**
- `patient` (reference) – **alltid krävd**
- `status` (token) – `active | completed | stopped | on-hold`

**Rekommenderade sökparametrar:**
- `medication` (token) – ATC- (`http://www.whocc.no/atc`) eller SNOMED CT-kod
- `effective` (date) – filter på behandlingsperiod

**Semantisk anmärkning:** EHDS PS avser *aktuell läkemedelslista* (`status=active`). `MedicationStatement` skiljer sig konceptuellt från `MedicationRequest` (aktiv förskrivning) och `MedicationDispense` (faktisk expediering). Systemet måste besluta vilket av dessa som bäst återspeglar "aktuell läkemedelslista" i den nationella kontexten – NPÖ/Pascal bygger t.ex. på expedierade recept.

---

#### AllergyIntolerance (SHALL – Xt-EHR A.1.8)

**Stödda interaktioner:** `read`, `search-type`

**Obligatoriska sökparametrar:**
- `patient` (reference)
- `clinical-status` (token) – `active | resolved | inactive`

**Rekommenderade sökparametrar:**
- `code` (token) – allergensubstans
- `criticality` (token) – `high | low | unable-to-assess`

**Semantisk anmärkning:** NPÖ:s GetAlertInformation täcker både allergier och andra kliniska varningar. EHDS PS hanterar enbart `AllergyIntolerance`; varningar utan allergibakgrund (t.ex. smittskyddsvarning) faller utanför scopet.

---

#### Condition (SHALL – Xt-EHR A.1.9)

**Stödda interaktioner:** `read`, `search-type`

**Obligatoriska sökparametrar:**
- `patient` (reference)
- `category` (token) – `problem-list-item` för aktiv problemlista; `encounter-diagnosis` för episoddiagnoser

**Rekommenderade sökparametrar:**
- `clinical-status` (token) – `active | resolved | inactive | recurrence`
- `code` (token) – ICD-10-SE (`http://hl7.org/fhir/sid/icd-10`) eller SNOMED CT

**Semantisk anmärkning:** Avgörande filtreringsbehov är `category=problem-list-item` (långtidsdiagnoser) vs `encounter-diagnosis` (kontaktdiagnoser). Xt-EHR A.1.9 avser primärt problemlistan. ICD-10-SE som primärt kodverk är nationell standard; SNOMED CT är EU-rekommenderat.

---

#### Procedure (SHOULD – Xt-EHR A.1.10)

**Stödda interaktioner:** `read`, `search-type`

**Rekommenderade sökparametrar:**
- `patient` (reference)
- `status` (token) – `completed | in-progress | stopped`
- `code` (token) – KVÅ, SNOMED CT eller NordDRG
- `date` (date) – filter på `performed[x]`

**Semantisk anmärkning:** Inget dedikerat RIVTA-tjänstekontrakt för procedurer idag. Viss täckning finns via `GetClinicalDocuments` (operationsberättelser) och kontakttyper i `GetCareContacts`. KVÅ (Klassifikation av vårdåtgärder) är det svenska kodverket – saknar direkt mappning till SNOMED-procedurer.

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

#### DeviceUseStatement (SHOULD – Xt-EHR A.1.12)

**Stödda interaktioner:** `read`, `search-type`

**Rekommenderade sökparametrar:**
- `patient` (reference)
- `status` (token) – `active | completed | entered-in-error`

**Semantisk anmärkning:** Medicintekniska produkter och implantat (pacemaker, stent, hörapparater, proteser) saknar idag nationellt register och standardiserat tjänstekontrakt i Sverige. Uppgifter dokumenteras i journalsystem (Cambio, TakeCare, NCS Cross, Cosmic) men utan harmoniserat flöde. Detta är sannolikt det **största strukturella gapet** mot EHDS PS-krav i nuläget.

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

| EHDS PS-krav | Xt-EHR | Inera FHIR Core | Cambio Open Services | RIVTA-tjänstekontrakt |
|---|---|---|---|---|
| Patient READ + search by identifier | A.1.1 | ? | ? | GetPatient / NPÖ |
| MedicationStatement search (patient+status) | A.1.7 | ? | ? | GetMedicationHistory (Pascal) |
| AllergyIntolerance search (patient+clinical-status) | A.1.8 | ? | ? | GetAlertInformation (NPÖ) |
| Condition search (patient+category+clinical-status) | A.1.9 | ? | ? | GetDiagnoses (NPÖ) |
| Procedure search (patient+date) | A.1.10 | ? | ? | ❌ (partiellt via GetCareContacts) |
| Immunization search (patient+vaccine-code) | A.1.11 | ? | ? | ❌ (NVR, ej RIVTA) |
| DeviceUseStatement search (patient+status) | A.1.12 | ? | ? | ❌ |
| Observation lab (patient+category=laboratory) | A.1.13 | ? | ? | GetLaboratoryOrderOutcome |
| Observation vital-signs (patient+category=vital-signs) | A.1.13 | ? | ? | ❌ |
| Observation social-history | A.1.15 | ? | ? | ❌ |

#### Semantisk täckning

| Semantiskt krav | Inera FHIR Core | Cambio Open Services | RIVTA idag |
|---|---|---|---|
| `Patient.identifier` med personnummer OID | ? | ? | ✅ |
| `MedicationStatement.medication` med ATC-kod | ? | ? | ⚠️ (VARA-artikel) |
| `Condition.code` med ICD-10-SE | ? | ? | ✅ (ICD-10-SE) |
| `AllergyIntolerance.code` med SNOMED CT | ? | ? | ⚠️ (lokala koder) |
| `Observation.code` med LOINC | ? | ? | ⚠️ (varierar per lab) |
| `Procedure.code` med KVÅ | ? | ? | ⚠️ (via dokument) |
| `Immunization.vaccineCode` med ATC-SE | ? | ? | ❌ (NVR, eget API) |

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

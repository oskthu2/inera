# Valideringsrapport: Core IG concept maps och profiler

**Datum:** 2026-05-12  
**Underlag:** TKB clinicalprocess:healthcond:description v3.0.5, TKB clinicalprocess:logistics:logistics  
**Granskade filer:** conceptmap-getdiagnosis.fsh, conceptmap-getcarecontacts.fsh, conditionBaseInera.fsh, profiles-base.fsh  
**Terminologireferens:** mappningsarkitektur.md (EHDS-brygga)

---

## Sammanfattning

| Fil | Kritiska fel | Varningar | Terminologikorrigeringar |
|-----|-------------|-----------|--------------------------|
| conceptmap-getdiagnosis.fsh | 4 | 2 | 1 |
| conceptmap-getcarecontacts.fsh | 0 | 1 | 0 |
| conditionBaseInera.fsh | 1 | 3 | 1 |
| profiles-base.fsh | 1 | 2 | 2 |

---

## 1. conceptmap-getdiagnosis.fsh

### Kritiska fel

**CM-01: Felaktigt källfältnamn `diagnosisType` (ska vara `typeOfDiagnosis`)**

Concept mapen anger source-koden `#diagnosis.diagnosisBody.diagnosisType` men den FSH-genererade logiska modellen från TKB anger elementet som `diagnosis.diagnosisBody.typeOfDiagnosis`. Namnen måste överensstämma med den genererade modellen.

```
// FEL:
* group[1].element[0].code = #diagnosis.diagnosisBody.diagnosisType

// RÄTT:
* group[1].element[0].code = #diagnosis.diagnosisBody.typeOfDiagnosis
```

**CM-02: Fabricerade källfält som inte finns i TKB — borttagna helt**

Concept mapen innehöll mappningar för fält som inte existerar i TKB GetDiagnosis (varken i XSD eller FSH-modell):
- `#diagnosis.diagnosisBody.diagnosisStatus`
- `#diagnosis.diagnosisBody.verificationStatus`
- `#diagnosis.diagnosisBody.diagnosisSeverity`
- `#diagnosis.diagnosisBody.bodyStructure`
- `#diagnosis.diagnosisBody.nullified`
- `#diagnosis.diagnosisBody.nullifiedReason`

Dessa är FHIR Condition-attribut projicerade bakåt på TKB-modellen. En ConceptMap vars källa är TKB får inte innehålla källkoder som saknar TKB-förankring — det ger en falsk bild av vad tjänstekontraktet levererar. **Åtgärd: borttagna helt** från den korrigerade filen.

**CM-03: Fel ICD-10-SE URI i kommentar**

Concept mapen kommenterar ICD-10-SE med `http://hl7.org/fhir/sid/icd-10` men rätt URI (per terminologitjänsten och NamingSystem-tabellen i mappningsarkitektur.md) är:

```
https://terminologitjansten.inera.se/inera-kodverksforvaltning/kodverk/icd-10-se
```

**CM-04: Saknar explicita kodöversättningar för DiagnosisTypeCS**

Group 1 mappar `typeOfDiagnosis → category` med equivalence `#wider` men innehåller inga konkreta kodöversättningar. DiagnosisTypeCS har koderna `#Huvuddiagnos` och `#Bidiagnos`. Båda ska mappas till `#encounter-diagnosis` i `http://terminology.hl7.org/CodeSystem/condition-category` (per mappningsarkitektur.md `diagnos-typ-to-condition-category`).

### Varningar

**CM-05: Saknar mappning för `chronicDiagnosis`**

TKB-elementet `diagnosis.diagnosisBody.chronicDiagnosis` (boolean, 0..1) har ingen mappning i concept mapen. Föreslaget FHIR-uttryck: extension eller `Condition.modifierExtension`. Lägg till i unmapped-gruppen med kommentar om alternativ.

**CM-06: Saknar mappning för `relatedDiagnosis`**

TKB-elementet `diagnosis.diagnosisBody.relatedDiagnosis` (0..*) saknar mappning. Föreslaget FHIR-uttryck: `Condition.extension` med Reference till relaterad Condition. Lägg till i unmapped-gruppen.

---

## 2. conceptmap-getcarecontacts.fsh

### Varningar

**CC-01: EncounterTypeVS i profilen matchar inte terminologitjänstens URI**

Concept mapen anger korrekt URI för KV Vårdkontakttyp i kommentaren:
```
https://terminologitjansten.inera.se/inera-kodverksforvaltning/kodverk/kv_vardkontakttyp
```
Men `EncounterTypeVS` i profiles-base.fsh/conditionBaseInera.fsh definieras med `http://terminology.hl7.org/CodeSystem/encounter-type` (placeholder). Concept mapen är korrekt — profilen behöver korrigeras (se profil-fel PB-02 nedan).

---

## 3. conditionBaseInera.fsh

### Kritiska fel

**CB-01: Dubblerat `code.coding contains`-uttryck (FSH-syntaxfel)**

```fsh
// FEL — två separata contains-uttryck:
* code.coding contains icd10se 1..1 MS
* code.coding[icd10se].system = ...
* code.coding contains snomedct 0..1 MS    // ← andra contains-rad

// RÄTT — slå ihop till ett enda contains-uttryck:
* code.coding contains icd10se 1..1 MS and snomedct 0..1 MS
```

### Varningar

**CB-02: `code.coding[icd10se] 1..1` kan vara för strikt**

TKB:s `diagnosisCode` är `0..1`. Profilen kräver 1..1 ICD-10-SE-kod. Detta är rimligt för *ConditionDiagnosisInera* (ej för ConditionBaseInera), men bör dokumenteras explicit med en länk till TKB:s kardinalitet.

**CB-03: `encounter 1..1 MS` saknar motivering mot TKB**

TKB har `careContactId` som `0..1` i `diagnosisHeader`. Att tvinga fram `encounter 1..1` innebär att en diagnos alltid kräver en kopplad encounter — det kan bryta mot historiska diagnoser utan vårdkontakt. Överväg `0..1`.

**CB-04: Ingen modellering av `chronicDiagnosis`**

TKB-elementet `chronicDiagnosis` (boolean, 0..1) saknas helt. Lägg till en extension i ConditionDiagnosisInera:

```fsh
Extension: ExtChronicDiagnosis
Id: ext-chronic-diagnosis
Title: "Kronisk diagnos"
Description: "Anger om diagnosen är kronisk per TKB GetDiagnosis diagnosisBody.chronicDiagnosis."
* value[x] only boolean
```

### Terminologikorrigeringar

**CB-T01: `EncounterTypeVS` ska peka på KV Vårdkontakttyp**

```fsh
// FEL:
* include codes from system http://terminology.hl7.org/CodeSystem/encounter-type

// RÄTT:
* include codes from system https://terminologitjansten.inera.se/inera-kodverksforvaltning/kodverk/kv_vardkontakttyp
```

OID: `1.2.752.129.2.2.2.25`

---

## 4. profiles-base.fsh

### Kritiska fel

**PB-01: ProvenanceBaseInera saknar `legalAuthenticator`-slice**

TKB:s `diagnosisHeader.legalAuthenticator` (signerande person) är ett viktigt element som saknar representation i profilen. Lägg till:

```fsh
* agent contains legalAuthenticator 0..1 MS
* agent[legalAuthenticator].type.coding.system = "http://terminology.hl7.org/CodeSystem/provenance-participant-type"
* agent[legalAuthenticator].type.coding.code = #verifier
* agent[legalAuthenticator].who only Reference(PractitionerBaseInera)
* agent[legalAuthenticator].who ^short = "Signerande person (legalAuthenticator)"
```

### Varningar

**PB-02: `PractitionerQualificationVS` är placeholder (v2-0360)**

Pekar på HL7 v2-0360 istället för KV Befattning. Ska uppdateras när terminologitjänsten exponerar KV Befattning.

**PB-03: `EncounterTypeVS` är placeholder**

Se CB-T01 ovan — samma problem, ska peka på terminologitjänstens KV Vårdkontakttyp-URI.

### Terminologikorrigeringar

**PB-T01: `PractitionerQualificationVS` ska inkludera KV Befattning**

```fsh
// FEL:
* include codes from system http://terminology.hl7.org/CodeSystem/v2-0360

// RÄTT (när terminologitjänsten tillhandahåller kodverket):
* include codes from system https://terminologitjansten.inera.se/inera-kodverksforvaltning/kodverk/kv_befattning
```

OID: `1.2.752.129.2.2.1.4`

**PB-T02: `EncounterTypeVS` ska peka på KV Vårdkontakttyp**

Samma korrigering som CB-T01.

---

## 5. Sammanställning: terminologi-URIer som behöver åtgärdas

| Kodverk | OID | Aktuell URI (fel) | Korrekt URI (terminologitjänsten) |
|---------|-----|-------------------|-----------------------------------|
| ICD-10-SE | 1.2.752.116.1.1.1.1.3 | `http://hl7.org/fhir/sid/icd-10` (i CM-kommentar) | `https://terminologitjansten.inera.se/inera-kodverksforvaltning/kodverk/icd-10-se` |
| KV Befattning | 1.2.752.129.2.2.1.4 | `http://terminology.hl7.org/CodeSystem/v2-0360` | `https://terminologitjansten.inera.se/inera-kodverksforvaltning/kodverk/kv_befattning` |
| KV Vårdkontakttyp | 1.2.752.129.2.2.2.25 | `http://terminology.hl7.org/CodeSystem/encounter-type` | `https://terminologitjansten.inera.se/inera-kodverksforvaltning/kodverk/kv_vardkontakttyp` |

Notera: ICD-10-SE i profilen (`conditionBaseInera.fsh` ICD10SECS CodeSystem) har **korrekt** URI (`https://terminologitjansten.inera.se/...`). Felet gäller enbart conceptmap-kommentaren.

---

## 6. Prioritering

| Prioritet | Referens | Åtgärd |
|-----------|----------|--------|
| P1 – Blockerande | CM-01 | Fixa fältnamn `diagnosisType` → `typeOfDiagnosis` |
| P1 – Blockerande | CB-01 | Fixa dubbelt FSH `contains`-uttryck |
| P1 – Blockerande | CM-02 | Fabricerade källfält borttagna helt |
| P2 – Viktig | CM-04 | Lägg till kodöversättningar Huvuddiagnos/Bidiagnos → encounter-diagnosis |
| P2 – Viktig | PB-01 | Lägg till legalAuthenticator-slice i ProvenanceBaseInera |
| P2 – Viktig | CB-04 | Modellera chronicDiagnosis som extension |
| P3 – Terminologi | CM-03, CB-T01, PB-T01, PB-T02 | Korrigera terminologi-URIer |
| P4 – Förbättring | CM-05, CM-06 | Lägg till relatedDiagnosis och chronicDiagnosis i unmapped |

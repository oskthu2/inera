// ============================================================================
// KORRIGERAD: conditionBaseInera.fsh
// Korrigeringar: CB-01, CB-02 (dokumenterad), CB-03, CB-04, CB-T01
// ============================================================================

// ============================================================================
// Extension: Kronisk diagnos (CB-04)
// TKB: diagnosis.diagnosisBody.chronicDiagnosis (boolean, 0..1)
// ============================================================================
Extension: ExtChronicDiagnosis
Id: ext-chronic-diagnosis
Title: "Kronisk diagnos"
Description: "Anger om diagnosen är kronisk. Källa: TKB GetDiagnosis diagnosisBody.chronicDiagnosis (boolean, 0..1)."
Context: Condition
* value[x] only boolean


// ============================================================================
// ConditionBaseInera — oförändrad (basprofilens kardinaliteter är korrekta)
// ============================================================================
Profile: ConditionBaseInera
Parent: Condition
Id: condition-base-inera
Title: "Condition Base Inera"
Description: """
Swedish national base profile for Condition resource.
Foundation for all condition/problem/diagnosis resources in Swedish healthcare.
"""

* ^version = "0.2.0"
* ^status = #draft
* ^experimental = true
* ^date = "2025-11-24"
* ^publisher = "Inera AB"

* identifier MS
* clinicalStatus 1..1 MS
* clinicalStatus from http://hl7.org/fhir/ValueSet/condition-clinical (required)
* verificationStatus MS
* verificationStatus from http://hl7.org/fhir/ValueSet/condition-ver-status (required)
* category MS
* category from ConditionCategoryVS (extensible)
* severity MS
* severity from http://hl7.org/fhir/ValueSet/condition-severity (preferred)
* code 1..1 MS
* code from ConditionCodeVS (extensible)
* code.coding MS
* code.coding ^slicing.discriminator.type = #value
* code.coding ^slicing.discriminator.path = "system"
* code.coding ^slicing.rules = #open
* code.text MS
* bodySite MS
* subject 1..1 MS
* subject only Reference(PatientBaseInera)
* encounter MS
* encounter only Reference(EncounterBaseInera)
* onset[x] MS
* abatement[x] MS
* recordedDate MS
* recorder MS
* recorder only Reference(PractitionerBaseInera or PractitionerRoleBaseInera or PatientBaseInera or RelatedPerson)
* asserter MS
* asserter only Reference(PractitionerBaseInera or PractitionerRoleBaseInera or PatientBaseInera or RelatedPerson)
* stage MS
* evidence MS
* note MS


// ============================================================================
// ConditionDiagnosisInera — korrigerad
// ============================================================================
Profile: ConditionDiagnosisInera
Parent: ConditionBaseInera
Id: condition-diagnosis-inera
Title: "Condition Diagnosis Inera"
Description: """
Swedish profile för diagnoser hämtade från GetDiagnosis TKB-tjänst.

**Mappning från TKB GetDiagnosis v2.0/v3.0:**
- diagnosisBody.diagnosisCode → code.coding (ICD-10-SE, 0..1 i TKB)
- diagnosisBody.typeOfDiagnosis → category (Huvuddiagnos/Bidiagnos → encounter-diagnosis)
- diagnosisBody.diagnosisTime → onsetDateTime
- diagnosisBody.chronicDiagnosis → extension[ext-chronic-diagnosis]
- diagnosisHeader.careContactId → encounter (0..1, se CB-03)
- accountableHealthcareProfessional → recorder + Provenance
"""

* ^version = "0.2.0"
* ^status = #draft
* ^experimental = true
* ^date = "2025-11-24"
* ^publisher = "Inera AB"

* identifier 1..* MS

// [CB-04] Kronisk diagnos-extension
* extension contains ExtChronicDiagnosis named chronicDiagnosis 0..1 MS
* extension[chronicDiagnosis] ^short = "Kronisk diagnos (TKB diagnosisBody.chronicDiagnosis)"

// Diagnoskategori — alltid encounter-diagnosis för GetDiagnosis
* category 1..* MS
* category ^slicing.discriminator.type = #value
* category ^slicing.discriminator.path = "coding.code"
* category ^slicing.rules = #open
* category contains diagnosisCategory 1..1 MS
* category[diagnosisCategory].coding.system = "http://terminology.hl7.org/CodeSystem/condition-category"
* category[diagnosisCategory].coding.code = #encounter-diagnosis

// Diagnoskod — ICD-10-SE primär, SNOMED CT sekundär
// [CB-01 FIXAD] Ett enda contains-uttryck med båda slices
* code.coding contains
    icd10se 0..1 MS and
    snomedct 0..1 MS

// [CB-02 dokumenterad] icd10se är 0..1 (ej 1..1) eftersom TKB diagnosisCode är 0..1
// Implementationer som alltid har diagnoskod kan skärpa till 1..1 i sin profilinärittning.
* code.coding[icd10se].system = "https://terminologitjansten.inera.se/inera-kodverksforvaltning/kodverk/icd-10-se" (exactly)
* code.coding[icd10se].code 1..1
* code.coding[icd10se].display MS
* code.coding[icd10se] ^short = "ICD-10-SE diagnoskod"
* code.coding[icd10se] ^comment = "OID 1.2.752.116.1.1.1.1.3 → URI via NamingSystem (lager 2a). TKB: diagnosisCode (0..1)."

* code.coding[snomedct].system = "http://snomed.info/sct" (exactly)
* code.coding[snomedct].code 1..1
* code.coding[snomedct].display MS
* code.coding[snomedct] ^short = "SNOMED CT (kompletterande)"

* code.text 1..1 MS
* code.text ^short = "Diagnosbenämning i klartext (diagnosisCode.displayName / originalText)"

// [CB-03 FIXAD] encounter 0..1 — TKB careContactId är 0..1
* encounter 0..1 MS
* encounter ^short = "Relaterad vårdkontakt (careContactId, 0..1)"
* encounter ^comment = "SHOULD anges om careContactId finns i diagnosisHeader. Sätts ej för historiska diagnoser utan känd vårdkontakt."

* onset[x] MS
* onsetDateTime 0..1 MS
* onsetDateTime ^short = "Diagnostidpunkt (diagnosisBody.diagnosisTime)"
* onsetPeriod 0..1 MS

* recordedDate 1..1 MS
* recordedDate ^short = "Registreringstidpunkt (accountableHealthcareProfessional.authorTime)"

* recorder 1..1 MS
* recorder only Reference(PractitionerBaseInera or PractitionerRoleBaseInera)
* recorder ^short = "Ansvarig hälso- och sjukvårdsperson"


// ============================================================================
// EncounterBaseInera — korrigerad EncounterTypeVS (CB-T01)
// ============================================================================
Profile: EncounterBaseInera
Parent: Encounter
Id: encounter-base-inera
Title: "Encounter Base Inera"
Description: """
Swedish national base profile for Encounter resource.
Mappar GetCareContacts TKB-tjänst för vårdkontakter.

**TKB-källa**: GetCareContacts v2.0/v3.0 (clinicalprocess:logistics:logistics).
"""

* ^version = "0.2.0"
* ^status = #draft
* ^experimental = true
* ^date = "2025-11-24"
* ^publisher = "Inera AB"

* identifier MS
* status 1..1 MS
* class 1..1 MS
* class from EncounterClassVS (extensible)
* type MS
* type ^short = "Vårdkontakttyp (KV Vårdkontakttyp)"
* type ^definition = "Typ av vårdkontakt per KV Vårdkontakttyp (OID 1.2.752.129.2.2.2.25). TKB: careContactBody.careContactCode (1..1)."
// [CB-T01 FIXAD] Terminologitjänstens URI för KV Vårdkontakttyp
* type from EncounterTypeVS (extensible)
* serviceType MS
* priority MS
* subject 1..1 MS
* subject only Reference(PatientBaseInera)
* participant MS
* participant.individual only Reference(PractitionerBaseInera or PractitionerRoleBaseInera or RelatedPerson)
* period MS
* period.start 1..1 MS
* reasonCode MS
* reasonReference MS
* diagnosis MS
* diagnosis.condition only Reference(ConditionBaseInera or ConditionDiagnosisInera or Procedure)
* hospitalization MS
* location MS
* location.location only Reference(Location)
* serviceProvider MS
* serviceProvider only Reference(OrganizationBaseInera)


// ============================================================================
// VALUE SETS OCH KODSYSTEM
// ============================================================================

ValueSet: ConditionCategoryVS
Id: condition-category-vs
Title: "Condition Category ValueSet"
Description: "Kategorier för tillstånd/diagnoser."
* ^version = "0.2.0"
* ^status = #draft
* ^experimental = true
* include codes from system http://terminology.hl7.org/CodeSystem/condition-category


ValueSet: ConditionCodeVS
Id: condition-code-vs
Title: "Condition Code ValueSet"
Description: "Koder för diagnoser — ICD-10-SE och SNOMED CT SE."
* ^version = "0.2.0"
* ^status = #draft
* ^experimental = true
* include codes from system ICD10SECS
* include codes from system http://snomed.info/sct


CodeSystem: ICD10SECS
Id: icd-10-se-cs
Title: "ICD-10-SE CodeSystem"
Description: "Svensk version av ICD-10. Innehållet hämtas från terminologitjänsten."
* ^url = "https://terminologitjansten.inera.se/inera-kodverksforvaltning/kodverk/icd-10-se"
* ^version = "0.2.0"
* ^status = #draft
* ^experimental = true
* ^caseSensitive = true
* ^content = #not-present
* ^count = 0


ValueSet: EncounterClassVS
Id: encounter-class-vs
Title: "Encounter Class ValueSet"
Description: "Klassificering av vårdkontakt (öppen/sluten/akut/etc.)."
* ^version = "0.2.0"
* ^status = #draft
* ^experimental = true
* include codes from system http://terminology.hl7.org/CodeSystem/v3-ActCode
    where concept is-a #ActEncounterCode


// [CB-T01 FIXAD] EncounterTypeVS pekar nu på terminologitjänstens KV Vårdkontakttyp
ValueSet: EncounterTypeVS
Id: encounter-type-vs
Title: "Encounter Type ValueSet (KV Vårdkontakttyp)"
Description: """
Typer av vårdkontakter per KV Vårdkontakttyp.
URI: https://terminologitjansten.inera.se/inera-kodverksforvaltning/kodverk/kv_vardkontakttyp
OID: 1.2.752.129.2.2.2.25
"""
* ^version = "0.2.0"
* ^status = #draft
* ^experimental = true
* include codes from system https://terminologitjansten.inera.se/inera-kodverksforvaltning/kodverk/kv_vardkontakttyp

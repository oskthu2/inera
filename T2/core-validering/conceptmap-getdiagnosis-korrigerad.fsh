// ============================================================================
// KORRIGERAD: conceptmap-getdiagnosis.fsh
// Korrigeringar: CM-01, CM-02, CM-03, CM-04, CM-05, CM-06
//
// CM-02: Följande fält från originalfilen är BORTTAGNA HELT eftersom de
// saknar motsvarighet i TKB GetDiagnosis XSD och FSH-modell:
//   - diagnosis.diagnosisBody.diagnosisStatus
//   - diagnosis.diagnosisBody.verificationStatus
//   - diagnosis.diagnosisBody.diagnosisSeverity
//   - diagnosis.diagnosisBody.bodyStructure
//   - diagnosis.diagnosisBody.nullified
//   - diagnosis.diagnosisBody.nullifiedReason
// Dessa är FHIR Condition-attribut projicerade bakåt på TKB-modellen.
// De ska inte förekomma som källkoder i en ConceptMap vars källa är TKB.
// ============================================================================

Instance: getdiagnosis-tkb-to-condition
InstanceOf: ConceptMap
Usage: #definition
Title: "ConceptMap GetDiagnosis TKB to FHIR Condition"
Description: """
Mappning från GetDiagnosis TKB-tjänst till FHIR-resurser.

**TKB-tjänst**: GetDiagnosis v2.0/v3.0
**TKB-domän**: clinicalprocess:healthcond:description v3.0.5
**Logisk modell**: GetDiagnosis (FSH-genererad från TKB)
**FHIR-resurser**: Condition, Provenance

**Mappningsstruktur**:
- Group 0: Encounter-mappningar (Condition.encounter ← careContactId)
- Group 1: Condition-mappningar (diagnosisBody-element)
- Group 2: Provenance-mappningar (diagnosisHeader-element)
- Group 3: Ej mappade (frågeparametrar, result-wrapper)
- Group 4: [CM-04] Kodöversättning DiagnosisTypeCS → condition-category
"""

* url = "https://inera.se/fhir/core/ConceptMap/getdiagnosis-tkb-to-condition"
* version = "0.3.0"
* name = "ConceptMapGetDiagnosisTKBToCondition"
* status = #draft
* experimental = true

// ── Källsystem: GetDiagnosis logisk modell (FSH-elementnamn)
// ── Målsystem: FHIR Condition / Provenance (R4 elementnamn)

// ============================================================================
// GROUP 0: Encounter-koppling
// ============================================================================
* group[0].source = "https://inera.se/fhir/CodeSystem/getdiagnosis-lm"
* group[0].target = "http://hl7.org/fhir/StructureDefinition/Encounter"

// diagnosisHeader.careContactId → Encounter.identifier (sökning)
* group[0].element[0].code = #diagnosis.diagnosisHeader.careContactId
* group[0].element[0].display = "Vårdkontakts-id (0..1)"
* group[0].element[0].target[0].code = #identifier
* group[0].element[0].target[0].equivalence = #relatedto
* group[0].element[0].target[0].comment = "SHOULD: om careContactId finns anges Condition.encounter som Reference(Encounter) med detta id. careContactId är 0..1 i TKB — encounter får inte vara 1..1 i profilen."

// ============================================================================
// GROUP 1: Condition-mappningar (diagnosisBody)
// ============================================================================
* group[1].source = "https://inera.se/fhir/CodeSystem/getdiagnosis-lm"
* group[1].target = "http://hl7.org/fhir/StructureDefinition/Condition"

// [CM-01 FIXAD] Fältnamn korrigerat: diagnosisType → typeOfDiagnosis
// typeOfDiagnosis (1..1, CodeableConcept, bunden till DiagnosisTypeVS)
// [CM-04] Explicita kodöversättningar finns i Group 4 (DiagnosisTypeCS → condition-category)
* group[1].element[0].code = #diagnosis.diagnosisBody.typeOfDiagnosis
* group[1].element[0].display = "Typ av diagnos – Huvuddiagnos | Bidiagnos (1..1)"
* group[1].element[0].target[0].code = #category
* group[1].element[0].target[0].equivalence = #wider
* group[1].element[0].target[0].comment = """Mappas via Group 4 (kodöversättning DiagnosisTypeCS → condition-category).
Huvuddiagnos och Bidiagnos mappar båda till #encounter-diagnosis.
System källa: https://fhir.inera.se/clinicalprocess-healthcond-description/CodeSystem/diagnosistype-cs
System mål: http://terminology.hl7.org/CodeSystem/condition-category"""

// diagnosisCode (0..1, CodeableConcept — normalt ICD-10-SE)
// [CM-03 FIXAD] Korrekt terminologitjänst-URI används
* group[1].element[1].code = #diagnosis.diagnosisBody.diagnosisCode
* group[1].element[1].display = "Diagnoskod – ICD-10-SE eller KVÅ (0..1)"
* group[1].element[1].target[0].code = #code
* group[1].element[1].target[0].equivalence = #equivalent
* group[1].element[1].target[0].comment = """Diagnoskod (CVType). Kodsystem-OID → URI via NamingSystem (lager 2a):
ICD-10-SE OID 1.2.752.116.1.1.1.1.3 → https://terminologitjansten.inera.se/inera-kodverksforvaltning/kodverk/icd-10-se
KVÅ OID 1.2.752.129.2.2.2.1 → http://electronichealth.se/id/kva
diagnosisCode.code → code.coding.code
diagnosisCode.displayName → code.coding.display
diagnosisCode.originalText → code.text"""

// diagnosisTime (0..1, dateTime)
* group[1].element[2].code = #diagnosis.diagnosisBody.diagnosisTime
* group[1].element[2].display = "Diagnostidpunkt (0..1)"
* group[1].element[2].target[0].code = #onsetDateTime
* group[1].element[2].target[0].equivalence = #equivalent
* group[1].element[2].target[0].comment = "Format YYYYMMDDhhmmss → ISO 8601 dateTime via datatypbibliotek (lager 1)."

// [CM-05 FIXAD] chronicDiagnosis → stage[chronicityEvaluation].summary
* group[1].element[3].code = #diagnosis.diagnosisBody.chronicDiagnosis
* group[1].element[3].display = "Kronisk diagnos (boolean, 0..1)"
* group[1].element[3].target[0].code = #stage
* group[1].element[3].target[0].equivalence = #equivalent
* group[1].element[3].target[0].comment = """Modelleras som stage[chronicityEvaluation] i ConditionDiagnosisInera:
  stage[chronicityEvaluation].type = ChronicityStagingTypeCS#kronisk-utvardering
  stage[chronicityEvaluation].summary = ChronicityVS:
    true  → https://inera.se/fhir/core/CodeSystem/chronicity#kronisk
    false → https://inera.se/fhir/core/CodeSystem/chronicity#ej-kronisk"""

// [CM-06 FIXAD] relatedDiagnosis → extension[ext-related-diagnosis]
* group[1].element[4].code = #diagnosis.diagnosisBody.relatedDiagnosis.documentId
* group[1].element[4].display = "Relaterad diagnos documentId (0..*)"
* group[1].element[4].target[0].code = #extension
* group[1].element[4].target[0].equivalence = #equivalent
* group[1].element[4].target[0].comment = """Kopplar bidiagnos till sin huvuddiagnos.
Extension: ext-related-diagnosis (ExtRelatedDiagnosis) i ConditionDiagnosisInera.
documentId används för att slå upp den relaterade Condition-resursen via Condition.identifier.
Typ: Reference(Condition). Kardinalitet: 0..*."""

// ============================================================================
// GROUP 2: Provenance-mappningar (diagnosisHeader)
// ============================================================================
* group[2].source = "https://inera.se/fhir/CodeSystem/getdiagnosis-lm"
* group[2].target = "http://hl7.org/fhir/StructureDefinition/Provenance"

// diagnosisHeader.documentId
* group[2].element[0].code = #diagnosis.diagnosisHeader.documentId
* group[2].element[0].display = "Dokumentid (1..1)"
* group[2].element[0].target[0].code = #entity.what.identifier
* group[2].element[0].target[0].equivalence = #equivalent
* group[2].element[0].target[0].comment = "Dokumentets identitet i källsystemet. Provenance.entity.what = Reference(Condition) med detta id."

// diagnosisHeader.sourceSystemHSAId
* group[2].element[1].code = #diagnosis.diagnosisHeader.sourceSystemHSAId
* group[2].element[1].display = "Källsystem HSA-id (1..1)"
* group[2].element[1].target[0].code = #agent[custodian].who
* group[2].element[1].target[0].equivalence = #equivalent
* group[2].element[1].target[0].comment = "HSA-id för källsystem → agent[custodian] Reference(Organization) med identifier.system = HSA-URI."

// diagnosisHeader.accountableHealthcareProfessional.authorTime
* group[2].element[2].code = #diagnosis.diagnosisHeader.accountableHealthcareProfessional.authorTime
* group[2].element[2].display = "Registreringstidpunkt (1..1)"
* group[2].element[2].target[0].code = #recorded
* group[2].element[2].target[0].equivalence = #equivalent
* group[2].element[2].target[0].comment = "Format YYYYMMDDhhmmss → ISO 8601 via datatypbibliotek (lager 1)."

// diagnosisHeader.accountableHealthcareProfessional.healthcareProfessionalHSAId
* group[2].element[3].code = #diagnosis.diagnosisHeader.accountableHealthcareProfessional.healthcareProfessionalHSAId
* group[2].element[3].display = "Författarens HSA-id (0..1)"
* group[2].element[3].target[0].code = #agent[author].who
* group[2].element[3].target[0].equivalence = #equivalent
* group[2].element[3].target[0].comment = "Reference(Practitioner) med identifier HSA-id."

// diagnosisHeader.accountableHealthcareProfessional.healthcareProfessionalName
* group[2].element[4].code = #diagnosis.diagnosisHeader.accountableHealthcareProfessional.healthcareProfessionalName
* group[2].element[4].display = "Namn på hälso- och sjukvårdspersonal (0..1)"
* group[2].element[4].target[0].code = #agent[author].who.display
* group[2].element[4].target[0].equivalence = #equivalent
* group[2].element[4].target[0].comment = "Klartext i Reference.display om Practitioner-resursen saknas."

// diagnosisHeader.accountableHealthcareProfessional.healthcareProfessionalRoleCode
* group[2].element[5].code = #diagnosis.diagnosisHeader.accountableHealthcareProfessional.healthcareProfessionalRoleCode
* group[2].element[5].display = "Befattning (0..1)"
* group[2].element[5].target[0].code = #agent[author].role
* group[2].element[5].target[0].equivalence = #equivalent
* group[2].element[5].target[0].comment = "KV Befattning (OID 1.2.752.129.2.2.1.4) → URI https://terminologitjansten.inera.se/inera-kodverksforvaltning/kodverk/kv_befattning via NamingSystem."

// diagnosisHeader.accountableHealthcareProfessional.healthcareProfessionalOrgUnit.orgUnitHSAId
* group[2].element[6].code = #diagnosis.diagnosisHeader.accountableHealthcareProfessional.healthcareProfessionalOrgUnit.orgUnitHSAId
* group[2].element[6].display = "HSA-id för organisationsenhet (1..1 inom OrgUnitType)"
* group[2].element[6].target[0].code = #agent[author].onBehalfOf
* group[2].element[6].target[0].equivalence = #equivalent
* group[2].element[6].target[0].comment = "Reference(Organization) med HSA-id."

// diagnosisHeader.accountableHealthcareProfessional.healthcareProfessionalCareUnitHSAId
* group[2].element[7].code = #diagnosis.diagnosisHeader.accountableHealthcareProfessional.healthcareProfessionalCareUnitHSAId
* group[2].element[7].display = "HSA-id för vårdenhet (0..1)"
* group[2].element[7].target[0].code = #agent[author].onBehalfOf
* group[2].element[7].target[0].equivalence = #wider
* group[2].element[7].target[0].comment = "Reference(Organization) vårdenhet. Vid konflikt med orgUnit prioriteras orgUnit (PDL-hierarki)."

// diagnosisHeader.accountableHealthcareProfessional.healthcareProfessionalCareGiverHSAId
* group[2].element[8].code = #diagnosis.diagnosisHeader.accountableHealthcareProfessional.healthcareProfessionalCareGiverHSAId
* group[2].element[8].display = "HSA-id för vårdgivare (0..1)"
* group[2].element[8].target[0].code = #agent[custodian].who
* group[2].element[8].target[0].equivalence = #wider
* group[2].element[8].target[0].comment = "Reference(Organization) vårdgivare. agent-typ custodian."

// diagnosisHeader.legalAuthenticator.legalAuthenticatorHSAId
* group[2].element[9].code = #diagnosis.diagnosisHeader.legalAuthenticator.legalAuthenticatorHSAId
* group[2].element[9].display = "Signerande person HSA-id (0..1 inom legalAuthenticator)"
* group[2].element[9].target[0].code = #agent[legalAuthenticator].who
* group[2].element[9].target[0].equivalence = #equivalent
* group[2].element[9].target[0].comment = "Reference(Practitioner) med HSA-id. Slice legalAuthenticator i ProvenanceBaseInera (verifier)."

// diagnosisHeader.legalAuthenticator.signatureTime
* group[2].element[10].code = #diagnosis.diagnosisHeader.legalAuthenticator.signatureTime
* group[2].element[10].display = "Tidpunkt för signering (1..1 inom legalAuthenticator)"
* group[2].element[10].target[0].code = #signature.when
* group[2].element[10].target[0].equivalence = #equivalent
* group[2].element[10].target[0].comment = "Format YYYYMMDDhhmmss → ISO 8601 instant via datatypbibliotek."

// diagnosisHeader.approvedForPatient
* group[2].element[11].code = #diagnosis.diagnosisHeader.approvedForPatient
* group[2].element[11].display = "Godkänd för visning till patient (1..1)"
* group[2].element[11].target[0].equivalence = #unmatched
* group[2].element[11].target[0].comment = "Inget direkt FHIR-fält. Hanteras via meta.security (etiketten NOPAT = ej tillgänglig för patient) eller via Consent-resurs. Implementationsspecifik logik."

// ============================================================================
// GROUP 3: Ej mappade (frågeparametrar och result-wrapper)
// ============================================================================
* group[3].source = "https://inera.se/fhir/CodeSystem/getdiagnosis-lm"
* group[3].target = "http://hl7.org/fhir/StructureDefinition/OperationOutcome"

// Frågeparametrar — mappar till sökparametrar, lagras inte i resurser
* group[3].element[0].code = #patientId
* group[3].element[0].display = "Frågeparameter: patientId (RIV-TA request)"
* group[3].element[0].target[0].equivalence = #unmatched
* group[3].element[0].target[0].comment = "Frågeparameter, lagras ej. FHIR: _patient-sökparameter."

* group[3].element[1].code = #careUnitHSAId
* group[3].element[1].display = "Frågeparameter: careUnitHSAId"
* group[3].element[1].target[0].equivalence = #unmatched
* group[3].element[1].target[0].comment = "Frågeparameter för RIV-TA routing. Ingen FHIR-motsvarighet."

// result-wrapper
* group[3].element[2].code = #result.resultCode
* group[3].element[2].display = "Resultatkod: OK | INFO | ERROR"
* group[3].element[2].target[0].equivalence = #unmatched
* group[3].element[2].target[0].comment = "HTTP-statuskod + OperationOutcome vid fel."

* group[3].element[3].code = #result.errorCode
* group[3].element[3].display = "Felkod: INVALID_REQUEST"
* group[3].element[3].target[0].equivalence = #unmatched
* group[3].element[3].target[0].comment = "OperationOutcome.issue.code vid fel."

* group[3].element[4].code = #result.logId
* group[3].element[4].display = "Log-id (UUID)"
* group[3].element[4].target[0].equivalence = #unmatched
* group[3].element[4].target[0].comment = "OperationOutcome.issue.diagnostics eller X-Request-Id."

* group[3].element[5].code = #result.message
* group[3].element[5].display = "Meddelande (fritext)"
* group[3].element[5].target[0].equivalence = #unmatched
* group[3].element[5].target[0].comment = "OperationOutcome.issue.diagnostics."

// ============================================================================
// GROUP 4: [CM-04 FIXAD] Kodöversättning DiagnosisTypeCS → condition-category
// Källsystem: DiagnosisTypeCS (Inera TKB)
// Målsystem: HL7 condition-category
// Både Huvuddiagnos och Bidiagnos mappar till encounter-diagnosis;
// rangordning (huvud/bi) hanteras via Encounter.diagnosis.rank.
// ============================================================================
* group[4].source = "https://fhir.inera.se/clinicalprocess-healthcond-description/CodeSystem/diagnosistype-cs"
* group[4].target = "http://terminology.hl7.org/CodeSystem/condition-category"

* group[4].element[0].code = #Huvuddiagnos
* group[4].element[0].display = "Huvuddiagnos"
* group[4].element[0].target[0].code = #encounter-diagnosis
* group[4].element[0].target[0].display = "Encounter Diagnosis"
* group[4].element[0].target[0].equivalence = #wider
* group[4].element[0].target[0].comment = "Huvuddiagnos mappar till encounter-diagnosis. Rangordning (rank=1) anges i Encounter.diagnosis."

* group[4].element[1].code = #Bidiagnos
* group[4].element[1].display = "Bidiagnos"
* group[4].element[1].target[0].code = #encounter-diagnosis
* group[4].element[1].target[0].display = "Encounter Diagnosis"
* group[4].element[1].target[0].equivalence = #wider
* group[4].element[1].target[0].comment = "Bidiagnos mappar till encounter-diagnosis (samma målkod som Huvuddiagnos). Rangordning (rank>1) anges i Encounter.diagnosis."

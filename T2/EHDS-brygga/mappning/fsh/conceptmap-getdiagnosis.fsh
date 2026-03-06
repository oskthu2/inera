// ═══════════════════════════════════════════════════════════════════════════════
// CONCEPT MAP: GetDiagnosis TKB to FHIR Condition
// ═══════════════════════════════════════════════════════════════════════════════
//
// Complete mapping of ALL elements from GetDiagnosis TKB service
// Source: Excel-generated logical model (GetDiagnosisLM)
// Categorized as:
// - FHIR Condition resource elements (diagnosis data)
// - Provenance/metadata elements (authorship, organization hierarchy)
// - Unmapped elements (query parameters, result wrapper, deprecated fields)
//
// ═══════════════════════════════════════════════════════════════════════════════

Instance: getdiagnosis-tkb-to-condition
InstanceOf: ConceptMap
Usage: #definition
Title: "ConceptMap GetDiagnosis TKB to FHIR Condition"
Description: """
Mapping from GetDiagnosis TKB service to FHIR resources.
Based on Excel-generated logical model with enhanced field descriptions.

**TKB Service**: GetDiagnosis v2.0/v3.0
**TKB Domain**: clinicalprocess:healthcond:description v2.1/v3.0
**Logical Model**: GetDiagnosisLM (from FSH-konvertering.xlsx)
**FHIR Resource**: Condition
**FHIR Profile**: ConditionDiagnosisInera

**Mapping Coverage**:
- ✅ Mapped to Condition: 12+ elements (diagnosis code, status, severity, verification)
- ✅ Mapped to Provenance: 15+ elements (header metadata, authorship)
- ❌ Not mapped: 6+ elements (query parameters, result wrapper)

**Key Patterns**:
- diagnosisHeader → Provenance (authorship tracking)
- diagnosis (body) → Condition resource
- diagnosisCode → ICD-10-SE or KVÅ codes
- diagnosisStatus → clinicalStatus + verificationStatus
- Query parameters → Search parameters (not stored)
"""

* url = "https://inera.se/fhir/core/ConceptMap/getdiagnosis-tkb-to-condition"
* version = "0.2.0"
* name = "ConceptMapGetDiagnosisTKBToCondition"
* status = #draft
* experimental = true
* date = "2025-11-24"
* publisher = "Inera AB"
* contact.telecom.system = #url
* contact.telecom.value = "https://www.inera.se"
* description = "Complete mapping from GetDiagnosis TKB service to FHIR Condition and Provenance resources"
* jurisdiction = urn:iso:std:iso:3166#SE "Sweden"
* sourceUri = "https://rivta.se/domains/clinicalprocess/healthcond/description/GetDiagnosisResponder/2"
* targetCanonical = "http://hl7.org/fhir/StructureDefinition/Condition"

// ═══════════════════════════════════════════════════════════════════════════════
// GROUP 0: QUERY PARAMETERS (not mapped to resources - used as search parameters)
// ═══════════════════════════════════════════════════════════════════════════════

* group[0].source = "https://rivta.se/domains/clinicalprocess/healthcond/description/GetDiagnosisResponder/2"
* group[0].target = "http://hl7.org/fhir/StructureDefinition/Bundle"

* group[0].element[0].code = #patientId
* group[0].element[0].display = "Query parameter: Patient ID filter"
* group[0].element[0].target[0].equivalence = #unmatched
* group[0].element[0].target[0].comment = "NOT MAPPED. Used as search parameter: GET /Condition?subject=Patient/191212121212"

* group[0].element[1].code = #careUnitHSAid
* group[0].element[1].display = "Query parameter: Filter by care unit HSA-ID"
* group[0].element[1].target[0].equivalence = #unmatched
* group[0].element[1].target[0].comment = "NOT MAPPED. Used as search parameter: GET /Condition?asserter.onBehalfOf.identifier=https://hsaid.se|SE2321000016-A001"

* group[0].element[2].code = #timePeriod
* group[0].element[2].display = "Query parameter: Time period filter (from-to)"
* group[0].element[2].target[0].equivalence = #unmatched
* group[0].element[2].target[0].comment = "NOT MAPPED. Used as search parameter: GET /Condition?recorded-date=ge2025-01-01&recorded-date=le2025-12-31"

// ═══════════════════════════════════════════════════════════════════════════════
// GROUP 1: CONDITION RESOURCE MAPPINGS (diagnosis → Condition)
// ═══════════════════════════════════════════════════════════════════════════════

* group[1].source = "https://rivta.se/domains/clinicalprocess/healthcond/description/GetDiagnosisResponder/2"
* group[1].target = "http://hl7.org/fhir/StructureDefinition/Condition"

// diagnosisHeader.documentId → Condition.identifier
* group[1].element[0].code = #diagnosis.diagnosisHeader.documentId
* group[1].element[0].display = "Diagnosis ID (unique business identifier)"
* group[1].element[0].target[0].code = #identifier
* group[1].element[0].target[0].equivalence = #equivalent
* group[1].element[0].target[0].comment = "Unique diagnosis identifier within source system. System derived from sourceSystemHSAid."

// diagnosisHeader.patientId → Condition.subject
* group[1].element[1].code = #diagnosis.diagnosisHeader.patientId
* group[1].element[1].display = "Patient ID (personnummer/samordningsnummer/reservnummer)"
* group[1].element[1].target[0].code = #subject
* group[1].element[1].target[0].equivalence = #equivalent
* group[1].element[1].target[0].comment = "Reference to Patient with Swedish national identifier. OID 1.2.752.129.2.1.3.1 (personnummer), 1.2.752.129.2.1.3.3 (samordningsnummer)"

// diagnosisHeader.approvedForPatient → Condition.meta.security
* group[1].element[2].code = #diagnosis.diagnosisHeader.approvedForPatient
* group[1].element[2].display = "Approved for patient access (true/false)"
* group[1].element[2].target[0].code = #meta.security
* group[1].element[2].target[0].equivalence = #equivalent
* group[1].element[2].target[0].comment = "If false, add security label NOPATIENT to restrict patient access (menprövningsflagga)."

// diagnosisBody.diagnosisCode → Condition.code
* group[1].element[3].code = #diagnosis.diagnosisBody.diagnosisCode
* group[1].element[3].display = "Diagnosis code (ICD-10-SE, KVÅ)"
* group[1].element[3].target[0].code = #code
* group[1].element[3].target[0].equivalence = #equivalent
* group[1].element[3].target[0].comment = "ICD-10-SE (http://hl7.org/fhir/sid/icd-10) or KVÅ codes. code.coding.code, code.coding.display, code.text. May have multiple codings."

// diagnosisBody.diagnosisCode.code → Condition.code.coding.code
* group[1].element[4].code = #diagnosis.diagnosisBody.diagnosisCode.code
* group[1].element[4].display = "Diagnosis code value"
* group[1].element[4].target[0].code = #code.coding.code
* group[1].element[4].target[0].equivalence = #equivalent
* group[1].element[4].target[0].comment = "ICD-10-SE code value (e.g., I10, E11.9). System: http://hl7.org/fhir/sid/icd-10"

// diagnosisBody.diagnosisCode.codeSystem → Condition.code.coding.system
* group[1].element[5].code = #diagnosis.diagnosisBody.diagnosisCode.codeSystem
* group[1].element[5].display = "Diagnosis code system OID"
* group[1].element[5].target[0].code = #code.coding.system
* group[1].element[5].target[0].equivalence = #relatedto
* group[1].element[5].target[0].comment = "OID → FHIR URL. ICD-10-SE OID → http://hl7.org/fhir/sid/icd-10. KVÅ → Swedish classification URL."

// diagnosisBody.diagnosisCode.displayName → Condition.code.coding.display
* group[1].element[6].code = #diagnosis.diagnosisBody.diagnosisCode.displayName
* group[1].element[6].display = "Diagnosis text/display name"
* group[1].element[6].target[0].code = #code.coding.display
* group[1].element[6].target[0].equivalence = #equivalent
* group[1].element[6].target[0].comment = "Human-readable diagnosis name. Also populate code.text for overall display."

// diagnosisBody.diagnosisCode.originalText → Condition.code.text
* group[1].element[7].code = #diagnosis.diagnosisBody.diagnosisCode.originalText
* group[1].element[7].display = "Original diagnosis text"
* group[1].element[7].target[0].code = #code.text
* group[1].element[7].target[0].equivalence = #equivalent
* group[1].element[7].target[0].comment = "Free-text diagnosis description. Use when no exact code match."

// diagnosisBody.typeOfDiagnosis → Condition.category
* group[1].element[8].code = #diagnosis.diagnosisBody.typeOfDiagnosis
* group[1].element[8].display = "Diagnosis type (primär, sekundär, underdiagnos)"
* group[1].element[8].target[0].code = #category
* group[1].element[8].target[0].equivalence = #wider
* group[1].element[8].target[0].comment = "Swedish diagnosis types → FHIR category. May need ConceptMap. Use condition-category: problem-list-item|encounter-diagnosis."

// diagnosisBody.diagnosisStatus → Condition.clinicalStatus + verificationStatus
* group[1].element[9].code = #diagnosis.diagnosisBody.diagnosisStatus
* group[1].element[9].display = "Diagnosis clinical status"
* group[1].element[9].target[0].code = #clinicalStatus
* group[1].element[9].target[0].equivalence = #wider
* group[1].element[9].target[0].comment = "Swedish status → FHIR clinicalStatus (active|recurrence|relapse|inactive|remission|resolved). Requires transformation."

// diagnosisBody.verificationStatus → Condition.verificationStatus
* group[1].element[10].code = #diagnosis.diagnosisBody.verificationStatus
* group[1].element[10].display = "Diagnosis verification status (confirmed, provisional, differential)"
* group[1].element[10].target[0].code = #verificationStatus
* group[1].element[10].target[0].equivalence = #equivalent
* group[1].element[10].target[0].comment = "FHIR verificationStatus: unconfirmed|provisional|differential|confirmed|refuted|entered-in-error"

// diagnosisBody.diagnosisSeverity → Condition.severity
* group[1].element[11].code = #diagnosis.diagnosisBody.diagnosisSeverity
* group[1].element[11].display = "Diagnosis severity (mild, moderate, severe)"
* group[1].element[11].target[0].code = #severity
* group[1].element[11].target[0].equivalence = #equivalent
* group[1].element[11].target[0].comment = "Use SNOMED CT severity codes: 255604002 (mild), 6736007 (moderate), 24484000 (severe)"

// diagnosisBody.diagnosisTime → Condition.onsetDateTime or recordedDate
* group[1].element[12].code = #diagnosis.diagnosisBody.diagnosisTime
* group[1].element[12].display = "Diagnosis date/time"
* group[1].element[12].target[0].code = #onsetDateTime
* group[1].element[12].target[0].equivalence = #wider
* group[1].element[12].target[0].comment = "When condition started → onsetDateTime. When diagnosis recorded → recordedDate. Use based on context."

// diagnosisHeader.careContactId → Condition.encounter
* group[1].element[13].code = #diagnosis.diagnosisHeader.careContactId
* group[1].element[13].display = "Care contact ID (encounter context)"
* group[1].element[13].target[0].code = #encounter
* group[1].element[13].target[0].equivalence = #equivalent
* group[1].element[13].target[0].comment = "Reference to Encounter when diagnosis made during care contact."

// diagnosisBody.bodyStructure → Condition.bodySite
* group[1].element[14].code = #diagnosis.diagnosisBody.bodyStructure
* group[1].element[14].display = "Body structure/location"
* group[1].element[14].target[0].code = #bodySite
* group[1].element[14].target[0].equivalence = #equivalent
* group[1].element[14].target[0].comment = "Body site affected by condition. Use SNOMED CT body structure codes."

// diagnosisHeader.nullified → Condition.verificationStatus
* group[1].element[15].code = #diagnosis.diagnosisHeader.nullified
* group[1].element[15].display = "Diagnosis nullified flag"
* group[1].element[15].target[0].code = #verificationStatus
* group[1].element[15].target[0].equivalence = #equivalent
* group[1].element[15].target[0].comment = "If nullified=true, set verificationStatus=entered-in-error. Store nullifiedReason in Provenance."

// ═══════════════════════════════════════════════════════════════════════════════
// GROUP 2: PROVENANCE RESOURCE MAPPINGS (diagnosisHeader authorship)
// ═══════════════════════════════════════════════════════════════════════════════

* group[2].source = "https://rivta.se/domains/clinicalprocess/healthcond/description/GetDiagnosisResponder/2"
* group[2].target = "http://hl7.org/fhir/StructureDefinition/Provenance"

// diagnosisHeader.sourceSystemHSAid → Provenance.entity & meta.source
* group[2].element[0].code = #diagnosis.diagnosisHeader.sourceSystemHSAId
* group[2].element[0].display = "Source system HSA-ID"
* group[2].element[0].target[0].code = #entity.what
* group[2].element[0].target[0].equivalence = #equivalent
* group[2].element[0].target[0].comment = "HSA-ID of source system. Also mapped to Condition.meta.source as https://hsaid.se/{HSA-ID}. Provenance.entity.role=source."

// diagnosisHeader.accountableHealthcareProfessional.authorTime → Provenance.recorded
* group[2].element[1].code = #diagnosis.diagnosisHeader.accountableHealthcareProfessional.authorTime
* group[2].element[1].display = "Author time (registration timestamp)"
* group[2].element[1].target[0].code = #recorded
* group[2].element[1].target[0].equivalence = #equivalent
* group[2].element[1].target[0].comment = "When diagnosis was recorded. Also mapped to Condition.recordedDate."

// diagnosisHeader.accountableHealthcareProfessional.healthcareProfessionalHSAid → Provenance.agent.who
* group[2].element[2].code = #diagnosis.diagnosisHeader.accountableHealthcareProfessional.healthcareProfessionalHSAId
* group[2].element[2].display = "Healthcare professional HSA-ID"
* group[2].element[2].target[0].code = #agent.who
* group[2].element[2].target[0].equivalence = #equivalent
* group[2].element[2].target[0].comment = "Reference to Practitioner with HSA-ID. Provenance.agent.type=author. Also in Condition.recorder/asserter."

// diagnosisHeader.accountableHealthcareProfessional.healthcareProfessionalName → agent.who.display
* group[2].element[3].code = #diagnosis.diagnosisHeader.accountableHealthcareProfessional.healthcareProfessionalName
* group[2].element[3].display = "Healthcare professional name"
* group[2].element[3].target[0].code = #agent.who.display
* group[2].element[3].target[0].equivalence = #equivalent
* group[2].element[3].target[0].comment = "Display name. Full Practitioner resource should have structured name."

// diagnosisHeader.accountableHealthcareProfessional.healthcareProfessionalRoleCode → agent.role
* group[2].element[4].code = #diagnosis.diagnosisHeader.accountableHealthcareProfessional.healthcareProfessionalRoleCode
* group[2].element[4].display = "Healthcare professional role/befattning"
* group[2].element[4].target[0].code = #agent.role
* group[2].element[4].target[0].equivalence = #relatedto
* group[2].element[4].target[0].comment = "Professional role (befattning). Use KV Befattning (OID 1.2.752.129.2.2.1.4). Also in Practitioner.qualification."

// diagnosisHeader.accountableHealthcareProfessional.healthcareProfessionalOrgUnit → agent.onBehalfOf
* group[2].element[5].code = #diagnosis.diagnosisHeader.accountableHealthcareProfessional.healthcareProfessionalOrgUnit
* group[2].element[5].display = "Organization unit (where professional works)"
* group[2].element[5].target[0].code = #agent.onBehalfOf
* group[2].element[5].target[0].equivalence = #equivalent
* group[2].element[5].target[0].comment = "Reference to Organization (organizational unit). Full details (HSA-ID, name, telecom, address, location) in Organization resource."

// diagnosisHeader.accountableHealthcareProfessional.healthcareProfessionalCareUnitHSAid → Provenance.entity
* group[2].element[6].code = #diagnosis.diagnosisHeader.accountableHealthcareProfessional.healthcareProfessionalCareUnitHSAId
* group[2].element[6].display = "Care unit HSA-ID (vårdenhet)"
* group[2].element[6].target[0].code = #entity.what
* group[2].element[6].target[0].equivalence = #equivalent
* group[2].element[6].target[0].comment = "HSA-ID for care unit. Reference to Organization. Part of PDL hierarchy."

// diagnosisHeader.accountableHealthcareProfessional.healthcareProfessionalCareGiverHSAid → Provenance.entity
* group[2].element[7].code = #diagnosis.diagnosisHeader.accountableHealthcareProfessional.healthcareProfessionalCareGiverHSAId
* group[2].element[7].display = "Care provider HSA-ID (vårdgivare)"
* group[2].element[7].target[0].code = #entity.what
* group[2].element[7].target[0].equivalence = #equivalent
* group[2].element[7].target[0].comment = "HSA-ID for care provider. Top-level organization in PDL hierarchy. Reference to Organization."

// diagnosisHeader.legalAuthenticator.signatureTime → Provenance.occurredDateTime
* group[2].element[8].code = #diagnosis.diagnosisHeader.legalAuthenticator.legalAuthenticatorTime
* group[2].element[8].display = "Attestation timestamp"
* group[2].element[8].target[0].code = #occurredDateTime
* group[2].element[8].target[0].equivalence = #equivalent
* group[2].element[8].target[0].comment = "Time of juridisk attestering. Provenance.occurredDateTime."

// diagnosisHeader.legalAuthenticator.legalAuthenticatorHSAid → Provenance.agent[type=legal].who
* group[2].element[9].code = #diagnosis.diagnosisHeader.legalAuthenticator.legalAuthenticatorHSAId
* group[2].element[9].display = "Legal authenticator HSA-ID"
* group[2].element[9].target[0].code = #agent.who
* group[2].element[9].target[0].equivalence = #equivalent
* group[2].element[9].target[0].comment = "Reference to Practitioner who attested diagnosis. Provenance.agent with type=legal."

// diagnosisHeader.nullifiedReason → Provenance.reason
* group[2].element[10].code = #diagnosis.diagnosisHeader.nullifiedReason
* group[2].element[10].display = "Reason for nullification"
* group[2].element[10].target[0].code = #reason
* group[2].element[10].target[0].equivalence = #relatedto
* group[2].element[10].target[0].comment = "Why diagnosis was nullified. Store in Provenance.reason when verificationStatus=entered-in-error."

// ═══════════════════════════════════════════════════════════════════════════════
// GROUP 3: UNMAPPED / DEPRECATED / QUERY RESULT FIELDS
// ═══════════════════════════════════════════════════════════════════════════════

* group[3].source = "https://rivta.se/domains/clinicalprocess/healthcond/description/GetDiagnosisResponder/2"
* group[3].target = "http://hl7.org/fhir/StructureDefinition/Bundle"

// diagnosisHeader.documentTitle → NOT MAPPED (service-specific cardinality 0..0)
* group[3].element[0].code = #diagnosis.diagnosisHeader.documentTitle
* group[3].element[0].display = "Document title"
* group[3].element[0].target[0].equivalence = #unmatched
* group[3].element[0].target[0].comment = "NOT MAPPED. Cardinality 0..0 for GetDiagnosis. Use diagnosisCode.displayName instead."

// diagnosisHeader.documentTime → NOT MAPPED (service-specific cardinality 0..0)
* group[3].element[1].code = #diagnosis.diagnosisHeader.documentTime
* group[3].element[1].display = "Document time"
* group[3].element[1].target[0].equivalence = #unmatched
* group[3].element[1].target[0].comment = "NOT MAPPED. Cardinality 0..0 for GetDiagnosis. Use authorTime or diagnosisTime instead."

// result.resultCode → OperationOutcome or HTTP status
* group[3].element[2].code = #result.resultCode
* group[3].element[2].display = "Result code (OK, INFO, ERROR)"
* group[3].element[2].target[0].equivalence = #unmatched
* group[3].element[2].target[0].comment = "NOT MAPPED to resources. HTTP status: OK→200, INFO→200 with warnings, ERROR→4xx/5xx. Bundle-level OperationOutcome for details."

// result.errorCode → OperationOutcome.issue.code
* group[3].element[3].code = #result.errorCode
* group[3].element[3].display = "Error code"
* group[3].element[3].target[0].equivalence = #unmatched
* group[3].element[3].target[0].comment = "NOT MAPPED to resources. Use in OperationOutcome.issue.code when resultCode=ERROR."

// result.logId → OperationOutcome.issue.diagnostics
* group[3].element[4].code = #result.logId
* group[3].element[4].display = "Log ID (UUID for troubleshooting)"
* group[3].element[4].target[0].equivalence = #unmatched
* group[3].element[4].target[0].comment = "NOT MAPPED to resources. Use in OperationOutcome.issue.diagnostics or X-Request-Id header."

// result.message → OperationOutcome.issue.diagnostics
* group[3].element[5].code = #result.message
* group[3].element[5].display = "Result message"
* group[3].element[5].target[0].equivalence = #unmatched
* group[3].element[5].target[0].comment = "NOT MAPPED to resources. User-facing message in OperationOutcome.issue.diagnostics."

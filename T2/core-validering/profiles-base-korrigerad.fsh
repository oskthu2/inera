// ============================================================================
// KORRIGERAD: profiles-base.fsh
// Korrigeringar: PB-01, PB-T01, PB-T02
// ============================================================================

// ============================================================================
// PatientBaseInera — oförändrad
// ============================================================================
Profile: PatientBaseInera
Parent: http://hl7.se/fhir/ig/base/StructureDefinition/SEBasePatient
Id: patient-base-inera
Title: "Patient Base Inera"
Description: """
Swedish national base profile for Patient resource for NPÖ (Nationell Patientöversikt).
Builds on HL7 Sweden SE base profile and adds NPÖ-specific requirements.
"""

* ^version = "0.2.0"
* ^status = #draft
* ^experimental = true
* ^date = "2025-11-24"
* ^publisher = "Inera AB"
* ^jurisdiction = urn:iso:std:iso:3166#SE "Sweden"

* identifier MS
* name MS
* telecom MS
* gender MS
* birthDate MS
* address MS
* communication MS
* communication.language from http://hl7.org/fhir/ValueSet/all-languages (extensible)
* generalPractitioner MS
* generalPractitioner only Reference(PractitionerBaseInera or PractitionerRoleBaseInera or Organization)


// ============================================================================
// PractitionerBaseInera — korrigerad VS-referens (PB-T01)
// ============================================================================
Profile: PractitionerBaseInera
Parent: http://hl7.se/fhir/ig/base/StructureDefinition/SEBasePractitioner
Id: practitioner-base-inera
Title: "Practitioner Base Inera"
Description: """
Swedish national base profile for Practitioner resource for NPÖ.
Builds on HL7 Sweden SE base profile.
"""

* ^version = "0.2.0"
* ^status = #draft
* ^experimental = true
* ^date = "2025-11-24"
* ^publisher = "Inera AB"
* ^jurisdiction = urn:iso:std:iso:3166#SE "Sweden"

* identifier MS
* name MS
* name.family MS
* name.given MS
* telecom MS
* qualification MS
* qualification.code MS
* qualification.code ^short = "Befattning (KV Befattning)"
* qualification.code ^definition = "Yrkesroll/befattning per KV Befattning (OID 1.2.752.129.2.2.1.4). TKB: accountableHealthcareProfessional.healthcareProfessionalRoleCode."
// [PB-T01 FIXAD] KV Befattning via terminologitjänsten
* qualification.code from PractitionerQualificationVS (extensible)
* qualification.issuer MS


// ============================================================================
// PractitionerRoleBaseInera — oförändrad
// ============================================================================
Profile: PractitionerRoleBaseInera
Parent: PractitionerRole
Id: practitionerrole-base-inera
Title: "PractitionerRole Base Inera"
Description: "Swedish national base profile for PractitionerRole resource."

* ^version = "0.2.0"
* ^status = #draft
* ^experimental = true
* ^date = "2025-11-24"
* ^publisher = "Inera AB"
* ^jurisdiction = urn:iso:std:iso:3166#SE "Sweden"

* practitioner 1..1 MS
* practitioner only Reference(PractitionerBaseInera)
* organization 1..1 MS
* organization only Reference(OrganizationBaseInera)
* code MS
* code from PractitionerRoleVS (extensible)
* specialty MS
* specialty from PractitionerSpecialtyVS (extensible)
* location MS
* telecom MS


// ============================================================================
// OrganizationBaseInera — oförändrad
// ============================================================================
Profile: OrganizationBaseInera
Parent: http://hl7.se/fhir/ig/base/StructureDefinition/SEBaseOrganization
Id: organization-base-inera
Title: "Organization Base Inera"
Description: """
Swedish national base profile for Organization resource for NPÖ.
PDL-hierarki: vårdgivare → vårdenhet → organisationsenhet via partOf.
"""

* ^version = "0.2.0"
* ^status = #draft
* ^experimental = true
* ^date = "2025-11-24"
* ^publisher = "Inera AB"
* ^jurisdiction = urn:iso:std:iso:3166#SE "Sweden"

* identifier MS
* active MS
* type MS
* name MS
* telecom MS
* address MS
* partOf MS
* partOf only Reference(OrganizationBaseInera)
* partOf ^short = "Överordnad organisation (PDL-hierarki)"


// ============================================================================
// ProvenanceBaseInera — korrigerad med legalAuthenticator-slice (PB-01)
// ============================================================================
Profile: ProvenanceBaseInera
Parent: Provenance
Id: provenance-base-inera
Title: "Provenance Base Inera"
Description: """
Swedish national base profile for Provenance resource.
Fångar TKB-dokumenthuvudets ansvarspersoner per PDL 3 kap.

**TKB-mappning:**
- agent[author] ← accountableHealthcareProfessional
- agent[careProvider] ← healthcareProfessionalCareGiverHSAId
- agent[legalAuthenticator] ← legalAuthenticator (signerande person)
"""

* ^version = "0.2.0"
* ^status = #draft
* ^experimental = true
* ^date = "2025-11-24"
* ^publisher = "Inera AB"
* ^jurisdiction = urn:iso:std:iso:3166#SE "Sweden"

* target 1..* MS
* recorded 1..1 MS
* activity MS
* activity from ProvenanceActivityVS (extensible)

* agent 1..* MS
* agent ^slicing.discriminator.type = #value
* agent ^slicing.discriminator.path = "type.coding.code"
* agent ^slicing.rules = #open

// Ansvarig hälso- och sjukvårdspersonal (accountableHealthcareProfessional)
* agent contains author 1..1 MS
* agent[author].type.coding.system = "http://terminology.hl7.org/CodeSystem/provenance-participant-type"
* agent[author].type.coding.code = #author
* agent[author].who 1..1 MS
* agent[author].who only Reference(PractitionerBaseInera or PractitionerRoleBaseInera)
* agent[author].onBehalfOf MS
* agent[author].onBehalfOf only Reference(OrganizationBaseInera)
* agent[author].onBehalfOf ^short = "Organisationsenhet eller vårdenhet (orgUnitHSAId / careUnitHSAId)"

// Vårdgivare
* agent contains careProvider 0..1 MS
* agent[careProvider].type.coding.system = "http://terminology.hl7.org/CodeSystem/provenance-participant-type"
* agent[careProvider].type.coding.code = #custodian
* agent[careProvider].who only Reference(OrganizationBaseInera)
* agent[careProvider].who ^short = "Vårdgivare (healthcareProfessionalCareGiverHSAId)"

// [PB-01 FIXAD] Signerande person (legalAuthenticator)
* agent contains legalAuthenticator 0..1 MS
* agent[legalAuthenticator].type.coding.system = "http://terminology.hl7.org/CodeSystem/provenance-participant-type"
* agent[legalAuthenticator].type.coding.code = #verifier
* agent[legalAuthenticator].who 1..1 MS
* agent[legalAuthenticator].who only Reference(PractitionerBaseInera)
* agent[legalAuthenticator].who ^short = "Signerande person (legalAuthenticatorHSAId)"

* signature MS
* signature ^short = "Signatur (signatureTime → signature.when)"


// ============================================================================
// VALUE SETS
// ============================================================================

ValueSet: PractitionerQualificationVS
Id: practitioner-qualification-vs
Title: "Practitioner Qualification ValueSet (KV Befattning)"
Description: """
Befattningskoder för hälso- och sjukvårdspersonal.
[PB-T01] Primärt källa: KV Befattning (OID 1.2.752.129.2.2.1.4) via terminologitjänsten.
Fallback: HL7 v2-0360 tills terminologitjänsten exponerar KV Befattning.
"""
* ^version = "0.2.0"
* ^status = #draft
* ^experimental = true
// [PB-T01 FIXAD] Terminologitjänstens URI för KV Befattning (OID 1.2.752.129.2.2.1.4)
* include codes from system https://terminologitjansten.inera.se/inera-kodverksforvaltning/kodverk/kv_befattning
// Fallback tills terminologitjänsten är tillgänglig
* include codes from system http://terminology.hl7.org/CodeSystem/v2-0360


ValueSet: EncounterTypeVS
Id: encounter-type-vs
Title: "Encounter Type ValueSet (KV Vårdkontakttyp)"
Description: """
Typer av vårdkontakter per KV Vårdkontakttyp.
[PB-T02] URI: https://terminologitjansten.inera.se/inera-kodverksforvaltning/kodverk/kv_vardkontakttyp
OID: 1.2.752.129.2.2.2.25
"""
* ^version = "0.2.0"
* ^status = #draft
* ^experimental = true
// [PB-T02 FIXAD] Terminologitjänstens URI för KV Vårdkontakttyp
* include codes from system https://terminologitjansten.inera.se/inera-kodverksforvaltning/kodverk/kv_vardkontakttyp


ValueSet: PractitionerRoleVS
Id: practitioner-role-vs
Title: "Practitioner Role ValueSet"
Description: "Roller för hälso- och sjukvårdspersonal."
* ^version = "0.2.0"
* ^status = #draft
* ^experimental = true
* include codes from system http://terminology.hl7.org/CodeSystem/practitioner-role


ValueSet: PractitionerSpecialtyVS
Id: practitioner-specialty-vs
Title: "Practitioner Specialty ValueSet"
Description: "Specialiteter för hälso- och sjukvårdspersonal (SNOMED CT)."
* ^version = "0.2.0"
* ^status = #draft
* ^experimental = true
* include codes from system http://snomed.info/sct


ValueSet: ProvenanceActivityVS
Id: provenance-activity-vs
Title: "Provenance Activity ValueSet"
Description: "Aktiviteter för provenansregistrering."
* ^version = "0.2.0"
* ^status = #draft
* ^experimental = true
* include codes from system http://terminology.hl7.org/CodeSystem/v3-DataOperation

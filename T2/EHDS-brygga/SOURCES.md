# Externa källförteckning — EHDS-brygga

Förteckning över externa källor som används eller ska användas för krav,
beteckningar, kodverk, profiler och specifikationer.

Underhålls manuellt. Konsulteras av `mapping-scaffolder`, `code-reviewer` och `doc-updater`.

---

## Format

```
### [SRC-NNN] Kortnamn
- **Typ:** spec | profil | kodverk | register | api
- **URL/sökväg:** ...
- **Ägs av:** ...
- **Används för:** ...
- **Lokalt spegel/kopia:** sökväg i repot (om tillämpligt)
- **Notering:** ...
```

---

## Inera — interna källor

### [SRC-001] Inera core-profil (FHIR)
- **Typ:** profil
- **URL:** https://bitbucket.org/ineraservices/ineraservices.bitbucket.io/src/master/core/
- **Ägs av:** Inera
- **Används för:** Validering av FHIR-resurser mot svenska basprofiler för HL7;
  kanoniska URI:er för `http://electronichealth.se/CodeSystem/*` och
  `http://electronichealth.se/identifier/*` kodverk och identifierarsystem.
- **Lokalt spegel/kopia:** —
- **Notering:** Primär källa för att verifiera URI:er märkta
  `"TODO: verifiera URI"` i NamingSystem-filerna. Innehåller StructureDefinitions,
  CodeSystems och ValueSets som definierar Ineras nationella FHIR-baserade dataprofil.

### [SRC-002] Inera terminologitjänst
- **Typ:** api | kodverk
- **URL:** — (TODO: lägg till URL när känd)
- **Ägs av:** Inera
- **Används för:** Auktoritativ källa för OID:ar, kodverk och urval som
  publiceras av Inera; verifiering av `http://electronichealth.se/CodeSystem/*`-URI:er;
  sökning av korrekt OID för poster som saknar eller har misstänkt fel OID
  (se `mappning/EXTERNAL-ISSUES.md`).
- **Lokalt spegel/kopia:** `mappning/NamingSystem/Kodverk, urval och identifierare.md`
  (statisk export, datum okänt)
- **Notering:** Ska konsulteras för att stänga ISSUE-001 t.o.m. ISSUE-009 i EXTERNAL-ISSUES.md.

### [SRC-003] RIV-TA SE-OID-register
- **Typ:** register
- **URL:** https://rivta.se/
- **Ägs av:** Inera / RIV-TA förvaltning
- **Används för:** Kanoniska OID:ar för identifierarsystem (personnummer, HSA-id)
  och tjänstedomäner; underlag för NamingSystem lager 2a.
- **Lokalt spegel/kopia:** —
- **Notering:** Auktoritativ källa för `1.2.752.129.*`-OID:ar.

### [SRC-004] RIV-TA tjänstekontraktsbeskrivningar (TKB)
- **Typ:** spec
- **URL:** https://rivta.se/
- **Ägs av:** Inera / RIV-TA förvaltning
- **Används för:** Källspecifikation för SOAP-elementnamn, XSD-typer och
  kodvärden i lager 3 (YAML-mappning). En TKB per tjänstekontrakt.
- **Lokalt spegel/kopia:** —
- **Notering:** TKB för GetDiagnosis behövs för att färdigställa
  `ConceptMap/GetDiagnosis/` och `mappning/TK/GetDiagnosis/`.

---

## HL7 / FHIR — internationella standarder

### [SRC-005] HL7 FHIR R4 specifikation
- **Typ:** spec
- **URL:** https://hl7.org/fhir/R4/
- **Ägs av:** HL7 International
- **Används för:** Resursstrukturer (Condition, Observation, m.fl.),
  operationer (`$translate`), terminologibindningar.
- **Lokalt spegel/kopia:** —
- **Notering:** —

### [SRC-006] HL7 v3 OID-register
- **Typ:** register
- **URL:** https://www.hl7.org/oid/
- **Ägs av:** HL7 International
- **Används för:** Kanoniska OID:ar för HL7 v3-kodsystem (t.ex. RoleClass,
  AddressPartType, AdministrativeSex). Se ISSUE-007 i EXTERNAL-ISSUES.md
  för möjlig felaktig OID `2.16.840.1.133883.18.2` (rätt: `2.16.840.1.113883.18.2`).
- **Lokalt spegel/kopia:** —
- **Notering:** —

### [SRC-007] HL7 Terminology (THO)
- **Typ:** kodverk
- **URL:** https://terminology.hl7.org/
- **Ägs av:** HL7 International
- **Används för:** Standardkodsystem i ConceptMap-mål, t.ex.
  `condition-category`, `condition-clinical`, `v3-AdministrativeGender`.
- **Lokalt spegel/kopia:** —
- **Notering:** —

---

## Svenska nationella kodsystem

### [SRC-008] ICD-10-SE (Socialstyrelsen)
- **Typ:** kodverk
- **URL:** https://www.socialstyrelsen.se/statistik-och-data/klassifikationer-och-koder/icd-10-se/
- **Ägs av:** Socialstyrelsen
- **Används för:** Diagnoskodsystem; OID `1.2.752.116.1.1.1.1.3`;
  URI `http://hl7.org/fhir/sid/icd-10-se`.
- **Lokalt spegel/kopia:** `mappning/NamingSystem/naming-system-icd-10-se-socialstyrelsen.json`
- **Notering:** —

### [SRC-009] KVÅ (Klassifikation av vårdåtgärder, Socialstyrelsen)
- **Typ:** kodverk
- **URL:** https://www.socialstyrelsen.se/statistik-och-data/klassifikationer-och-koder/kva/
- **Ägs av:** Socialstyrelsen
- **Används för:** Åtgärdskoder; OID `1.2.752.129.2.2.2.1`; se ISSUE-001.
- **Lokalt spegel/kopia:** `mappning/NamingSystem/ns-kva.json`
- **Notering:** OID-kollision med "Kv informationstyp" — se EXTERNAL-ISSUES.md ISSUE-001.

### [SRC-010] SNOMED CT SE (SNOMED International / Socialstyrelsen)
- **Typ:** kodverk
- **URL:** https://www.snomed.org/ ; https://www.socialstyrelsen.se/
- **Ägs av:** SNOMED International (licens via Socialstyrelsen)
- **Används för:** Kliniska begrepp; OID `1.2.752.116.2.21`;
  URI `http://snomed.info/sct`.
- **Lokalt spegel/kopia:** `mappning/NamingSystem/naming-system-snomed-ct-se.json`
- **Notering:** —

### [SRC-011] NPL (Nationellt produktregister för läkemedel)
- **Typ:** kodverk | register
- **URL:** https://www.lakemedelsverket.se/
- **Ägs av:** Läkemedelsverket
- **Används för:** Läkemedelsproduktkoder; OID `1.2.752.129.2.1.3.4`.
- **Lokalt spegel/kopia:** `mappning/NamingSystem/naming-system-npl.json`
- **Notering:** —

### [SRC-012] NPU (Nomenclature for Properties and Units)
- **Typ:** kodverk
- **URL:** https://www.labterm.dk/
- **Ägs av:** Labterm (danskt-nordiskt samarbete)
- **Används för:** Laboratorieanalykoder; OID `1.2.208.176.2.1`.
- **Lokalt spegel/kopia:** `mappning/NamingSystem/naming-system-npu.json`
- **Notering:** —

### [SRC-013] ATC (Anatomical Therapeutic Chemical)
- **Typ:** kodverk
- **URL:** https://www.who.int/tools/atc-ddd-toolkit/atc-classification
- **Ägs av:** WHO / WHOCC
- **Används för:** Läkemedelsklassificering; OID `2.16.840.1.113883.6.73`;
  URI `http://www.whocc.no/atc`.
- **Lokalt spegel/kopia:** `mappning/NamingSystem/naming-system-atc.json`
- **Notering:** —

---

## Infrastruktur och EHDS

### [SRC-014] EHDS-förordningen (EU 2025/327)
- **Typ:** spec
- **URL:** https://eur-lex.europa.eu/legal-content/SV/TXT/?uri=CELEX:32025R0327
- **Ägs av:** Europeiska unionen
- **Används för:** Primärt kravunderlag för EHDS-bryggan; definierar
  MyHealth@EU, EHR-utbyte och datakategorier.
- **Lokalt spegel/kopia:** —
- **Notering:** —

### [SRC-015] MyHealth@EU teknisk specifikation (epSOS/eHDSI)
- **Typ:** spec
- **URL:** https://www.ehdsi.eu/ ; https://art-decor.org/mediawiki/index.php/MyHealth@EU
- **Ägs av:** EU-kommissionen / eHealth Network
- **Används för:** Utbytesformat och profiler för patientöversikt (PS),
  läkemedelslista (ePrescription), laboratorieresultat m.m.
- **Lokalt spegel/kopia:** —
- **Notering:** —

---

## Status för URI-verifiering

Följande URI-prefix används i NamingSystem-filerna och ska verifieras mot SRC-001 och SRC-002:

| Prefix | Antal filer | Källa att verifiera mot |
|--------|-------------|------------------------|
| `http://electronichealth.se/CodeSystem/` | ~80 | SRC-001, SRC-002 |
| `http://electronichealth.se/identifier/` | ~10 | SRC-001, SRC-002 |
| `http://hl7.org/fhir/sid/` | ~5 | SRC-005 |
| `http://snomed.info/sct` | 1 | SRC-010 |
| `http://www.whocc.no/atc` | 1 | SRC-013 |
| `https://www.riv.se/` | ~5 | SRC-003 |

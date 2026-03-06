# URI-verifieringsanalys — NamingSystem-filer

Analys av de ~119 NamingSystem-filer som är märkta `"TODO: verifiera URI"`.
Beskriver källhierarki, vad som kunde verifieras publikt och vad som kräver
åtkomst till terminologitjänsten.

**Datum:** 2026-03-06
**Status:** Partiell — terminologitjänsten kräver autentisering.

---

## Källhierarki för URI-verifiering

```
Prioritet  Källa                                  Täckning
─────────────────────────────────────────────────────────────────────
1 (högst)  HL7 Sweden basprofiler (SRC-016)        Identifierarsystem
           github.com/HL7Sweden/basprofiler-r4

2          Inera core-profil (SRC-001)              5 CodeSystem + vägledning
           bitbucket.org/ineraservices/...core/

3          Inera terminologitjänst (SRC-002)        ALLA Inera-specifika CodeSystem
           terminologitjansten.inera.se/fhir/       ← kräver autentisering/VPN

4          RIV-TA OID-register (SRC-003)            OID:ar (inte URI:er)
```

---

## Terminologitjänstens struktur

Ineras terminologitjänst exponerar ett FHIR R4 REST-API:

| Endpoint | Beskrivning |
|----------|-------------|
| `GET /fhir/CodeSystem?_count=N` | Söka/lista kodverk |
| `GET /fhir/CodeSystem/{id}` | Hämta enskilt kodverk |
| `GET /fhir/CodeSystem?identifier=urn:oid:{OID}` | Slå upp via OID |
| `GET /fhir/ValueSet?_count=N` | Söka/lista urval |
| `GET /fhir/NamingSystem?_count=N` | Lista identifierarsystem |
| `POST /fhir/CodeSystem/$lookup` | Slå upp enskild kod |

**Åtkomst:** Returnerar HTTP 403 från öppet internet. Kräver troligen
Inera-nätverksåtkomst (VPN) och/eller autentiseringstoken (SMART on FHIR
eller API-nyckel). Se SRC-002 i SOURCES.md — URL till auth-dokumentation saknas.

**URI-mönster i tjänsten:** Från Inera core-profil (SRC-001) kan vi se att
ICD-10-SE:s kanoniska URL i terminologitjänsten är:
```
https://terminologitjansten.inera.se/inera-kodverksforvaltning/kodverk/icd-10-se
```
Det är oklart om `http://electronichealth.se/CodeSystem/*`-URI:erna
är alias i samma tjänst eller ett äldre URI-mönster.

---

## Inera core-profil (Bitbucket)

Katalogen `core/` innehåller **5 CodeSystem-filer** (inte 100+):

| Fil | URL i resursen | OID |
|-----|----------------|-----|
| `CodeSystem-icd-10-se-cs.json` | `https://terminologitjansten.inera.se/inera-kodverksforvaltning/kodverk/icd-10-se` | saknas i fil |
| `CodeSystem-organization-hsaid-system-cs.json` | `https://inera.se/fhir/core/CodeSystem/organization-hsaid-system-cs` | saknas |
| `CodeSystem-organization-number-system-cs.json` | `https://inera.se/fhir/core/CodeSystem/organization-number-system-cs` | `1.2.752.29.4.3`, `2.5.4.97` |
| `CodeSystem-section-presentation-style.json` | `https://inera.se/fhir/core/CodeSystem/section-presentation-style` | saknas |
| `CodeSystem-section-semantic-type.json` | `https://inera.se/fhir/core/CodeSystem/section-semantic-type` | saknas |

Vägledningsdokument `guidance-common/`:
- `swedish-identifiers.md` — URI:er för identifierarsystem
- `tkb-mapping-intro.md` — introduktion till TKB-mappning

---

## Vad HL7 Sweden basprofiler bekräftar

Från `input/fsh/Aliases.fsh` i `HL7Sweden/basprofiler-r4` (paket v1.1.0):

### Bekräftade URI:er för identifierarsystem

| Identifierarsystem | URI (bekräftad) | Vår fil | Status |
|--------------------|-----------------|---------|--------|
| Personnummer | `http://electronichealth.se/identifier/personnummer` | ns-personnummer.json | ✅ KORREKT |
| Samordningsnummer | `http://electronichealth.se/identifier/samordningsnummer` | — | ✅ (ej mappningsrelevant än) |
| LMA-nummer | `http://electronichealth.se/identifier/LMA-nummer` | — | ✅ (ej mappningsrelevant än) |

### OID-avvikelse för HSA-id

| Källa | OID | URI |
|-------|-----|-----|
| HL7 Sweden basprofiler | `1.2.752.29.4.19` | *(OID-format används direkt)* |
| Inera core-profil (org-hsaid-system-cs) | — | `http://terminology.hl7.se/sid/se-hsaid-organization` / `se-hsaid-careunit` |
| Vår ns-hsa-id.json (RIV-TA) | `1.2.752.129.2.1.4.1` | `https://www.riv.se/...` |

**Slutsats HSA-id:** Tre inkonsekventa källor. OID `1.2.752.29.4.19` (HL7 Sweden)
och `1.2.752.129.2.1.4.1` (RIV-TA/Inera) är troligen *olika ändamål*:
- `1.2.752.29.4.19` = HSA-id för fysiska enheter (Skatteverket-registrerade)
- `1.2.752.129.2.1.4.1` = HSA-id som används i RIV-TA `enhets-id/@root`
Kräver verifiering mot terminologitjänst eller Inera förvaltning.

### Yrkeskodverk — OID, inte electronichealth.se-URI

HL7 Sweden basprofiler använder OID-format direkt för dessa:

| Basprofil-alias | OID | Vår URI (TODO) |
|-----------------|-----|----------------|
| `$legitimation` | `urn:oid:1.2.752.116.3.1.1` | — |
| `$prescriber` | `urn:oid:1.2.752.116.3.1.2` | — |
| `$occupations` | `urn:oid:1.2.752.116.3.1.3` | `http://electronichealth.se/CodeSystem/legitimationsyrke` |

> **Observation:** Basprofilen definierar `$legitimation` (OID `.3.1.1`) och
> `$occupations` (OID `.3.1.3`) separat, medan vår naming-system-legitimationsyrke.json
> har OID `1.2.752.116.3.1.3`. Klargör om legitimationsyrke = occupations.

---

## ICD-10-SE: URI-konflikt

| Källa | URI |
|-------|-----|
| Internationell HL7 (FHIR R4) | `http://hl7.org/fhir/sid/icd-10-se` |
| Inera core-profil (terminologitjänst) | `https://terminologitjansten.inera.se/inera-kodverksforvaltning/kodverk/icd-10-se` |
| Vår ns-icd-10-se.json | `http://hl7.org/fhir/sid/icd-10-se` |

**Rekommendation:** Behåll `http://hl7.org/fhir/sid/icd-10-se` för EHDS-bryggan
eftersom utbyte med MyHealth@EU sker i ett internationellt FHIR-sammanhang.
Terminologitjänstens URL är Ineras interna FHIR-serverinstans, inte en
kanonisk URI för utbyte.

---

## Sammanfattning: verifieringsstatus per URI-grupp

| URI-grupp | Antal filer | Status | Kräver |
|-----------|-------------|--------|--------|
| `http://electronichealth.se/identifier/personnummer` | 1 | ✅ Bekräftad (HL7 SE) | — |
| `http://hl7.org/fhir/sid/icd-10-se` | 1 | ✅ Korrekt (internationell) | — |
| `http://snomed.info/sct` | 1 | ✅ Korrekt (internationell) | — |
| `http://www.whocc.no/atc` | 1 | ✅ Korrekt (WHO) | — |
| `http://terminology.hl7.org/CodeSystem/v3-*` | 2 | ✅ Korrekt (HL7 THO) | — |
| `https://www.riv.se/.../hsa-id` (ns-hsa-id.json) | 1 | ⚠️ Konflikt med HL7 SE | Terminologitjänst/förvaltning |
| `http://electronichealth.se/CodeSystem/*` | ~100 | ❓ Okänd | **Terminologitjänst (kräver VPN/auth)** |
| `http://electronichealth.se/identifier/npl` | 1 | ❓ Okänd | Terminologitjänst |
| `http://npu-terminology.org` | 1 | ❓ Okänd | Labterm.dk |
| `http://iso639-3.sil.org` | 1 | ✅ Korrekt (SIL) | — |
| `urn:ietf:bcp:13` (MIME-typer) | 1 | ✅ Korrekt (IETF) | — |

---

## Nästa steg för att verifiera resterande ~100 filer

### Alternativ 1: REST-anrop mot terminologitjänsten (rekommenderat)

```bash
# Söka CodeSystem via OID
curl -H "Authorization: Bearer {TOKEN}" \
  "https://terminologitjansten.inera.se/fhir/CodeSystem?identifier=urn:oid:1.2.752.129.2.2.1.1"

# Lista alla CodeSystem
curl -H "Authorization: Bearer {TOKEN}" \
  "https://terminologitjansten.inera.se/fhir/CodeSystem?_count=200&_format=json"
```

Lämplig som ett engångsskript som:
1. Itererar alla naming-system-*.json med TODO
2. Slår upp varje OID mot terminologitjänstens `/fhir/CodeSystem?identifier=urn:oid:{OID}`
3. Jämför returnerad `url`-fält mot vår URI
4. Uppdaterar filen och tar bort TODO-kommentaren om de stämmer överens

### Alternativ 2: Manuell kontroll via terminologitjänstens webbgränssnitt

Om terminologitjänsten har ett webbgränssnitt (t.ex. HAPI FHIR-gränssnitt),
kan varje OID sökas manuellt. Praktiskt för enstaka verifieringar men
inte skalbart för 100 filer.

### Alternativ 3: Kontrollera mot `http://hl7.se/fhir/ig/base/`

Publikt åtkomlig officiell IG-sida. Kan innehålla NamingSystem-resurser
för svenska identifierare och kodsystem som används i basprofiler.

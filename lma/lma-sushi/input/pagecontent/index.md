### LMA API-standard – FHIR Implementation Guide

**Version:** 0.1.0-draft &nbsp;|&nbsp; **Canonical:** `https://sis.se/fhir/lma` &nbsp;|&nbsp; **FHIR R4** (4.0.1)
{:.stu-note}

> **Status:** Detta dokument är ett arbetsutkast framtaget av arbetsgruppen för SIS/TR
> Läkemedelsautomater. Det är inte ett godkänt SIS-dokument.

### Syfte

Denna FHIR Implementation Guide specificerar hur informationsmodellen i SIS/TR
*API-standard för läkemedelsautomater* realiseras med HL7 FHIR R4. IG:n riktar sig
till systemutvecklare och integratörer som implementerar datautbyte mot LMA-plattformar.

IG:n är normativ för den tekniska FHIR-implementeringen. Standarden är normativ för
informationsmodellens semantik, lagkrav och terminologi.

### Scope

Kärnprofilerna täcker de transaktioner som definieras i standardens kapitel 7.
Larmhanteringslager (option) profileras inte i denna version.

### Paketinformation

| | |
|--|--|
| Paket-id | `sis.se.tk334.ag10.lma` |
| FHIR-version | R4 (4.0.1) |
| Utgivare | SIS/TR – Arbetsgrupp Läkemedelsautomater |
| Canonical | `https://sis.se/fhir/lma` |

### Komma igång

1. Läs [Bakgrund](background.html) för principiella val och relationer till andra standarder.
2. Granska [Mappning till FHIR](mappings.html) för hur logiska klasser mappar till FHIR-resurser.
3. Implementera mot [profilerna](profiles.html) och validera med HL7 Validator.

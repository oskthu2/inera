# Kända problem i externa dokument och källor

Spårar buggar, oklarheter och avvikelser i externa källor som påverkar mappningsarbetet.
Underhålls av `doc-updater`. Konsulteras av `code-reviewer` och `mapping-scaffolder`.

## Format

```
### [ISSUE-NNN] Kort titel
- **Källa:** URL eller filnamn (t.ex. Bitbucket-sökväg, spec-dokument)
- **Typ:** bugg | otydlighet | avvikelse | saknas
- **Påverkar:** TK-namn eller artefakt
- **Status:** öppen | workaround | stängd
- **Upptäckt:** YYYY-MM-DD av {agent eller användare}
- **Beskrivning:** Vad problemet är och hur det yttrar sig.
- **Workaround:** Hur vi hanterar det tills det är fixat (om relevant).
```

---

## Öppna problem

### [ISSUE-001] OID-kollision: Kv informationstyp och KVÅ delar OID 1.2.752.129.2.2.2.1
- **Källa:** `T2/EHDS-brygga/mappning/NamingSystem/Kodverk, urval och identifierare.md`
- **Typ:** avvikelse
- **Påverkar:** ns-kva.json, NamingSystem-katalogen generellt
- **Status:** workaround
- **Upptäckt:** 2026-03-06 av mapping-scaffolder
- **Beskrivning:** Källfilen listar "Kv informationstyp" (Inera) med OID 1.2.752.129.2.2.2.1, men samma OID används i ns-kva.json för KVÅ (Klassifikation av vårdåtgärder, Socialstyrelsen). Det är oklart om det är samma kodsystem eller en felregistrering i källfilen.
- **Workaround:** Ingen NamingSystem-fil skapades för "Kv informationstyp" för att undvika dubblett. Behöver utredas mot originalkällorna.

### [ISSUE-002] OID-kollision: Kv fakturaformat och Kv kommunal adressbok - Utbildning delar OID 1.2.752.129.5.1.52
- **Källa:** `T2/EHDS-brygga/mappning/NamingSystem/Kodverk, urval och identifierare.md`
- **Typ:** avvikelse
- **Påverkar:** naming-system-kv-fakturaformat.json
- **Status:** workaround
- **Upptäckt:** 2026-03-06 av mapping-scaffolder
- **Beskrivning:** OID 1.2.752.129.5.1.52 används i källfilen för både "Kv fakturaformat" (rad 19) och "Kv kommunal adressbok - Utbildning" (rad 40). En av dem har en felaktig OID. naming-system-kv-fakturaformat.json skapades redan i en tidigare session.
- **Workaround:** Ingen separat fil skapades för "Kv kommunal adressbok - Utbildning". Behöver utredas mot Inera kodverksförvaltning för korrekt OID.

### [ISSUE-003] OID-kollision: Kv samarbetsområde och urval sökord kommunal adressbok utbildning delar OID 1.2.752.129.5.1.54
- **Källa:** `T2/EHDS-brygga/mappning/NamingSystem/Kodverk, urval och identifierare.md`
- **Typ:** avvikelse
- **Påverkar:** naming-system-kv-samarbetsomrade.json, naming-system-urval-sokord-kommunal-adressbok-utbildning.json
- **Status:** workaround
- **Upptäckt:** 2026-03-06 av mapping-scaffolder
- **Beskrivning:** OID 1.2.752.129.5.1.54 används i källfilen för "Kv samarbetsområde" (Ineras kodverk, rad 65) och "urval sökord kommunal adressbok utbildning" (Ineras urval, rad 131). Det är oklart vilket som har rätt OID.
- **Workaround:** Båda filerna skapades med OID-kollisionsnotering i comment-fältet. Behöver utredas mot Inera kodverksförvaltning.

### [ISSUE-004] OID-kollision: HSA Kommunkod och Kv Kommun delar OID 1.2.752.129.2.2.1.17
- **Källa:** `T2/EHDS-brygga/mappning/NamingSystem/Kodverk, urval och identifierare.md`
- **Typ:** otydlighet
- **Påverkar:** naming-system-kv-kommun.json
- **Status:** workaround
- **Upptäckt:** 2026-03-06 av mapping-scaffolder
- **Beskrivning:** OID 1.2.752.129.2.2.1.17 används för "Kv Kommun" (Ineras kodverk) och "Kommunkod" (HSA). Det är troligen samma underliggande SCB-kodverk men det är oklart om det är en identisk representation.
- **Workaround:** En gemensam fil naming-system-kv-kommun.json skapades med notering om kollisionen.

### [ISSUE-005] OID-kollision: HSA Länskod och Kv län delar OID 1.2.752.129.2.2.1.18
- **Källa:** `T2/EHDS-brygga/mappning/NamingSystem/Kodverk, urval och identifierare.md`
- **Typ:** otydlighet
- **Påverkar:** naming-system-kv-lan.json
- **Status:** workaround
- **Upptäckt:** 2026-03-06 av mapping-scaffolder
- **Beskrivning:** OID 1.2.752.129.2.2.1.18 används för "Kv län" (Ineras kodverk) och "Länskod" (HSA). Troligen samma SCB-baserade kodverk.
- **Workaround:** En gemensam fil naming-system-kv-lan.json skapades med notering om kollisionen.

### [ISSUE-006] OID-kollision: HSA Vårdtjänst och Ineras urval vårdtjänst delar OID 1.2.752.129.5.1.19
- **Källa:** `T2/EHDS-brygga/mappning/NamingSystem/Kodverk, urval och identifierare.md`
- **Typ:** avvikelse
- **Påverkar:** naming-system-hsa-vardtjanst.json
- **Status:** workaround
- **Upptäckt:** 2026-03-06 av mapping-scaffolder
- **Beskrivning:** OID 1.2.752.129.5.1.19 används för "Vårdtjänst" (HSA-sektion) och "urval vårdtjänst" (Ineras urval-sektion). Oklart om det är samma kodverk.
- **Workaround:** Filen naming-system-hsa-vardtjanst.json skapades med kollisionsnotering.

### [ISSUE-007] Möjlig felstavad OID för HL7 v2 Administrative Sex i källfilen
- **Källa:** `T2/EHDS-brygga/mappning/NamingSystem/Kodverk, urval och identifierare.md`, rad 158
- **Typ:** bugg
- **Påverkar:** naming-system-hl7-v2-administrative-sex.json
- **Status:** workaround
- **Upptäckt:** 2026-03-06 av mapping-scaffolder
- **Beskrivning:** Källfilen anger OID 2.16.840.1.**133**883.18.2 för HL7 v2 Administrative Sex. Standard HL7-OID-prefixet är 2.16.840.1.**113**883 — det verkar som att ett extra "3" har infogats (133883 istället för 113883). Korrekt OID bör vara 2.16.840.1.113883.18.2.
- **Workaround:** Filen naming-system-hl7-v2-administrative-sex.json skapades med OID från källfilen (2.16.840.1.133883.18.2) men med en varning i comment-fältet.

### [ISSUE-008] OID-kollision: KVÅ har två OID:er (ns-kva.json och Socialstyrelsen)
- **Källa:** `T2/EHDS-brygga/mappning/NamingSystem/Kodverk, urval och identifierare.md`, rad 164; `ns-kva.json`
- **Typ:** avvikelse
- **Påverkar:** naming-system-kva-socialstyrelsen.json, ns-kva.json
- **Status:** workaround
- **Upptäckt:** 2026-03-06 av mapping-scaffolder
- **Beskrivning:** KVÅ verkar ha två OID:er: 1.2.752.116.1.3.2.3.4 (Socialstyrelsen Klassifikationsförvaltningen, enligt källfilen) och 1.2.752.129.2.2.2.1 (ns-kva.json). Båda pekas mot samma URI http://electronichealth.se/id/kva. Oklart om det är samma kodsystem eller om den ena OID:en är föråldrad.
- **Workaround:** Separat fil naming-system-kva-socialstyrelsen.json skapades för Socialstyrelsen-OID:en med kollisionsnotering.

### [ISSUE-009] Många poster i källfilen saknar OID (har UUID, SKV termkod, SCTID, eller "Saknas")
- **Källa:** `T2/EHDS-brygga/mappning/NamingSystem/Kodverk, urval och identifierare.md`
- **Typ:** saknas
- **Påverkar:** NamingSystem-katalogen generellt
- **Status:** öppen
- **Upptäckt:** 2026-03-06 av mapping-scaffolder
- **Beskrivning:** Följande poster har inte skapats som NamingSystem-filer eftersom de saknar OID eller har icke-OID identifierare: UUID-baserade Inera-kodverk (t.ex. Kv detaljer undersökning, Kv dödsorsaksuppgift, Kv händelse m.fl.), SKV termkod-poster (Civilstånd 01081, Folkbokföringstyp 04008 m.fl.), SCTID-poster (Urval deltagandetyper, Urval sambandstyper), samt poster med "Saknas" som ID (t.ex. Distriktskod, DRG produktkod, Kv FKMU 0001-0007, ListingType m.fl.). NamingSystem-strukturen kräver minst ett uniqueId av typ OID eller URI.
- **Workaround:** Inga filer skapades för dessa poster. De behöver antingen en OID tilldelas, eller hanteras med enbart URI som uniqueId.

---

## Stängda problem

*(inga ännu)*

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

### [ISSUE-007] Möjlig felstavad OID för HL7 v2 Administrative Sex i källfilen
- **Källa:** `T2/EHDS-brygga/mappning/NamingSystem/Kodverk, urval och identifierare.md`, rad 158
- **Typ:** bugg
- **Påverkar:** naming-system-hl7-v2-administrative-sex.json
- **Status:** workaround
- **Upptäckt:** 2026-03-06 av mapping-scaffolder
- **Beskrivning:** Källfilen anger OID 2.16.840.1.**133**883.18.2 för HL7 v2 Administrative Sex. Standard HL7-OID-prefixet är 2.16.840.1.**113**883 — det verkar som att ett extra "3" har infogats (133883 istället för 113883). Korrekt OID bör vara 2.16.840.1.113883.18.2.
- **Workaround:** Filen naming-system-hl7-v2-administrative-sex.json skapades med OID från källfilen (2.16.840.1.133883.18.2) men med en varning i comment-fältet.

### [ISSUE-009] Många poster i källfilen saknar OID (har UUID, SKV termkod, SCTID, eller "Saknas")
- **Källa:** `T2/EHDS-brygga/mappning/NamingSystem/Kodverk, urval och identifierare.md`
- **Typ:** saknas
- **Påverkar:** NamingSystem-katalogen generellt
- **Status:** öppen
- **Upptäckt:** 2026-03-06 av mapping-scaffolder
- **Beskrivning:** Följande poster har inte skapats som NamingSystem-filer eftersom de saknar OID eller har icke-OID identifierare: UUID-baserade Inera-kodverk (t.ex. Kv detaljer undersökning, Kv dödsorsaksuppgift, Kv händelse m.fl.), SKV termkod-poster (Civilstånd 01081, Folkbokföringstyp 04008 m.fl.), SCTID-poster (Urval deltagandetyper, Urval sambandstyper), samt poster med "Saknas" som ID (t.ex. Distriktskod, DRG produktkod, Kv FKMU 0001-0007, ListingType m.fl.). NamingSystem-strukturen kräver minst ett uniqueId av typ OID eller URI.
- **Workaround:** Inga filer skapades för dessa poster. De behöver antingen en OID tilldelas, eller hanteras med enbart URI som uniqueId.

### [ISSUE-010] OID-avvikelse: Kv länktyp skiljer sig mellan källfil och terminologitjänst
- **Källa:** `T2/EHDS-brygga/mappning/NamingSystem/Kodverk, urval och identifierare.md` vs `terminologi-export/codesystems-bundle.json`
- **Typ:** avvikelse
- **Påverkar:** naming-system-kv-lanktyp.json
- **Status:** workaround
- **Upptäckt:** 2026-03-07 av mapping-scaffolder (terminologi-verifiering)
- **Beskrivning:** Källfilen (Kodverk, urval och identifierare.md) anger OID `1.2.752.129.2.2.1.1.1` för Kv länktyp, men terminologitjänstens codesystems-bundle.json registrerar samma kodverk under OID `1.2.752.129.2.2.2.1.1` (skillnad i sjätte segment: `.2.2.1.` vs `.2.2.2.`). Det är oklart vilken OID som är korrekt i Ineras OID-register, men terminologitjänstens svar är den auktoritativa källan för faktisk driftsatt URL.
- **Workaround:** naming-system-kv-lanktyp.json uppdaterades med terminologitjänstens OID (`1.2.752.129.2.2.2.1.1`) och bekräftad URI (`https://terminologitjansten.inera.se/inera-kodverksforvaltning/kodverk/kv_lanktyp`). Behöver utredas mot Inera OID-förvaltning för att fastslå vilken OID som är korrekt.

### [ISSUE-011] ICD-10-SE: Terminologitjänsten exponerar annan OID och URL än HL7 FHIR-standard
- **Källa:** `terminologi-export/codesystems-bundle.json`
- **Typ:** avvikelse
- **Påverkar:** naming-system-icd-10-se-socialstyrelsen.json, ns-icd-10-se.json
- **Status:** öppen
- **Upptäckt:** 2026-03-07 av mapping-scaffolder (terminologi-verifiering)
- **Beskrivning:** Terminologitjänstens bundle exponerar ICD-10-SE under OID `1.2.752.116.1.1.1.1.8` med URL `https://terminologitjansten.inera.se/fhir/CodeSystem/icd-10-se`. Våra NamingSystem-filer använder rot-OID `1.2.752.116.1.1.1` (naming-system-icd-10-se-socialstyrelsen.json) och `1.2.752.116.1.1.1.1.3` (ns-icd-10-se.json), båda med kanonisk URI `http://hl7.org/fhir/sid/icd-10-se`. OID `.1.1.8` finns inte i terminologitjänsten under något känt mönster. Det är oklart om terminologitjänstens OID är en lokal variant eller om något av våra OID:er är felaktiga.
- **Workaround:** Inga filer ändrades. Den kanoniska HL7 FHIR-URIn `http://hl7.org/fhir/sid/icd-10-se` behålls som preferred URI eftersom den är internationellt etablerad. Terminologitjänstens URL `https://terminologitjansten.inera.se/fhir/CodeSystem/icd-10-se` kan behöva läggas till som ytterligare uniqueId om den används i praktiken.

### [ISSUE-012] Terminologiverifiering 2026-03-07: sammanfattning av fynd
- **Källa:** `terminologi-export/codesystems-bundle.json` (131 CodeSystem-resurser, exportdatum 2026-03-06)
- **Typ:** avvikelse
- **Påverkar:** NamingSystem-katalogen generellt
- **Status:** workaround
- **Upptäckt:** 2026-03-07 av mapping-scaffolder
- **Beskrivning:** Systematisk verifiering av alla NamingSystem-filer mot terminologitjänstens export genomfördes. Resultat: 52 filer har URI som redan stämmer med terminologitjänsten. 1 fil (kv-lanktyp) hade OID-avvikelse och uppdaterades (se ISSUE-010). 76 filer saknar matchande OID i terminologitjänstens bundle — dessa tillhör externa standarder (HL7, WHO, Socialstyrelsen, HSA) eller kodverk som ännu inte finns i terminologitjänsten. Filen naming-system-urval-sokord-kommunal-adressbok-utbildning.json ändrades inte trots att dess OID matchar kv_samarbetsomrade i terminologitjänsten — detta är den kända OID-kollisionen (ISSUE-003) där terminologitjänstens URL tillhör ett annat kodverk.
- **Workaround:** Se individuella ISSUE-poster. Filer utan match i terminologitjänsten behålls med befintliga URI:er tills extern verifiering kan ske.

---

## Stängda problem

### [ISSUE-004] HSA Kommunkod och Kv Kommun delar OID 1.2.752.129.2.2.1.17
- **Källa:** `T2/EHDS-brygga/mappning/NamingSystem/Kodverk, urval och identifierare.md`
- **Typ:** otydlighet
- **Påverkar:** naming-system-kv-kommun.json
- **Status:** stängd
- **Upptäckt:** 2026-03-06 av mapping-scaffolder
- **Stängd:** 2026-03-15
- **Beskrivning:** OID 1.2.752.129.2.2.1.17 listas under två namn i källfilen ("Kv Kommun" och "Kommunkod" i HSA). Dessa är synonyma namn på samma SCB-baserade kodverk. Eftersom OID:en är den auktoritativa identifieraren är det inte en konflikt — en enda NamingSystem-fil täcker båda namnen.

### [ISSUE-005] HSA Länskod och Kv län delar OID 1.2.752.129.2.2.1.18
- **Källa:** `T2/EHDS-brygga/mappning/NamingSystem/Kodverk, urval och identifierare.md`
- **Typ:** otydlighet
- **Påverkar:** naming-system-kv-lan.json
- **Status:** stängd
- **Upptäckt:** 2026-03-06 av mapping-scaffolder
- **Stängd:** 2026-03-15
- **Beskrivning:** OID 1.2.752.129.2.2.1.18 listas under två namn ("Kv län" och "Länskod" i HSA). Synonyma namn på samma SCB-baserade kodverk. En enda NamingSystem-fil täcker båda.

### [ISSUE-006] HSA Vårdtjänst och Ineras urval vårdtjänst delar OID 1.2.752.129.5.1.19
- **Källa:** `T2/EHDS-brygga/mappning/NamingSystem/Kodverk, urval och identifierare.md`
- **Typ:** otydlighet
- **Påverkar:** naming-system-hsa-vardtjanst.json
- **Status:** stängd
- **Upptäckt:** 2026-03-06 av mapping-scaffolder
- **Stängd:** 2026-03-15
- **Beskrivning:** OID 1.2.752.129.5.1.19 listas under två namn i källfilen ("Vårdtjänst" i HSA-sektionen och "urval vårdtjänst" i urval-sektionen). Synonyma namn på samma kodverk. En enda NamingSystem-fil täcker båda.

### [ISSUE-008] KVÅ har två OID:er (Inera/RIV-TA och Socialstyrelsen)
- **Källa:** `T2/EHDS-brygga/mappning/NamingSystem/Kodverk, urval och identifierare.md`, rad 164; `ns-kva.json`
- **Typ:** avvikelse
- **Påverkar:** ns-kva.json
- **Status:** stängd
- **Upptäckt:** 2026-03-06 av mapping-scaffolder
- **Stängd:** 2026-03-15
- **Beskrivning:** KVÅ har två OID:er — 1.2.752.116.1.3.2.3.4 (Socialstyrelsen Klassifikationsförvaltningen) och 1.2.752.129.2.2.2.1 (Inera/RIV-TA) — båda för samma URI http://electronichealth.se/id/kva. FHIR NamingSystem hanterar detta naturligt med flera uniqueId-poster av typ OID. naming-system-kva-socialstyrelsen.json togs bort och Socialstyrelsen-OID:en lades till direkt i ns-kva.json.

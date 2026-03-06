# Testdata — EHDS-brygga

Testdata för enhetstester och integrationstester av mappningsmotorn.

---

## Mappstruktur

```
testdata/
├── README.md                                (denna fil)
│
├── fixtures/                                Delade FHIR-resurser som används av tester
│   ├── NamingSystem/                        Subset av produktions-NamingSystem för tester
│   │   ├── ns-personnummer.json
│   │   ├── ns-hsa-id.json
│   │   ├── ns-icd-10-se.json
│   │   └── ns-kva.json
│   └── ConceptMap/                          Subset av produktions-ConceptMap för tester
│       ├── cm-diagnos-typ.json
│       └── cm-diagnos-status.json
│
├── GetDiagnosis/                            Testdata per tjänstekontrakt
│   ├── tx06-fhir-to-soap/                   TX-06: FHIR-sökparametrar → SOAP-request
│   │   ├── 01-minimal/
│   │   │   ├── input.json                   FHIR-sökparametrar (patient + onset-date)
│   │   │   └── expected-soap.xml            Förväntad GetDiagnosis SOAP-request
│   │   ├── 02-med-datumintervall/
│   │   │   ├── input.json
│   │   │   └── expected-soap.xml
│   │   └── 03-okant-personnummer-system/
│   │       ├── input.json
│   │       └── expected-error.json          Förväntad OperationOutcome (400)
│   │
│   └── tx09-soap-to-fhir/                   TX-09: SOAP-svar → FHIR Condition[]
│       ├── 01-en-diagnos/
│       │   ├── input-soap.xml               GetDiagnosisResponse (rådata)
│       │   └── expected-fhir.json           Förväntad FHIR Bundle (Condition + Provenance)
│       ├── 02-flera-diagnoser/
│       │   ├── input-soap.xml
│       │   └── expected-fhir.json
│       ├── 03-diagnoser-olika-kodsystem/    ICD-10 + SNOMED CT i samma svar
│       │   ├── input-soap.xml
│       │   └── expected-fhir.json
│       ├── 04-okand-oid/                    OID som saknas i NamingSystem
│       │   ├── input-soap.xml
│       │   └── expected-fhir.json           OID används som system-URI, varning loggas
│       └── 05-tom-lista/
│           ├── input-soap.xml               Tomt GetDiagnosisResponse
│           └── expected-fhir.json           Tom Bundle
```

---

## Konventioner

### input.json (TX-06)
FHIR-sökparametrar som en nyckel-värde-karta:
```json
{
  "patient": "http://electronichealth.se/identifier/personnummer|191212121212",
  "onset-date": "ge2024-01-01"
}
```

### input-soap.xml (TX-09)
Komplett `GetDiagnosisResponse`-kuvert inklusive SOAP-headers, som de tas emot
från producenten.

### expected-fhir.json
FHIR `Bundle` av typ `searchset` med `Condition`- och `Provenance`-resurser.
Dynamiska fält (`id`, `meta.lastUpdated`) kan sättas till statiska testvärden
eller utelämnas och matchas med wildcard i testramverket.

### expected-soap.xml
`GetDiagnosis`-request-elementet (utan SOAP-kuvert) med exakta elementvärden.

### expected-error.json
FHIR `OperationOutcome` med `issue[].severity` och `issue[].details.text`.

---

## Lägg till nytt tjänstekontrakt

1. Skapa katalog `testdata/<TK-namn>/`
2. Skapa underkataloger `tx06-fhir-to-soap/` och/eller `tx09-soap-to-fhir/`
   beroende på vilka riktningar TK:n stöder
3. Namnge scenarier med löpnummer + beskrivande namn (`01-minimal/`, `02-felfall/`)
4. Lägg eventuella delade fixtures i `fixtures/` om de inte redan finns där

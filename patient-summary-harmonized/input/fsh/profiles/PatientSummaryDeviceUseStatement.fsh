Alias: $DeviceKind = http://hl7.org/fhir/ValueSet/device-kind

Profile: IneraEHDSPatientSummaryDeviceUseStatement
Parent: DeviceUseStatement
Id: inera-ehds-patient-summary-device-use-statement
Title: "Inera EHDS Patient Summary DeviceUseStatement (EHDSDeviceUse – Användning av medicinteknisk produkt)"
Description: "Profil för användning av medicinteknisk produkt (EHDSDeviceUse) per Xt-EHR A.1.12. Beskriver ATT en patient använder/har implanterat en medicinteknisk produkt. Refererar till IneraEHDSPatientSummaryDevice (EHDSDevice) som beskriver PRODUKTEN i sig med UDI-identifierare per EU MDR. Harmoniserad mot EPS och EURIDICE resource access. Notering: FHIR R4 = DeviceUseStatement; R4B/R5 = DeviceUsage – profilen kan behöva justeras vid versionsuppgradering."

* ^status = #draft
* ^experimental = false

// SHALL: koppling till patient (Xt-EHR A.1.12 + EURIDICE resource access)
* subject 1..1

// SHALL: status för att förstå om enheten är aktiv, avslutad eller avbruten
* status 1..1

// SHALL: referens till den medicintekniska produkten
// Begränsas till IneraEHDSPatientSummaryDevice (EHDSDevice) för UDI-stöd och EU MDR-compliance
* device 1..1
* device only Reference(IneraEHDSPatientSummaryDevice)

// SHOULD: tidpunkt/period när enheten användes/implanterades
* timing[x] 0..1

// SHOULD: kroppsdel om relevant (t.ex. implantat med lokal)
* bodySite 0..1
* bodySite from http://hl7.org/fhir/ValueSet/body-site (preferred)

// SHOULD: notering om device-kontext
* note 0..*

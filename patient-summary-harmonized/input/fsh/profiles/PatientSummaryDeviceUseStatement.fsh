Alias: $DeviceKind = http://hl7.org/fhir/ValueSet/device-kind

Profile: IneraEHDSPatientSummaryDeviceUseStatement
Parent: DeviceUseStatement
Id: inera-ehds-patient-summary-device-use-statement
Title: "Inera EHDS Patient Summary DeviceUseStatement"
Description: "Profil för medicintekniska produkter och implantat (Xt-EHR A.1.12, IPS Medical Devices). Harmoniserad mot EPS och EURIDICE resource access. Notering: FHIR R4 använder DeviceUseStatement; R4B/R5 använder DeviceUsage – profilen kan behöva justeras vid versionsuppgradering."

* ^status = #draft
* ^experimental = false

// SHALL: koppling till patient (Xt-EHR A.1.12 + EURIDICE resource access)
* subject 1..1

// SHALL: status för att förstå om enheten är aktiv, avslutad eller avbruten
* status 1..1

// SHALL: enhetens identitet och typ
// DeviceUseStatement.device är en Reference(Device); device.type bär den kodade produkttypen
* device 1..1

// SHOULD: tidpunkt/period när enheten användes/implanterades
* timing[x] 0..1

// SHOULD: kroppsdel om relevant (t.ex. implantat med lokal)
* bodySite 0..1
* bodySite from http://hl7.org/fhir/ValueSet/body-site (preferred)

// SHOULD: notering om device-kontext
* note 0..*

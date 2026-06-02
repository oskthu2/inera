Profile: IneraEHDSPatientSummaryDevice
Parent: Device
Id: inera-ehds-patient-summary-device
Title: "Inera EHDS Patient Summary Device (EHDSDevice – Medicinteknisk produkt)"
Description: "Profil för medicinteknisk produkt (EHDSDevice) per Xt-EHR EHDS Patient Summary A.1.12. Beskriver den fysiska enheten med UDI-identifierare (UDI-DI och UDI-PI) per EU MDR 2017/745. Separeras tydligt från EHDSDeviceUse (IneraEHDSPatientSummaryDeviceUseStatement) som beskriver patientens ANVÄNDNING av produkten. Refereras från DeviceUseStatement.device."

* ^status = #draft
* ^experimental = false

// SHALL: produktens typ/kategori (Xt-EHR EHDSDevice.productType)
* type 1..1
* type from http://hl7.org/fhir/ValueSet/device-kind (preferred)

// SHOULD: UDI-bärare med UDI-DI och UDI-PI per EU MDR 2017/745
// UDI-DI: Device Identifier – identifierar modell/version av produkten
// UDI-PI: Production Identifier – identifierar den individuella instansen
//         (kan innehålla serienummer, lotnummer, tillverkningsdatum, utgångsdatum, etc.)
* udiCarrier 0..*
* udiCarrier.deviceIdentifier 0..1     // UDI-DI (modellidentifierare)
* udiCarrier.carrierHRF 0..1          // Mänskligt läsbar representation av UDI

// SHOULD: produktnamn (Xt-EHR EHDSDevice.model / brand name)
* deviceName 0..*
* deviceName.name 1..1
* deviceName.type 1..1

// SHOULD: tillverkare (Xt-EHR EHDSDevice.manufacturer)
* manufacturer 0..1

// SHOULD: modellbeteckning (Xt-EHR EHDSDevice.model)
* modelNumber 0..1

// SHOULD: serienummer per EU MDR UDI-PI (Xt-EHR EHDSDevice.serialNumber)
* serialNumber 0..1

// SHOULD: parti-/lotnummer per EU MDR UDI-PI (Xt-EHR EHDSDevice.lotNumber)
* lotNumber 0..1

// SHOULD: tillverkningsdatum per EU MDR UDI-PI (Xt-EHR EHDSDevice.manufactureDate)
* manufactureDate 0..1

// SHOULD: utgångsdatum per EU MDR UDI-PI (Xt-EHR EHDSDevice.expirationDate)
* expirationDate 0..1

// SHOULD: programvaru-/hårdvaruversion (Xt-EHR EHDSDevice.version)
* version 0..*

// SHOULD: notering om produkten
* note 0..*

// ============================================================================
// ENHETSLAGER – CodeSystems
// ============================================================================

CodeSystem: LMADriftsstatus
Id: lma-driftsstatus
Title: "LMA Driftsstatus"
Description: """Driftsstatus för läkemedelsautomat. **Enhetslager.**
Rapporteras av automaten och avser enhetens egna drifttillstånd,
oberoende av omvårdnadsflöden. (IHE SDPi/BICEPS: MDib OperatingMode)"""
* #operationell "Operationell" "Automaten är i drift och fungerar normalt."
* #ur-drift "Ur drift" "Automaten är tillfälligt ur drift."
* #service "Service" "Automaten genomgår planerat underhåll eller service."
* #bortkopplad "Bortkopplad" "Automaten är permanent bortkopplad eller avvecklad."
* #okant "Okänt" "Driftsstatusen kan inte fastställas."


CodeSystem: LMAAnslutningsstatus
Id: lma-anslutningsstatus
Title: "LMA Anslutningsstatus"
Description: """Kommunikationsstatus för läkemedelsautomat mot LMA-plattformen.
**Enhetslager.** Rapporteras av plattformen baserat på nätverksobservation.
(IHE SDPi/BICEPS: BICEPS MDib ConnectedState)"""
* #ansluten "Ansluten" "Automaten kommunicerar normalt med LMA-plattformen."
* #frankapplad "Frånkopplad" "Kommunikation med automaten kan inte etableras."
* #intermittent "Intermittent" "Kommunikation med automaten är instabil eller tidvis avbruten."
* #okand "Okänd" "Anslutningsstatusen kan inte fastställas."


CodeSystem: LMAKopplingsstatus
Id: lma-kopplingsstatus
Title: "LMA Kopplingsstatus"
Description: "Status för kopplingen brukare–automat. **Enhetslager.**"
* #aktiv "Aktiv" "Kopplingen är aktiv och brukaren har en pågående insats med aktuell automat."
* #avslutad "Avslutad" "Kopplingen är avslutad."
* #pausad "Pausad" "Kopplingen är tillfälligt inaktiverad."


CodeSystem: LMAOverlamningstfall
Id: lma-overlamningstfall
Title: "LMA Överlämningsutfall"
Description: "Utfall av automatens överlämning av läkemedel. Enhetslager."
* #lyckad "Lyckad" "Automaten överlämnade läkemedlet till brukaren inom schemalagt toleransfönster."
* #misslyckad "Misslyckad" "Automaten misslyckades med att överlämna läkemedlet."
* #okant "Okänt" "Utfallet av överlämnandet är okänt."


CodeSystem: LMAOverlamninsfelkod
Id: lma-overlamninsfelkod
Title: "LMA Överlämningsfelkod"
Description: """Felkod för misslyckad överlämning. **Enhetslager.**
Tekniska felkoder från automaten. Ska **inte** förekomma i
MedicationAdministration.statusReason (omvårdnadslagret)."""
* #mekaniskt-fel "Mekaniskt fel" "Fel i automatens mekaniska komponenter förhindrade överlämnandet."
* #produkt-slut "Produkt slut" "Automaten saknar läkemedel för det aktuella administreringstillfället."
* #sensorfel "Sensorfel" "Sensorfel förhindrade verifiering av att överlämnandet genomförts."
* #okant "Okänt" "Felets orsak är okänd."


// ============================================================================
// OMVÅRDNADSLAGER – CodeSystems
// ============================================================================

CodeSystem: LMAAdministreringsstatus
Id: lma-administreringsstatus
Title: "LMA Administreringsstatus"
Description: """Status för läkemedelsadministrering. **Omvårdnadslager.**
Dokumenteras av hälso- och sjukvårdspersonal. (HSLF-FS 2016:40)"""
* #genomford "Genomförd" "Läkemedlet administrerades till brukaren."
* #ej-genomford "Ej genomförd" "Läkemedelsadministreringen genomfördes inte."
* #avbruten "Avbruten" "Läkemedelsadministreringen påbörjades men avbröts."
* #okant "Okänt" "Det är okänt om administreringen genomfördes."


CodeSystem: LMAAdministreringsorsak
Id: lma-administreringsorsak
Title: "LMA Administreringsorsak"
Description: """Orsak till utebliven eller avbruten läkemedelsadministrering.
**Omvårdnadslager.** Bedöms och dokumenteras av hälso- och sjukvårdspersonal."""
* #brukare-avbojde "Brukare avböjde" "Brukaren avböjde att ta emot läkemedlet. Omvårdnadsbedömning krävs."
* #brukare-ej-antraffad "Brukare ej anträffad" "Brukaren var inte anträffbar vid administreringstillfället. Omvårdnadsbedömning krävs."
* #medicinsk-orsak "Medicinsk orsak" "En medicinsk orsak förhindrade administreringen. Bedöms av ansvarig hälso- och sjukvårdspersonal."
* #okant "Okänt" "Orsaken är okänd."

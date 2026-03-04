// ============================================================================
// ENHETSLAGER – ValueSets
// ============================================================================

ValueSet: VSDriftsstatus
Id: VS-Driftsstatus
Title: "VS Driftsstatus"
Description: "Driftsstatus för läkemedelsautomat. Enhetslager."
* include codes from system LMADriftsstatus


ValueSet: VSAnslutningsstatus
Id: VS-Anslutningsstatus
Title: "VS Anslutningsstatus"
Description: "Anslutningsstatus för läkemedelsautomat mot LMA-plattformen. Enhetslager."
* include codes from system LMAAnslutningsstatus


ValueSet: VSKopplingsstatus
Id: VS-Kopplingsstatus
Title: "VS Kopplingsstatus"
Description: "Status för kopplingen brukare–automat. Enhetslager."
* include codes from system LMAKopplingsstatus


ValueSet: VSOverlamningstfall
Id: VS-Overlamningstfall
Title: "VS Överlämningsutfall"
Description: "Utfall av automatens överlämning av läkemedel. Enhetslager."
* include codes from system LMAOverlamningstfall


ValueSet: VSOverlamninsfelkod
Id: VS-Overlamninsfelkod
Title: "VS Överlämningsfelkod"
Description: "Teknisk felkod vid misslyckad överlämning. Enhetslager."
* include codes from system LMAOverlamninsfelkod


// ============================================================================
// OMVÅRDNADSLAGER – ValueSets
// ============================================================================

ValueSet: VSAdministreringsstatus
Id: VS-Administreringsstatus
Title: "VS Administreringsstatus"
Description: "Status för läkemedelsadministrering. Omvårdnadslager."
* include codes from system LMAAdministreringsstatus


ValueSet: VSAdministreringsorsak
Id: VS-Administreringsorsak
Title: "VS Administreringsorsak"
Description: "Orsak till utebliven eller avbruten läkemedelsadministrering. Omvårdnadslager."
* include codes from system LMAAdministreringsorsak

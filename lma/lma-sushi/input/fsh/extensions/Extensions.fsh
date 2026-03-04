// ============================================================================
// ext-lma-batch
// Batchnummer på SupplyDelivery. LVFS 2012:14.
// ============================================================================
Extension: ExtLmaBatch
Id: ext-lma-batch
Title: "LMA Batchnummer"
Description: """Batchnummer (lottnummer) för det läkemedel som fylldes på i
automaten. Krävs för spårbarhet vid läkemedelsåterkallelse per LVFS 2012:14.

Batchnumret tillhandahålls av apoteket/dosaktören och registreras vid påfyllnad."""
* ^context.type = #element
* ^context.expression = "SupplyDelivery"
* value[x] 1..1
* value[x] only string
* valueString ^short = "Batchnummer / lottnummer"
* valueString ^comment = "Format definierat av tillverkaren. LVFS 2012:14."

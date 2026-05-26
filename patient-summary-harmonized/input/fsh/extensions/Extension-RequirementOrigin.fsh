Extension: IneraRequirementOrigin
Id: inera-requirement-origin
Title: "Requirement Origin"
Description: "Markerar ursprung för harmoniseringsregel (EURIDICE, EPS, Xt-EHR, Nationell)."

* ^status = #draft
* ^context[0].type = #element
* ^context[0].expression = "Element"

* value[x] only CodeableConcept
* valueCodeableConcept 1..1

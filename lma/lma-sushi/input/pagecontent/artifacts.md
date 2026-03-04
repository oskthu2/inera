### Alla artefakter

Samtliga FHIR-artefakter i IG-paketet `sis.se.tk334.ag10.lma`.

### StructureDefinitions – Profiler

{% include list-profiles.xhtml %}

### StructureDefinitions – Extensions

{% include list-extensions.xhtml %}

### CodeSystems

{% include list-codesystems.xhtml %}

### ValueSets

{% include list-valuesets.xhtml %}

### Exempelinstanser

Exempelinstanser listas på den automatgenererade [artifacts.html](artifacts.html).

### Validering

Validera en resursinstans mot en LMA-profil med HL7 FHIR Validator:

```bash
java -jar validator_cli.jar \
  -version 4.0.1 \
  -ig sis.se.tk334.ag10.lma \
  -profile https://sis.se/fhir/lma/StructureDefinition/LMALakemedelsoverlamnande \
  example-overlamnande.json
```

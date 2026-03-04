# build-ig.ps1
# Bygger FHIR IG med HL7s officiella Docker-image

$projectPath = "C:\Users\svrost\LMA\lma-sushi"
$image = "hl7fhir/ig-publisher-base:latest"
$publisherJar = "$projectPath\publisher.jar"

# Ladda ner publisher.jar om den inte finns
if (-not (Test-Path $publisherJar)) {
    Write-Host "Laddar ner publisher.jar från HL7..."
    Invoke-WebRequest -Uri "https://github.com/HL7/fhir-ig-publisher/releases/latest/download/publisher.jar" -OutFile $publisherJar
    Write-Host "publisher.jar nedladdad."
}

# Kör IG Publisher via Docker
Write-Host "Bygger FHIR IG med Docker..."
docker run --rm -v "${projectPath}:/work" -w /work $image java -jar /work/publisher.jar -ig ig.ini -tx n/a

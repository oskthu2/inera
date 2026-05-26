#!/usr/bin/env bash
set -euo pipefail

repo_root="${1:-$(pwd)}"
output_root="${repo_root}/.pages"
pages_title="${PAGES_TITLE:-Implementation Guides}"
# "n/a" is supported by IG Publisher to disable external terminology server lookups.
terminology_server="${TERMINOLOGY_SERVER:-n/a}"
ig_publisher_image="${IG_PUBLISHER_IMAGE:?IG_PUBLISHER_IMAGE environment variable is required}"
sushi_npm_package="${SUSHI_NPM_PACKAGE:-fsh-sushi@3.19.0}"
publisher_jar_url="${PUBLISHER_JAR_URL:-https://github.com/HL7/fhir-ig-publisher/releases/download/2.2.8/publisher.jar}"

html_escape() {
  local value="${1}"
  value="${value//&/&amp;}"
  value="${value//</&lt;}"
  value="${value//>/&gt;}"
  value="${value//\"/&quot;}"
  value="${value//\'/&#39;}"
  printf '%s' "${value}"
}

escaped_pages_title="$(html_escape "${pages_title}")"

mapfile -t ig_dirs < <(
  find "${repo_root}" -type f -name "ig.ini" -not -path "*/template/*" -print0 \
    | xargs -0 -n1 dirname \
    | sort -u
)

if [ "${#ig_dirs[@]}" -eq 0 ]; then
  echo "No IG projects found (no ig.ini files)." >&2
  exit 1
fi

rm -rf "${output_root}"
mkdir -p "${output_root}"

index_file="${output_root}/index.html"
cat > "${index_file}" <<HTML
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>${escaped_pages_title}</title>
  </head>
  <body>
    <h1>${escaped_pages_title}</h1>
    <ul>
HTML

for ig_dir in "${ig_dirs[@]}"; do
  relative_path="${ig_dir#${repo_root}/}"
  destination_dir="${output_root}/${relative_path}"
  ig_title="${relative_path}"

  echo "Building ${relative_path}"
  if ! docker run --rm \
    -v "${ig_dir}:/work" \
    -w /work \
    -e "TERMINOLOGY_SERVER=${terminology_server}" \
    -e "SUSHI_NPM_PACKAGE=${sushi_npm_package}" \
    -e "PUBLISHER_JAR_URL=${publisher_jar_url}" \
    --entrypoint bash \
    "${ig_publisher_image}" \
    -lc 'set -euo pipefail
      export PATH="/usr/local/openjdk-23/bin:${PATH}"
      if ! command -v sushi >/dev/null; then
        npm install -g "${SUSHI_NPM_PACKAGE}" >/dev/null
      fi
      mkdir -p input-cache
      if [ ! -f input-cache/publisher.jar ]; then
        curl -fsSL "${PUBLISHER_JAR_URL}" -o input-cache/publisher.jar
      fi
      java -jar input-cache/publisher.jar -ig ig.ini -tx "${TERMINOLOGY_SERVER}"'; then
    echo "IG Publisher failed for ${relative_path}" >&2
    exit 1
  fi

  if [ ! -d "${ig_dir}/output" ]; then
    echo "Missing output directory for ${relative_path}" >&2
    exit 1
  fi

  mkdir -p "${destination_dir}"
  cp -a "${ig_dir}/output/." "${destination_dir}/"

  escaped_path="$(html_escape "${relative_path}")"
  escaped_title="$(html_escape "${ig_title}")"
  printf '      <li><a href="./%s/index.html">%s</a></li>\n' "${escaped_path}" "${escaped_title}" >> "${index_file}"
done

cat >> "${index_file}" <<'HTML'
    </ul>
  </body>
</html>
HTML

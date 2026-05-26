#!/usr/bin/env bash
set -euo pipefail

repo_root="${1:-$(pwd)}"
output_root="${repo_root}/.pages"
pages_title="${PAGES_TITLE:-Implementation Guides}"
terminology_server="${TERMINOLOGY_SERVER:-n/a}"

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
    <title>${pages_title}</title>
  </head>
  <body>
    <h1>${pages_title}</h1>
    <ul>
HTML

for ig_dir in "${ig_dirs[@]}"; do
  relative_path="${ig_dir#${repo_root}/}"
  destination_dir="${output_root}/${relative_path}"

  echo "Building ${relative_path}"
  docker run --rm \
    -v "${ig_dir}:/work" \
    -w /work \
    hl7fhir/ig-publisher-base:latest \
    java -jar /usr/local/bin/publisher.jar -ig ig.ini -tx "${terminology_server}"

  if [ ! -d "${ig_dir}/output" ]; then
    echo "Missing output directory for ${relative_path}" >&2
    exit 1
  fi

  mkdir -p "${destination_dir}"
  cp -a "${ig_dir}/output/." "${destination_dir}/"

  printf '      <li><a href="./%s/index.html">%s</a></li>\n' "${relative_path}" "${relative_path}" >> "${index_file}"
done

cat >> "${index_file}" <<'HTML'
    </ul>
  </body>
</html>
HTML

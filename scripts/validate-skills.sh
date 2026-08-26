#!/usr/bin/env bash

set -euo pipefail

repository_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
cd "$repository_root"

errors=0

report_error() {
  printf 'ERROR: %s\n' "$1" >&2
  errors=$((errors + 1))
}

required_files=(
  README.md
  CONTRIBUTING.md
  LICENSE
  CODE_OF_CONDUCT.md
  SECURITY.md
  GOVERNANCE.md
  SUPPORT.md
  .github/CODEOWNERS
  .github/PULL_REQUEST_TEMPLATE.md
  templates/skill/SKILL.md
  examples/custom-skill/SKILL.md
)

for file in "${required_files[@]}"; do
  if [[ ! -s "$file" ]]; then
    report_error "required file is missing or empty: $file"
  fi
done

while IFS= read -r file; do
  report_error "empty file: ${file#./}"
done < <(find . -type f -not -path './.git/*' -empty -print)

validate_frontmatter() {
  local file=$1
  local closing_line
  local name
  local description

  if [[ $(sed -n '1p' "$file") != '---' ]]; then
    report_error "$file must start with YAML frontmatter"
    return
  fi

  closing_line=$(awk 'NR > 1 && $0 == "---" { print NR; exit }' "$file")
  if [[ -z "$closing_line" ]]; then
    report_error "$file has no closing YAML frontmatter delimiter"
    return
  fi

  name=$(sed -n "2,$((closing_line - 1))p" "$file" | sed -n 's/^name:[[:space:]]*//p' | head -n 1)
  description=$(sed -n "2,$((closing_line - 1))p" "$file" | sed -n 's/^description:[[:space:]]*//p' | head -n 1)

  if [[ ! "$name" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
    report_error "$file has an invalid lowercase kebab-case name: $name"
  elif (( ${#name} > 64 )); then
    report_error "$file has a name longer than 64 characters"
  fi

  if (( ${#description} < 25 )); then
    report_error "$file must have a meaningful description"
  fi
}

skill_count=0
skill_names_file=$(mktemp)
trap 'rm -f "$skill_names_file"' EXIT

while IFS= read -r file; do
  skill_count=$((skill_count + 1))
  validate_frontmatter "$file"

  directory_name=$(basename "$(dirname "$file")")
  skill_name=$(awk 'NR > 1 && $0 == "---" { exit } /^name:[[:space:]]*/ { sub(/^name:[[:space:]]*/, ""); print; exit }' "$file")

  if [[ "$skill_name" != "$directory_name" ]]; then
    report_error "$file name '$skill_name' does not match directory '$directory_name'"
  fi

  printf '%s\n' "$skill_name" >> "$skill_names_file"
done < <(find skills -mindepth 3 -maxdepth 3 -type f -name SKILL.md | sort)

if (( skill_count == 0 )); then
  report_error 'no skills were found under skills/<category>/<skill>/SKILL.md'
fi

while IFS= read -r directory; do
  if [[ ! -f "$directory/SKILL.md" ]]; then
    report_error "$directory does not contain SKILL.md"
  fi
done < <(find skills -mindepth 2 -maxdepth 2 -type d | sort)

duplicates=$(sort "$skill_names_file" | uniq -d)
if [[ -n "$duplicates" ]]; then
  report_error "duplicate skill names: $duplicates"
fi

while IFS= read -r file; do
  validate_frontmatter "$file"
done < <(find templates examples -type f -name SKILL.md | sort)

if ! grep -Fqx '**Status:** Draft' templates/skill/SKILL.md; then
  report_error 'the reusable skill template must have Status: Draft'
fi

if ! grep -Fqx '**Status:** Example' examples/custom-skill/SKILL.md; then
  report_error 'the illustrative skill must have Status: Example'
fi

while IFS= read -r match; do
  report_error "trailing whitespace: $match"
done < <(grep -RInE '[[:blank:]]+$' --exclude-dir=.git . || true)

if (( errors > 0 )); then
  printf '\nValidation failed with %d error(s).\n' "$errors" >&2
  exit 1
fi

printf 'Validation passed for %d skills.\n' "$skill_count"

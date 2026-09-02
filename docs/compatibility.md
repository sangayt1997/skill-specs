# Compatibility

The repository's canonical format is one self-contained Markdown file per skill at `skills/<category>/<skill-name>/SKILL.md`. The file begins with YAML frontmatter containing `name` and `description`, followed by portable Markdown instructions. A skill directory contains no companion files, metadata, scripts, assets, or nested directories.

Agents may support richer package formats, invocation metadata, or auxiliary resources, but those extensions are outside this repository's portable format. Consumers must be able to use the core guidance from `SKILL.md` alone. Compatibility details for individual agents will be added as integrations are tested.

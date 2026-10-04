---
name: keep-a-changelog
description: Write, update, or review CHANGELOG.md entries using Keep a Changelog conventions. Use when documenting notable project changes, preparing a release section, or checking changelog quality; not for raw commit logs or standalone marketing announcements.
---

# Keep a Changelog

Write for people upgrading or using the project. Follow the repository's instructions and existing style.

## Gather evidence

Read the changelog, applicable AGENTS.md, and the relevant diff or release range. Confirm the resulting behavior in source when the diff alone is unclear. Distinguish this task's changes from unrelated work already present. Never invent effects, release dates, versions, links, contributor credits, or security identifiers.

## Curate entries

Record notable outcomes, not a list of commits. Combine related changes and omit routine internal cleanup unless repository instructions require it. Describe the affected feature and why the change matters in plain language.

Use these categories:

| Category | Meaning |
| --- | --- |
| Added | A new capability |
| Changed | Existing behavior intentionally differs |
| Deprecated | A capability is scheduled for withdrawal |
| Removed | A capability has been withdrawn |
| Fixed | Incorrect behavior now works correctly |
| Security | A vulnerability is addressed |

Keep only populated categories. Preserve existing ordering; for a new file, use the order above. Categorize dependency updates by their relevant effect.

Mark incompatible changes with `**Breaking:**` inside their category and identify the affected interface. Give a short upgrade instruction or link to a migration guide. Lead security entries with a known CVE and link to an available advisory. Announce deprecations before removal; name the removal version only when established.

## Maintain structure

Keep pending entries under `Unreleased`, above released versions in newest-first order. Release headings include the version and actual date in `YYYY-MM-DD` form. Retain withdrawn releases with `[YANKED]`.

For a new changelog, start with `# Changelog`, a short purpose statement, and links identifying the format and the project's actual versioning scheme. Do not assume SemVer.

When preparing an authorized release, move its pending entries into the dated version and retain a fresh `Unreleased` section. Use verified tags and repository URLs for reference links: previous tag to release tag, latest tag to HEAD for Unreleased, and the oldest release's tag page.

Keep historical entries intact during ordinary updates. Correct history only when requested or supported by evidence; adopting newer guidance does not require reformatting old releases.

## Review the result

Check category choice, duplicate entries, factual support, Markdown spacing, dates, and reference-link definitions. Ensure the wording is understandable without source-code knowledge. Report unresolved facts rather than guessing. Preparing the file does not authorize tagging or publishing a release.

For AMAI, use the root CHANGELOG.md and retain established component labels such as `(Installer)`. Describe gameplay or installer behavior rather than JASS implementation details.

## Sources

- [Requested upstream example](https://github.com/olivierlacan/keep-a-changelog/blob/main/CHANGELOG.md): a living changelog, not the specification itself.
- [Keep a Changelog 2.0 guidance](https://keepachangelog.com/en/2.0.0/): consult for advanced cases or interpretation.
- [Keep a Changelog 1.1 guidance](https://keepachangelog.com/en/1.1.0/): consult when a repository follows that edition.

Use these conventions locally; browsing is needed when checking new upstream guidance, not for every entry.

# Quality Standard

Before a planned skill becomes production-ready, reviewers must be able to answer yes to the applicable checks below.

## Scope and Discovery

- Does the description clearly identify capability and activation scope?
- Is the responsibility cohesive and meaningfully distinct from existing skills?
- Are exclusions included only where they prevent likely misuse?

## Correctness and Actionability

- Are instructions technically correct and specific enough to change decisions?
- Are MUST, SHOULD, and MAY requirements used consistently?
- Are important trade-offs, exceptions, and failure modes represented?
- Does the skill preserve user intent, project context, and authorization boundaries?
- Is verification proportional to the risk and observable where possible?

## Clarity and Context Cost

- Is generic or repeated advice removed?
- Are examples realistic and included only when useful?
- Is conditional detail organized clearly without fragmenting the skill?
- Is the complete skill self-contained in its sole `SKILL.md`?

## Maintainability

- Does the skill avoid unnecessary dependencies and brittle tool assumptions?
- Would a future contributor understand why non-obvious constraints exist?
- Are framework-specific claims compatible with the versions in scope?
- Does repository validation pass?

Automated checks confirm structure, not behavioral quality. A Code Owner must review production-ready skills and material changes against this standard.

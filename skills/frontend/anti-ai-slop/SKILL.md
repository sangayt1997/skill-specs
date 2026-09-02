---
name: anti-ai-slop
description: Design, review, or refactor frontend interfaces to replace generic, template-like decisions with product-specific hierarchy, content, and interaction. Apply when UI is described as AI-generated, bland, interchangeable, over-carded, or visually derivative; preserve useful conventions and accessibility rather than pursuing novelty for its own sake.
---

# Anti-AI-Slop

Produce interfaces whose important decisions follow from the product, users, content, and operating context. Treat “AI slop” as unexplained sameness, not as a fixed visual style.

A familiar pattern is not automatically generic. A card, gradient, centered hero, sidebar, or sans-serif typeface may be appropriate when it serves the content and interaction. Conversely, unusual decoration does not make an interface intentional. Distinctiveness must improve recognition, comprehension, task flow, or brand expression.

## Boundaries

- Preserve the user's explicit brief, chosen aesthetic, product claims, and scope.
- In an existing product, preserve established visual and interaction conventions unless redesign is requested or evidence shows that a convention is causing harm.
- Do not invent product facts, customer quotes, metrics, integrations, awards, or capabilities to make a design feel complete.
- Do not trade away accessibility, platform expectations, or task clarity for novelty.
- Use the dedicated accessibility skill for a full accessibility implementation or audit. This skill still requires accessibility not to regress.

## Establish Product Truth

Before choosing a composition, determine as much of the following as the brief and project reveal:

- the user and the concrete job they are trying to complete;
- the surface's primary outcome and next action;
- the content users compare, edit, decide from, or return to;
- task frequency, urgency, expertise, and appropriate information density;
- real content shapes, including long, short, missing, loading, empty, error, and permission-limited states;
- platform, viewport, input, localization, performance, and accessibility constraints; and
- incumbent brand assets, tokens, components, typography, and interaction patterns.

Inspect representative implementation and rendered UI when available. Do not infer the whole visual system from one component. If essential product information is missing, make the smallest reversible assumption and identify it; do not fill the gap with a stock SaaS composition.

Write a one-sentence design thesis before substantial implementation. It should connect product truth to a visual or interaction rule, for example:

> Make review status and source-to-translation relationships visually dominant; keep project administration compact and secondary.

Avoid theses made only of mood adjectives such as “clean, modern, premium.” They do not constrain decisions.

## Diagnose Before Redesigning

When reviewing existing UI, identify observable symptoms and user impact. Classify findings by:

1. information architecture and task flow;
2. hierarchy and composition;
3. content and terminology;
4. interaction and state behavior;
5. responsive behavior and density;
6. typography, color, surfaces, and iconography; and
7. decorative treatment and motion.

Prioritize structural problems before cosmetic ones. For each material finding, state:

- what is visible in the interface;
- why it weakens comprehension, efficiency, trust, or product identity;
- which product evidence supports changing it; and
- the smallest coherent correction.

Do not label a choice “AI-generated” merely because it is common. Name the actual problem: equal visual weight, redundant containment, vague copy, unsupported decoration, mismatched density, missing states, or another observable issue.

## Build the Design Grammar

Choose a small, coherent set of rules before styling individual components:

- **Hierarchy:** what must be noticed first, second, and only on demand;
- **Composition:** how scale, placement, rhythm, and whitespace express that priority;
- **Density:** how much information the task requires at each viewport;
- **Typography:** roles for display, headings, body, labels, data, and annotations;
- **Surfaces:** when content is open, divided, inset, elevated, or overlaid;
- **Shape:** a restrained radius and geometry language;
- **Color:** semantic roles plus a product-appropriate brand expression;
- **Imagery and icons:** what evidence, atmosphere, or recognition they contribute;
- **Motion:** which state or spatial relationship it explains; and
- **Motif:** at most one or two recurring product-specific ideas.

A motif may come from the product's material, workflow, domain, data, history, or brand assets. Repeat it with discipline. Do not scatter unrelated visual tricks across the page.

Vary composition where content importance varies, but keep controls and reusable primitives consistent. Distinctiveness should live mainly in hierarchy, content, art direction, data treatment, and a few recognizable details—not in reinventing basic controls.

## Choose Components From Behavior

Select a component because its behavior matches the user's task:

- use tables or aligned rows for repeated comparison;
- use lists for sequential scanning;
- use cards for independent objects or groups that genuinely need bounded identity;
- use tabs for a small set of peer views whose context should remain stable;
- use disclosure for secondary content users can safely defer;
- use dialogs for brief, focused interruptions; and
- keep essential instructions and actions visible rather than hiding them in tooltips.

Prefer native elements and established interaction models. A component library supplies behavior and primitives, not product identity. Extend its tokens and compositions coherently instead of applying random variants per instance.

### Containment gate

Before adding a border, background, radius, or shadow, identify the boundary it communicates. Good reasons include independent selection, grouping, elevation, drag affordance, temporary overlay, or contrast against a changing background.

If spacing, alignment, typography, a divider, or a section background communicates the same structure more clearly, use the lighter treatment. Nested containers need separate reasons at each level.

### Decoration gate

Before adding a gradient, glow, illustration, icon tile, badge, texture, or animation, identify its job. It should support at least one of:

- brand recognition or art direction;
- content meaning or data encoding;
- affordance or status;
- hierarchy or spatial orientation; or
- feedback for an interaction.

Remove it when its only justification is that the screen felt empty. Empty space can be intentional; weak hierarchy cannot.

## Common Failure Modes

Treat these as diagnostic signals, not universal bans:

- a landing page assembled from badge, oversized centered headline, two calls to action, screenshot, equal feature cards, testimonials, pricing, FAQ, and final call to action regardless of the buying journey;
- a dashboard assembled from sidebar, header, four metrics, chart, activity feed, and quick actions regardless of the operator's decisions;
- every section enclosed in the same rounded card, flattening hierarchy into repeated boxes;
- decorative pills, status badges, icons in colored squares, shadows, or gradients repeated without semantic roles;
- arbitrary three- or four-column symmetry for content with unequal importance;
- oversized headings and excessive whitespace that reduce useful density in operational interfaces;
- purple-blue “technology” palettes, dark navy canvases, or neon glows selected without brand or content rationale;
- generic claims such as “unlock,” “revolutionize,” “supercharge,” “seamless,” or “all-in-one” where concrete product language is available;
- placeholder-perfect layouts that fail with real names, values, translations, errors, or record counts;
- desktop layouts merely stacked on mobile without reprioritizing tasks and actions;
- motion applied uniformly to make static content feel sophisticated; and
- novelty that changes familiar controls, hides labels, weakens focus, or obscures the next action.

When one of these patterns is justified by the brief, content, or design system, keep it. Improve its execution rather than replacing it solely to appear different.

## Content Is Interface

Use concrete nouns, active verbs, and terms the intended users recognize. Labels and headings should describe purpose or outcome. Operational UI should report actual state and next action; marketing UI should make only supportable claims.

Replace generic copy with product evidence:

- “Review 3 untranslated keys” is more actionable than “Supercharge your localization workflow.”
- “Import a CSV” is more useful than “Get started effortlessly.”

Do not manufacture specificity. When real content is unavailable, use clearly provisional examples that exercise realistic lengths and states.

## Responsive and Interaction Quality

Adapt the workflow, not only the geometry. At each supported size, decide what remains primary, what moves closer to its object, what can be disclosed later, and what interaction model must change. Preserve content and functionality unless an explicitly equivalent path exists.

Implement the states that make the feature credible: default, hover where relevant, focus, pressed, selected, disabled, loading, empty, partial, error, success, and permission-limited. Add optimistic behavior only when failure and recovery are handled.

Motion should explain cause, feedback, or spatial continuity. Respect reduced-motion preferences. Avoid staggered entrances, floating surfaces, parallax, and perpetual effects unless they serve the intended experience and remain performant and accessible.

## Verification

Verify the result in a bounded pass using rendered interfaces and realistic content where possible.

### Product-specificity check

- Can a reviewer identify what this product helps people do from the hierarchy and content?
- Could the same layout and copy be swapped into several unrelated products with only nouns and colors changed?
- Does at least one important compositional decision follow from the product's actual workflow or content?

If the interface fails the swap test, strengthen product structure or content before adding decoration.

### Hierarchy and restraint check

- Is the primary action or information clear without relying on a colored container around every section?
- Do equal-looking elements have equal importance?
- Does each card, pill, icon, shadow, gradient, and animation have a named role?
- Can any element be removed without losing meaning, affordance, feedback, or identity?

Inventory repeated treatments when overuse is suspected, but do not enforce arbitrary numeric caps.

### Reality check

- Exercise representative long, short, missing, empty, loading, error, and dense states.
- Check narrow and wide layouts, zoom or text enlargement, and relevant input methods.
- Confirm that content does not clip, actions do not disappear, and reading and focus order remain logical.

### Accessibility and convention check

- Preserve semantic structure, accessible names, keyboard operation, visible focus, sufficient contrast, target usability, and reduced-motion behavior.
- Confirm that visual novelty has not changed a familiar component's meaning or expected operation.
- Do not claim accessibility conformance from visual inspection or automation alone.

### Final rationale

Be able to explain every prominent decision through at least one of: user need, content, interaction, context, brand, platform convention, or accessibility. If the only explanation is “modern interfaces look like this,” reconsider it.

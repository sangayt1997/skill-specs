---
name: accessibility
description: Design, implement, test, or review web interfaces for people using keyboards, assistive technologies, zoom, alternative input, or adapted display settings. Apply when UI structure, content, forms, media, interaction, focus, or visual presentation can affect accessible use; do not claim conformance from automated checks alone.
---

# Accessibility

Build interfaces that people can perceive, understand, navigate, and operate across diverse abilities and technologies. Preserve the user's requested product and visual intent while making access requirements part of the implementation, not a late overlay.

Use the project's stated accessibility target. If none exists, use WCAG 2.2 Level AA as the practical review baseline while clearly distinguishing a review against selected criteria from a formal conformance claim.

## Working Method

1. Identify users, tasks, content, platforms, supported browsers, and the applicable standard or policy.
2. Inspect rendered semantics and interactions, not only component source.
3. Prefer native HTML and platform behavior before adding ARIA or custom keyboard handling.
4. Define names, roles, states, relationships, focus movement, errors, and announcements for every interactive state.
5. Verify layout and content under zoom, reflow, text spacing, contrast modes, reduced motion, and asynchronous updates.
6. Test critical journeys with keyboard, automated analysis, accessibility APIs, and representative assistive technology.
7. Fix root causes in shared primitives where safe, then retest affected variants and consumers.
8. Report verified results, residual risks, environmental limits, and any criteria not tested.

Do not redesign unrelated UI, install tooling, or change the support policy without authorization. When requirements conflict, explain the user impact and offer the smallest compliant alternative.

## Non-Negotiable Guardrails

- **MUST** preserve or improve accessible names, roles, values, states, relationships, focus order, and keyboard operation.
- **MUST** make all functionality available without a pointer unless the function inherently depends on path-based or multipoint input.
- **MUST** provide visible focus and must not hide focus behind sticky content or modal layers.
- **MUST** associate errors and instructions with the relevant controls and preserve entered data after validation failures.
- **MUST NOT** use positive `tabindex` values to repair visual or DOM ordering.
- **MUST NOT** add ARIA that conflicts with native semantics or omit required behavior for the declared role.
- **MUST NOT** communicate meaning through color, position, shape, sound, animation, or hover alone.
- **MUST NOT** claim WCAG conformance based only on linting, browser audits, or other automated tools.
- **SHOULD** keep DOM, reading, focus, and visual order aligned.
- **SHOULD** treat accessibility regressions in reusable components as high-blast-radius defects.

## Semantics First

Choose the HTML element whose built-in meaning and behavior match the task:

- headings for document hierarchy;
- landmarks such as `header`, `nav`, `main`, and `footer` for regions;
- links for navigation and buttons for actions;
- lists for grouped items;
- tables for genuinely tabular relationships;
- labels, fieldsets, legends, and native controls for forms; and
- `dialog`, `details`, `summary`, and other native elements when their support fits the target environment.

Do not turn a `div` or `span` into a control when a native element works. Native controls provide semantics, focusability, keyboard activation, form behavior, and platform integration that custom code otherwise has to reproduce.

Use ARIA only to express semantics that HTML cannot. Confirm the role supports the attributes used, provide all required states and owned elements, and implement the complete interaction model. Remember that ARIA changes accessibility-tree exposure, not visual behavior, focus movement, input handling, or validation.

Avoid redundant or invalid roles. Test the computed accessibility tree because source markup can differ from what browsers expose.

## Structure and Navigation

- Provide a descriptive page title and one clear primary heading.
- Use heading levels to represent hierarchy; do not choose levels for font size.
- Label repeated landmarks when users must distinguish them.
- Provide a bypass mechanism such as a skip link when repeated content precedes the main task.
- Use descriptive link text that remains meaningful out of context.
- Identify the current page, step, item, or navigation state programmatically when relevant.
- Keep repeated navigation and controls in a consistent relative order.
- Provide more than one way to locate pages in larger sites when required, such as navigation plus search or a site map.

Client-side navigation must update the document title, expose the new content, and place or preserve focus deliberately. Do not announce every route change if title and focus management already communicate it effectively.

## Accessible Names and Descriptions

Every interactive element needs a stable, concise accessible name describing its purpose.

Prefer naming sources in this order when appropriate:

1. visible text or an explicitly associated `<label>`;
2. `aria-labelledby` referencing visible content; and
3. `aria-label` when no suitable visible label exists.

Ensure the accessible name contains the visible label so speech-input users can invoke what they see. Avoid duplicate labels such as “Read more” when context does not disambiguate them.

Use descriptions for supplemental instructions, constraints, status, or errors—not to replace the name. Keep referenced IDs unique and present. Icon-only controls need a meaningful name; decorative icons inside named controls should not add duplicate speech.

Alternative text should convey an image's purpose in context. Use empty `alt` for decorative images, concise equivalent text for informative images, and nearby structured explanation for complex charts. Do not repeat adjacent captions or filenames.

## Keyboard Interaction

Test every interaction using only the keyboard:

- `Tab` and `Shift+Tab` move between components in a logical order;
- native controls retain expected `Enter`, `Space`, arrow, and escape behavior;
- focus never becomes trapped except inside a correctly implemented modal context;
- hidden, disabled, inert, or off-screen content is not accidentally tabbable;
- pointer-only hover content is also available through focus and dismissible; and
- keyboard shortcuts do not conflict with browser, operating-system, or assistive-technology commands.

For composite widgets such as tabs, menus, listboxes, grids, trees, and radio groups, follow the established WAI-ARIA pattern. Usually one element participates in the page tab sequence while arrow keys move within the composite. Do not improvise a familiar widget's key model.

When keyboard handling listens on a container, check event target, modifier keys, composition state, and whether native behavior should remain. Avoid global shortcuts while a user types unless explicitly required and safely scoped.

## Focus Management

Focus is the user's current point of interaction; selection is a separate state.

- Keep a visible focus indicator with sufficient contrast and area.
- Do not remove outlines unless replacing them with an equally robust indicator.
- Move focus only when context changes would otherwise strand or confuse the user.
- On opening a modal, focus an appropriate element inside; contain navigation; support dismissal; and restore focus to the trigger or a logical successor.
- After destructive removal, place focus on a nearby meaningful control or heading.
- After failed submission, focus an error summary or the first invalid field according to the flow, and provide links or associations to each error.
- For dynamically inserted content, decide whether it needs focus, a live announcement, both, or neither.

Do not focus a disabled, hidden, inert, or absent element. Account for animation and unmount timing without arbitrary delays. Preserve focus through rerenders and list updates using stable identity.

## Forms and Validation

- Give every input a persistent visible label.
- Group related fields with `fieldset` and `legend` or equivalent semantics.
- Communicate required state and expected format in text and programmatically.
- Use appropriate input types, autocomplete tokens, input modes, and browser semantics.
- Do not use placeholder text as the only label or instruction.
- Identify errors in text, associate them with fields, and set invalid state when applicable.
- Provide an error summary for long or multi-field forms.
- Allow review, correction, and confirmation for legal, financial, account, or destructive submissions as required.
- Avoid unnecessary repeated entry; support password managers and paste unless a justified security model prohibits it.

Validate on the server for correctness and mirror helpful checks on the client. Do not announce validation on every keystroke when it creates noise. Preserve user values and focus after errors.

## Dynamic Content and Announcements

Use live regions sparingly for status that appears without focus movement.

- Use `role="status"` or polite announcements for non-urgent completion and updates.
- Reserve alerts or assertive announcements for urgent information requiring immediate attention.
- Put the live-region container in the DOM before changing its content when the platform requires it.
- Announce the outcome, not implementation details.
- Prevent duplicate announcements caused by rerenders or simultaneous regions.

Loading indicators should expose busy state and, for longer operations, meaningful progress. If content refreshes frequently, give users a way to pause or control it where needed.

## Dialogs, Popovers, and Layered UI

For modal content:

- provide an accessible name and optional description;
- move focus inside on open and keep background content inert;
- support expected dismissal unless the flow must require a decision;
- prevent background scrolling without moving the user's viewport unexpectedly; and
- restore focus and state on close.

Choose initial focus based on task and content. For a short confirmation, the safest action may be appropriate; for long or structured content, focus a static heading with `tabindex="-1"` so reading starts at the beginning.

Tooltips cannot contain essential interactive content and must appear on keyboard focus as well as hover. Menus, listboxes, dialogs, and tooltips are different patterns; choose by behavior rather than appearance.

## Visual Presentation and Reflow

- Meet the applicable text, non-text, focus, and state contrast requirements.
- Preserve information in forced-colors and high-contrast modes; do not rely on background images alone.
- Support text resizing and browser zoom without clipping, overlap, or loss of controls.
- Reflow narrow viewports without requiring two-dimensional scrolling except for content that inherently needs it.
- Allow increased line height, paragraph spacing, letter spacing, and word spacing.
- Keep touch and pointer targets large enough and sufficiently separated for the applicable target.
- Do not lock orientation unless essential.

Avoid CSS that changes visual order independently of DOM order. Validate responsive variants because WCAG conformance covers each automatically presented variation of a page.

## Motion, Time, and Input

Honor `prefers-reduced-motion`; replace nonessential movement with a stable transition or no animation. Avoid content that flashes above safe thresholds. Provide controls to pause, stop, or hide moving and auto-updating content when required.

Do not require dragging, complex paths, multipoint gestures, device motion, or precise pointer input when a simple alternative can provide the same function. Ensure cancellation or undo for pointer actions where applicable.

Warn users about time limits, allow extension where required, and preserve work across reauthentication. Never use animation as the only status signal.

## Media and Documents

For prerecorded or live media, provide captions, transcripts, audio description, or alternatives according to the content and conformance target. Controls must be keyboard accessible, named, and operable with assistive technology. Avoid autoplay with sound; provide pause and volume control.

Ensure embedded documents and third-party widgets are included in the accessibility scope. If they cannot meet requirements, document the limitation, pursue a conforming alternative, and do not silently exclude them from a conformance claim.

## Component and Design-System Contracts

Reusable components should encode accessibility defaults:

- semantic element and supported polymorphism;
- naming requirements;
- keyboard and focus behavior;
- roles, states, and relationships;
- disabled versus read-only behavior;
- contrast, zoom, forced-colors, and motion behavior;
- error and status presentation; and
- tested browser and assistive-technology combinations.

Prevent unsafe composition where practical, but do not hide required content behind magic props. Document what consumers must provide. Test every size, state, theme, responsive form, and composition that changes semantics.

## Testing Strategy

Use complementary methods; no single tool is sufficient.

### Static and Automated Checks

Run existing lint rules, component analyzers, browser accessibility audits, and automated WCAG checks. These efficiently detect missing names, invalid ARIA, contrast failures, and structural errors, but cannot determine whether labels are meaningful, focus moves sensibly, or a task is usable.

### Keyboard and Visual Checks

Complete critical journeys without a pointer. Inspect focus visibility/order, traps, skip links, popovers, validation, dynamic changes, zoom, reflow, text spacing, contrast modes, reduced motion, and touch targets.

### Accessibility-Tree and Assistive-Technology Checks

Inspect computed names, roles, states, descriptions, and relationships in browser tools. Test representative journeys with supported screen reader/browser combinations, and include speech input, switch access, magnification, or mobile screen readers when audience and risk warrant them.

Do not treat one screen reader as proof across platforms. Record browser, operating system, assistive technology, version, viewport, and input method.

### User Testing

For high-impact products or novel interactions, include people with disabilities in research and usability testing. Automated and expert review cannot fully predict lived experience.

## Regression Prevention

- Test semantic output and user behavior rather than internal implementation.
- Add focused automated coverage for accessible names, states, relationships, focus restoration, and keyboard operations.
- Keep representative accessibility journeys in integration or end-to-end tests.
- Review dependency upgrades that change DOM, portals, focus, or announcements.
- Centralize proven primitives for dialogs, form fields, notifications, and composite widgets.

Avoid snapshot-only accessibility tests and brittle assertions over the entire accessibility tree. Keep manual test instructions for behavior automation cannot establish.

## Review Output

Report findings with enough detail to reproduce and prioritize them:

```text
Accessibility finding:
- User impact and affected task:
- Standard or requirement:
- Location and state:
- Reproduction with input/assistive technology:
- Actual and expected behavior:
- Recommended fix:
- Verification performed:
- Residual risk or untested combinations:
```

Rank by user impact, task criticality, reach, and regression risk—not only conformance level. Separate confirmed failures from recommendations and uncertain compatibility observations.

## Completion Checklist

Before finishing:

1. Verify semantics, names, roles, states, relationships, and document structure.
2. Complete critical tasks by keyboard with visible, logical focus.
3. Test forms, errors, live updates, overlays, and navigation state.
4. Check contrast, zoom, reflow, text spacing, forced colors, reduced motion, and responsive variants.
5. Run automated tools and representative assistive-technology checks.
6. Confirm fixes do not change authorized product behavior or weaken security.
7. Report the exact scope tested and do not overstate conformance.

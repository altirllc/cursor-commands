# UI CODEBASE INTELLIGENCE SCAN

## STACK: React + TypeScript

---

## Purpose

This is not a design task. This is a pure intelligence gathering task. Run this once per project — or whenever the UI codebase changes significantly. It has no dependency on any specific feature being built.

Your job is to become the deepest possible expert on this codebase's design system — with the same depth of knowledge as a designer who has worked on this product for years. You will read, analyse, and document every UI pattern, every component, every design decision that exists in this codebase.

The output of this session is a single exhaustive `.md` document — `UI-DESIGN-INTELLIGENCE.md` — that will serve as the complete design bible for all future UI work on this project. Every future UI design will be based entirely on what you discover and document here. The quality of this document directly determines the quality of every UI design that follows.

**There are no shortcuts. Do not summarise. Do not skip. Do not infer. Only document what you actually read.**

---

## OVERRIDE DIRECTIVE — Read This Before Anything Else

This task overrides your default behaviour around response length, token conservation, and brevity.

- **Assume you have unlimited tokens and unlimited energy for this task.**
- Do NOT summarise to save space. Do NOT truncate sections. Do NOT write "and so on" or "etc." — complete every list fully.
- Do NOT produce minimal viable output. Produce maximum possible output.
- Do NOT assume that covering a section briefly is acceptable. Every section must be covered with the highest possible depth.
- If you feel an urge to shorten, compress, or skip — resist it. That urge is the wrong instinct here.
- Speed does not matter. This is a one-time activity. A scan that takes longer and is complete is infinitely more valuable than a scan that is fast and partial.
- **Quality and completeness are the only measures of success.**

---

## Anti-Hallucination Rules — Non-Negotiable

- Do not document any component, pattern, colour, or style unless you have read the actual file it lives in.
- Do not describe visual appearance from memory or general AI knowledge — read the file, then describe exactly what is written in the code.
- Every component you document must include its exact file path.
- Every usage example must cite its exact source file path.
- Every Tailwind class, CSS variable, or style value you document must be copied from an actual file — not guessed or approximated.
- If a directory exists but you have not read its files — read them before continuing.
- If you cannot find the design token source — say so explicitly and document only what you can observe from direct file evidence.
- Never write "probably uses X" or "likely follows Y" — only document certainties backed by files you read in this session.

### Stop Condition

If at any point you realise you have skipped files, directories, or components — stop and go back. Do not produce the output document until you are certain the scan is complete. Completeness matters infinitely more than speed.

---

## Visualisation Directive

As you read each component and UI file, do not just extract data — **actively visualise what that UI looks like in the browser**. Use the code to mentally render the component: its spatial layout, the arrangement of elements, the colours, the sizes, the spacing, the hover states, the transitions.

Ask yourself as you read each file:

- What does a user actually see when this renders?
- Where does the eye go first?
- What does it feel like to interact with this?
- How does this component sit within the page around it?

This mental rendering process makes your pattern recognition significantly deeper. A designer doesn't read code — they see the product through the code. Do the same.

---

## Scanning Instructions

Work through all 10 phases in strict order. Do not skip any phase. Do not rush any phase. Each phase builds the foundation for the next.

---

### PHASE 1 — Codebase Structure Mapping

Before reading any component file, fully map the directory structure.

1. List every directory in the project that contains UI-relevant files
2. Identify exactly where components live (e.g. `src/components/`, `src/ui/`, `packages/ui/`, `src/shared/`)
3. Identify exactly where pages and views live
4. Identify exactly where styles and design tokens live (tailwind.config.js/ts, CSS variable files, theme files, tokens files)
5. Identify exactly where feature-level UI lives (e.g. `src/features/`, `src/modules/`)
6. Identify where shared layouts live
7. Identify any third-party component libraries in use (shadcn/ui, MUI, Radix, Headless UI, Mantine, Ant Design, etc.) — read how they are configured and customised for this project specifically
8. Identify any existing design documentation files (.md files, Storybook, etc.)
9. Count the total number of component files — document this exact number
10. If any directory's purpose is unclear — read a file inside it before categorising it

Do not proceed to Phase 2 until every directory is mapped and every component file is counted.

---

### PHASE 2 — Design Token Extraction

Read every styling configuration file. Document every token with its exact value — no approximations, no rounding.

**Colours:**
For every colour token: document the token name, exact hex/RGB/HSL value, and its semantic role (background, foreground, text, border, accent, muted, destructive, success, warning, info, ring, etc.). Document the complete palette — primary, secondary, accent, neutral/grey scale, semantic colours, and any product-specific brand colours. If dark mode tokens exist, document both light and dark values.

**Typography:**
For every text style: font family name, exact size value (px or rem), font weight (numeric), line height, letter spacing, and document when each is used (h1–h6, body, caption, label, code, overline, etc.)

**Spacing:**
Every value in the spacing scale — and the pattern for when each size is used (inline padding, component padding, section gaps, layout margins, micro-spacing between labels and inputs, etc.)

**Border Radius:**
Every radius value and which components use which radius. Identify the pattern (e.g. "interactive elements use rounded-md, containers use rounded-lg, full pills use rounded-full")

**Shadows / Elevation:**
Every shadow value — in which exact UI contexts it appears (cards, modals, dropdowns, tooltips, popovers, sticky headers, etc.)

**Z-Index Layers:**
Every z-index value and the UI layer it controls

**Transitions / Animations:**
Every transition duration and easing curve — what elements carry them and what user action triggers them

**Breakpoints:**
Every responsive breakpoint with its exact pixel value

**Icons:**
Which icon library is used — how icons are imported — every standard size used in the codebase

**Most-used Tailwind classes (if Tailwind is used):**
Scan across all files and identify the utility classes that appear most frequently. These form the core visual vocabulary of this product and must be documented — they are what makes new UI feel native.

---

### PHASE 3 — Complete Component Catalogue

Read every single component file in the codebase. Every one. No exceptions. For every component, produce this full entry:

---

**[ComponentName]**

- **File:** `exact/file/path.tsx`
- **Type:** Primitive / Composite / Layout / Navigation / Feedback / Feature
- **Third-party base:** [if wrapping shadcn, Radix, MUI, etc. — state exactly which primitive]

**TypeScript Props Interface:**

```typescript
// Paste the complete interface exactly as written in the file — do not abbreviate, do not summarise
```

**All Variants:**
[list every value the `variant` prop accepts — and for each: what it looks like visually, what colour scheme it uses, what it communicates to the user]

**All Sizes:**
[list every value the `size` prop accepts — and for each: exact dimensions, padding, font size]

**All Visual States:**
[document every state the component can be in: default, hover, focus, focus-visible, active, pressed, disabled, loading, error, success, selected, checked, indeterminate, open, closed, expanded, collapsed, dragging, and any other states present in the code]

**Visual Description (use your visualisation):**
Describe precisely what this component looks like when rendered — dimensions, layout direction, internal spacing, colours used, typography, iconography, borders, shadows. Visualise it from the code and describe what a user sees.

**Styling — exact classes/styles:**
[copy the exact Tailwind utility classes, CSS module class names, or styled-component styles from the file — do not paraphrase]

**Behaviour & Interactions:**
[every interaction this component supports — click, hover, focus, keyboard shortcuts, animations on state change, side effects, callbacks fired]

**Accessibility:**
[ARIA attributes, role, keyboard navigation support, focus management — as found in the code]

**When to use:**
[inferred from actual usage patterns across the codebase — cite specific examples]

**When NOT to use:**
[inferred from patterns of what this component is never used for]

**Every usage found in the entire codebase:**

- `file/path/one.tsx` — [exactly what props are passed, what the context is, what the component is doing here]
- `file/path/two.tsx` — [exactly what props are passed, what the context is]
  [list every single usage — do not truncate to "and others"]

**Component combinations:**
[other components it is regularly co-located with — with specific examples from actual files]

---

Group all components into these categories, and within each category sort alphabetically:

1. **Primitive Components** — Button, Input, Checkbox, Select, Badge, Avatar, Icon, Tooltip, Label, Switch, Slider, RadioGroup, etc.
2. **Composite Components** — Card, Modal, Dialog, Dropdown, Table, Form, Tabs, Accordion, DatePicker, CommandPalette, etc.
3. **Layout Components** — Page, Container, Section, Grid, Stack, Flex, Sidebar, Header, Footer, Divider, Spacer, etc.
4. **Navigation Components** — Nav, Breadcrumb, Pagination, Stepper, TabBar, SideNav, etc.
5. **Feedback Components** — Toast, Alert, Banner, Skeleton, Spinner, Progress, EmptyState, ErrorState, etc.
6. **Feature Components** — components scoped to a specific product feature area

---

### PHASE 4 — Layout Pattern Analysis

Read every page and view file in the codebase. For each page/view, produce this full entry:

---

**[PageName / ViewName]**

- **File:** `exact/file/path.tsx`
- **Route:** `[route path if identifiable from router config or file structure]`

**Visual Layout (use your visualisation):**
Describe the spatial layout precisely — what occupies the top, left, centre, right, bottom. What wraps what. How the page is divided. What is in the page header, sidebar, main content area, footer. Visualise the rendered page from the code and describe what a user would see.

**Component Composition:**
List every component used on this page — its position, its props, its relationship to adjacent components.

**Layout Pattern Name:**
Give this layout a descriptive name that captures its structure — e.g. "full-width list page with sticky toolbar", "two-column settings page with nav rail", "centred single-column form page", "dashboard grid with summary cards"

**Responsive Behaviour:**
How this layout adapts at every breakpoint documented in Phase 2.

---

After cataloguing all pages, extract and name every recurring layout pattern. For each:

- Pattern name
- Every page that uses this pattern
- Precise structural description
- The component structure (nesting order)
- When this pattern is appropriate vs when it is not

---

### PHASE 5 — Interaction & Behaviour Pattern Analysis

Identify and document every recurring interaction pattern across the codebase. For each pattern:

---

**[Pattern Name]** — e.g. "Inline row edit on click", "Confirmation modal before destructive action", "Optimistic UI update with rollback on error"

- **Found in:** `[every file path where this pattern appears]`
- **Trigger:** [the exact user action that initiates this — click, hover, keyboard shortcut, route change, etc.]
- **Step-by-step behaviour:** [numbered — exactly what happens from trigger to completion, including every intermediate state]
- **Components involved:** [every component that participates in this pattern]
- **State management approach:** [useState, useReducer, context, server state / React Query / SWR — which and why]
- **Animation / Transition:** [exact duration, easing, what animates]
- **Success handling:** [what happens and what the user sees on success]
- **Error handling:** [what happens and what the user sees on error]
- **Loading handling:** [what the user sees while waiting]

---

Cover every interaction type present in the codebase. Check for all of the following and document every one that exists:

- Form submission and field-level validation
- Inline editing (click to edit, press Enter to save, Escape to cancel)
- Modal / Dialog open and close
- Drawer / Sheet open and close
- Dropdown and Popover open and close
- Tooltip show and hide
- Loading states (skeleton loaders, spinners, shimmer, disabled button states)
- Error states (inline errors, toast errors, error pages)
- Empty states
- Optimistic UI updates (local state update before server confirmation)
- Confirmation before destructive actions
- Pagination (page-based, cursor-based)
- Infinite scroll / load more
- Filtering
- Searching (local, debounced, server-side)
- Sorting (column sort, multi-sort)
- Drag and drop (if present)
- Multi-select with bulk actions
- Keyboard navigation and shortcuts
- Toast / notification triggers and dismiss
- Tab switching
- Accordion expand / collapse
- Progress indication (steps, percentage)
- File upload (if present)
- Any other pattern found

---

### PHASE 6 — Feature UI Composition Analysis

Read every feature-level UI in the product — every feature module, every feature page, every feature component. For each feature:

---

**[Feature Name]**

- **Files:** `[all relevant file paths]`

**What this feature does (one paragraph):**
What does the user accomplish with this feature? What problem does it solve?

**User Journey:**
Number every step from the user entering this feature to completing their primary task. Include branching paths (error recovery, cancellation, etc.)

**Visual Description (use your visualisation):**
Describe what the user sees as they move through this feature — screen by screen, state by state.

**Full Component Tree:**

```
[RootComponent]
  [LayoutComponent]
    [Section]
      [ComponentName] (props: ...)
        [ChildComponent] (props: ...)
```

**Data Flow:**
How data enters the UI — which components receive it, how mutations are triggered, how the UI responds to data changes.

**State Design:**
Every piece of state — what it is, where it lives, why it lives there.

**Unique Patterns:**
Anything about this feature's UI that is not found elsewhere in the codebase. Flag it — it is important for understanding the design range of this product.

**Design Strength Analysis:**
What is well-executed in this feature's UI design? Be specific — cite exact components and decisions that demonstrate good UX thinking.

---

### PHASE 7 — Component Combination Intelligence

Analyse how components are combined to create meaningful, complex UI sections. This is one of the most valuable phases — it captures the compositional intelligence of this codebase.

For every significant combination pattern found:

---

**[Combination Pattern Name]** — e.g. "Filterable data table with bulk actions", "Page header with title, breadcrumb, and primary CTA", "Form section with label group and validation feedback"

- **Found in:** `[every file path]`

**Full component nesting (exact):**

```
[OutermostComponent] (from: file/path.tsx)
  [ChildComponent] (from: file/path.tsx) — props: ...
    [GrandchildComponent] (from: file/path.tsx) — props: ...
  [SiblingComponent] (from: file/path.tsx) — props: ...
```

**Visual result (use your visualisation):**
What does this combination produce visually? What does the user see and experience?

**How components communicate:**
Callbacks, shared state, context, prop drilling — exactly how data and events flow between the components in this combination.

**When this combination is appropriate:**
The type of feature or interaction this combination is suited for.

**Props contract at the combination level:**
What the outermost component needs to receive for the whole composition to work.

---

Cover every meaningful composition found, including:

- How list/table rows are constructed
- How cards are built from primitives
- How forms are assembled from form primitives
- How modals are composed with their content
- How toolbars and action bars are assembled
- How page sections are structured
- How navigation is composed
- How data-display sections are built
- How empty and error states are composed with surrounding UI
- Any other multi-component composition found

---

### PHASE 8 — Anti-Pattern Documentation

Document what this codebase deliberately does NOT do. These absent patterns are as important as what it does — they define the design boundaries and prevent future work from introducing foreign elements.

For each absent pattern:

---

**[Anti-Pattern Name]**

- **Observation:** This pattern does not exist anywhere in the codebase.
- **Evidence:** State that you specifically searched for it and confirmed its absence.
- **Implication:** New designs must not introduce this — it would feel visually and behaviourally foreign to the product.

---

Search specifically for these and document each as present or absent:

- Carousels / sliders
- Accordions / expansion panels
- Wizard / multi-step flows
- Infinite scroll
- Floating action buttons
- Bottom navigation bars
- Split-view / master-detail
- Full-screen overlays (not modals)
- Inline SVG illustrations
- Hero sections with large imagery
- Sticky sidebars
- Horizontal scrolling areas
- Complex data visualisation / charts
- Rich text editors
- Any other pattern worth noting as absent

---

### PHASE 9 — Designer Mindset Synthesis

After completing all previous phases, synthesise everything you have observed into the set of design principles that govern this product. These are discovered principles — derived from evidence — not invented ones.

For each principle:

---

**[Principle Name]** — e.g. "Actions are always anchored to the content they affect"

- **Evidence:** `[specific file paths and exact UI patterns that demonstrate this principle]`
- **Anti-evidence (if any):** [any exceptions — and why they are exceptions]
- **Implication for new designs:** [what a new design must do, or must not do, to honour this principle]

---

Cover every dimension of the design philosophy:

- **Visual hierarchy** — how importance and priority are communicated to the user's eye
- **Information density** — how much information is shown at once vs hidden behind interaction
- **Primary action placement** — where the most important action consistently lives
- **Secondary action placement** — where supporting, reversible, or destructive actions live
- **Feedback philosophy** — how the product communicates success, failure, progress, and status to the user
- **Progressive disclosure** — what is shown by default vs revealed on interaction
- **Typography hierarchy** — how text weight, size, and colour create reading structure
- **Colour communication** — what each colour in the system signals to the user and when
- **Spacing philosophy** — the rhythm of breathing room — what the spacing choices communicate
- **Empty state philosophy** — how the product handles zero-data moments — is it instructional, neutral, encouraging?
- **Error philosophy** — how errors are surfaced, explained, and recovered from
- **Loading philosophy** — how the product handles waiting — skeleton, spinner, optimistic — and why
- **Destructive action philosophy** — how permanent or risky actions are guarded
- **Component reuse culture** — how aggressively the codebase composes from existing primitives vs creates new components
- **Motion philosophy** — what moves, what doesn't, and what the motion communicates

---

### PHASE 10 — Final Completeness Pass

Before producing the output document, make one final pass across the entire codebase.

Ask yourself:

- Is there any component file I have not read?
- Is there any page or view I have not documented?
- Is there any feature whose UI I have not analysed?
- Is there any directory I glossed over?
- Are there any component usages I documented as "and others" instead of listing them all?
- Are there any prop interfaces I abbreviated?
- Are there any token values I approximated instead of copying exactly?

For every "yes" answer — go back and complete it before proceeding.

---

## Output Document

Save the output as `UI-DESIGN-INTELLIGENCE.md` at the project root (or in `docs/` if that directory exists).

Structure the document with all 10 phases as top-level sections, using the formats specified in each phase.

### Depth and Length Requirements

- **There is no maximum length.** Do not self-limit.
- Every component gets its full entry — all props, all variants, all states, all usages.
- Every page gets its full entry.
- Every pattern gets its full entry.
- If a component has 12 variants and 23 usages — document all 12 variants and all 23 usages.
- If a pattern appears in 8 files — cite all 8 files.
- Do not write "see above for format" — repeat the format for every entry.
- Do not write "similar to ComponentX" — document it fully in its own right.
- **The document will naturally be thousands of lines. That is expected and correct.**

### Accuracy Requirements

- Every prop interface must be copied exactly from the file — no paraphrasing.
- Every class name must be copied exactly — no approximation.
- Every file path must be the exact path — no guessing.
- Every token value must be the exact value from the config file.

---

## Confidence Gate

After producing the document, answer every question below honestly. If any answer is No — go back, complete what is missing, and update the document. Repeat this gate until every answer is Yes.

```
COMPLETENESS CHECK:
[ ] Have I read every component file in the codebase? (not "most" — every one)
[ ] Have I read every page and view file?
[ ] Have I read the full styling configuration?
[ ] Have I read the third-party library configuration and customisation?
[ ] Is every component documented with its complete, unabbreviated TypeScript props interface?
[ ] Is every component documented with every single usage — no truncation?
[ ] Have I documented every layout pattern found?
[ ] Have I documented every interaction pattern found?
[ ] Have I documented every feature's UI composition?
[ ] Have I documented every component combination pattern?
[ ] Have I documented every anti-pattern?
[ ] Have I cited real file paths for every single claim?
[ ] Is there any directory I did not read?
[ ] Is there any component I did not document?

CONFIDENCE QUESTION:
Am I 100% confident that this document covers every design pattern, every component,
every layout, every interaction, and every design principle in this codebase —
and that a designer reading only this document would have complete knowledge of
the product's design system without needing to look at a single file?

If the answer is anything less than YES — go back and iterate.
Do not finalise the document until the answer is an unqualified YES.
```

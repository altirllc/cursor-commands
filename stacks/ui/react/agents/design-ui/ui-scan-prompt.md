# Task: Execute UI Codebase Intelligence Scan

## Instructions

You are being given a command document (`1-ui-scan.md`) that contains detailed instructions for scanning a React + TypeScript codebase and producing a comprehensive UI design intelligence document.

**Your job:** Execute every phase in that document against THIS codebase. Follow the instructions exactly as written.

## Attached Files

1. `1-ui-scan.md` — The complete scanning methodology (16 phases, 4 parts)

## What You Must Produce

A single markdown file called `UI-DESIGN-INTELLIGENCE.md` that contains:

### Part 1: What Exists

- Complete codebase structure mapping
- All design tokens (colors, typography, spacing, shadows, etc.)
- Full component catalogue with props, variants, states, and usages

### Part 2: How It's Organized

- Layout patterns with decision matrix
- Modal/dialog patterns
- Card/summary patterns
- Interaction patterns (hover, click, form submission, etc.)
- Animation patterns
- Feature compositions
- Component combinations
- Anti-patterns (what the codebase does NOT do)

### Part 3: The Designer's Mindset (CRITICAL)

- Design principles with "Designer's reasoning" quotes explaining WHY
- Creative extension guidelines
- Unique feature deep-dives with alternatives NOT taken

### Part 4: Implementation

- Ready-to-use code templates
- Final verification checklist

## Critical Requirements

1. **Do NOT summarize** — Document everything fully
2. **Do NOT hallucinate** — Only document what you actually read in files
3. **Cite file paths** — Every component, pattern, and token must have its source file
4. **Capture the WHY** — Don't just document what exists, document why it exists
5. **Include designer reasoning** — Write quotes explaining the thinking behind patterns
6. **Document alternatives not taken** — For unique features, explain what wasn't chosen

## Expected Output Length

The document should be 2000-4000+ lines. If it's shorter, you likely skipped content.

## Start

Read the `1-ui-scan.md` file completely, then begin with Phase 1 (Codebase Structure Mapping). Work through all 16 phases in order. Do not skip any phase.

When complete, pass the Confidence Gate at the end of the command file before finalizing.

# STACK: React + TypeScript

---

I have a React + TypeScript production app. A large feature needs to be built.

---

**TASK:**
User will provide {paste the full feature description + all clarified requirements from Step 1}

---

## Anti-Hallucination Rules — Read Before Starting
- Do not list files that "probably need to be changed" based on their name. Read them first.
- Do not describe existing architecture unless you have read the relevant files in this session.
- List every file you read at the top of your response.
- If you cannot find how a specific flow works without reading more files — read them. Do not infer.

### Stop Condition
If answering any question below would require you to assume something about a file you haven't read — read it first. Do not answer from inference.

---

## Do Not Write Any Code. Answer the Following:

**Impact Analysis**
1. Which existing files will need to be modified? (Read them before listing.)
2. Which files are adjacent — won't be modified but could be affected by changes nearby?
3. What existing functionality is most at risk of regression, and why?

**PR Strategy**
4. Should any part of this feature be built as a separate PR to reduce risk?
   - If yes: propose the exact split. Name each PR and what it covers.
   - Rule: if this touches more than 5–6 files, it must be split.
5. What is the safest implementation order, and why?

**Patterns & Risk**
6. What existing React + TypeScript patterns in this codebase should be followed for this feature? Cite the files where those patterns live.
7. What are the top 5 things that could go wrong during implementation? For each: what is the mitigation?
8. What implementation decisions could go either way? Flag them now so we decide upfront — do not leave them for mid-implementation.

---

## ⚠️ Human Decision Required

After reading the AI's output, **you** (the developer) must explicitly decide and write down:

- **PR strategy:** One PR or multiple? If multiple, what is the order?
- **Implementation order:** Which chunk gets built first?
- **Ambiguity answers:** Decisions on every flagged ambiguous choice from question 8

Do not proceed to Step 3 until these decisions are written down.

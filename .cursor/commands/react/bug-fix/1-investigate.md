# STACK: React + TypeScript

---

You are not allowed to write or modify any code in this step.

---

**BUG DESCRIPTION:**
User will provide {exact description of what the user sees — e.g. "Clicking Save on the Edit Profile form shows a success toast but the data is not saved."}

**STEPS TO REPRODUCE:**
User will provide {exact numbered steps — e.g. "1. Go to /profile 2. Click Edit 3. Change name 4. Click Save 5. Refresh — old name shows"}

**SUSPECTED AREA:**
User will provide {file or component suspected to be involved, even if unsure}

---

## YOUR TASK

Deeply investigate the root cause. Do not hallucinate. Do not guess.

### Anti-Hallucination Rules — Read Before Starting
- Do not describe how any code works unless you have **read the actual file**. State which files you opened.
- Do not infer behaviour from filenames, folder names, or component names alone.
- If you cannot find the relevant code, say so explicitly — do not fill the gap with assumptions.
- Every claim you make about the code must reference a specific file, function, and line number.
- If you are working from an assumption rather than evidence, label it clearly as: `[ASSUMPTION — unverified]`.

### Stop Condition
If at any point you reach a decision where you would need to assume something you cannot verify from the code — **stop immediately**. Tell me what you need before continuing.

---

### Investigation Steps

1. List every file you are about to read before you read them.
2. Read those files. Then trace the full execution path of this bug from user action to failure point.
3. Identify every candidate root cause.
4. For each candidate: what exact evidence in the code **confirms** it or **eliminates** it? Cite file + line.
5. Do not stop at the surface level. Go deep until you are certain.
6. If you cannot confirm the root cause from code alone, add `console.log` statements that emit **JSON stringified** output so we can get the evidence we need.

---

### Output Format

Only when you are 100% confident, state:

- **Root cause:** one sentence
- **File:** exact path
- **Function:** exact name
- **Line:** exact number
- **Confidence:** [X]%

> If confidence is below 90%, do not state a root cause. Add the JSON stringified logs instead. I will reproduce the issue and give you the output.

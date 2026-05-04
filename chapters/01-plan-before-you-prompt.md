## 1. Plan Before You Prompt

Write a `plan.md` before touching code. Without a spec, AI generates plausible but directionless output. The plan is your anchor — revisit it after every wave of work to catch drift.

A brief written spec is worth ten corrective prompts.

### Best Practices:
- *Right-size the artifact to the task*. Match the weight of the plan to the risk of getting the task wrong. The annoyance test: if you'd be annoyed to have the agent interpret requirements differently than you meant, write a spec. If you could fix it in one follow-up prompt, skip it. CRUD forms get a sentence; billing state machines get a document.
- *Prefer one editable plan file over hidden artifacts*. A markdown file you can open in your editor and revise beats a buried plan file you can only see through the agent's UI. You want to be able to edit, version-control, and grep your plans.
- *Plan with the most capable model you have; implement with the cheapest one that can handle the task*. Architecture and design decisions are where reasoning quality compounds — pay for it. Implementation, when the plan is well-specified, is often mechanical enough for a smaller model. In Claude Code, `/model opusplan` automates this split.
- *Bound each phase with its own clean context*. Before planning a new feature, clear context if you've been working on something unrelated — irrelevant history is noise. During planning, push exploratory research into subagents so it doesn't pollute the planner's window. After planning, hand the spec to a fresh session for implementation. Each handoff is a context reset; the spec file is what survives.
- *Plan conversationally*. The most reliable planning workflows are dialogues, not one-shot generations. The agent asks one clarifying question at a time, proposes 2–3 alternatives, presents the design in chunks for approval. Monolithic plans dumped in a single response are too dense to review and miss the assumptions a back-and-forth would have surfaced.
- *Own the architecture; let the agent plan within it*. The agent is good at expanding a clear intent into structured tasks. It's bad at deciding which parts of the system should exist. Make the architectural calls yourself, then ask the agent to plan within them — and explicitly ask it to flag over-engineering before implementation.
- *Use your voice*. Talk to the agent instead of typing. When you type, you self-edit and slim down context. When you speak, you include the reasoning you'd normally skip. In our experience, telling the agent exactly what you wouldn't bother writing down can be extremely useful.
- *Don't anchor the agent to your answer*. Describe the problem, not your hunch about the solution. Models are eager to ratify what you've already proposed, so leading with "I was thinking we should…" usually gets you a confident expansion of your own bias. Let the agent reason from the problem first, then compare. When its take and yours diverge, that's where the real planning happens.

### Sources:
- https://lucumr.pocoo.org/2025/12/17/what-is-plan-mode/
- https://martinfowler.com/articles/exploring-gen-ai/sdd-3-tools.html
- https://blog.scottlogic.com/2025/11/26/putting-spec-kit-through-its-paces-radical-idea-or-reinvented-waterfall.html

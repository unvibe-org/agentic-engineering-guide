# The Vibe Coder's Guide to Agentic Engineering

Principles for engineering with AI agents.

---

## 1. Plan First, Code Second

Write a `plan.md` and `design.md` before touching code. The AI needs a spec to aim at — without one it will generate plausible but directionless code. The plan is also your anchor: refer back to it every few waves of work to catch drift.

## 2. Choose Tools For the AI, Not For You

Pick linters, formatters, test runners, and task runners that give fast, unambiguous, machine-readable feedback. Pre-commit hooks, `mise` tasks, CI pipelines — these are guardrails that catch AI mistakes before they land. You are building a feedback loop, not a workflow for your own hands.

## 3. Fast Feedback Loops Above All

If the AI can't test its own work quickly, it can't iterate. This means:

- Easy-to-run tests (`mise run test`, not a 12-step manual process)
- Pure functions that can be tested in isolation
- Hexagonal architecture so business logic doesn't depend on databases or HTTP
- Code coverage to prove the tests actually cover something

The faster the feedback, the more the AI can self-correct.

## 4. Empathy Is a Management Skill

You are a manager now. The LLM is your direct report — one that starts every conversation with amnesia. It doesn't know your codebase, your conventions, your last three decisions, or why you rejected that approach yesterday. Every prompt is its first day on the job.

Good managers give context. They explain *why*, not just *what*. They don't blame the new hire for not knowing things they were never told. Write prompts the way you'd brief a smart colleague who just walked into the room: what are we doing, what have we tried, what matters here. The quality of the output is a direct reflection of the quality of the briefing.

## 5. Functional Core, Imperative Shell

Separate pure business logic from side effects. Pure functions are trivially testable, easy to reason about, and the AI can write and verify them independently. Push all I/O, state, and external calls to the outer shell where they can be mocked or swapped.

## 6. Automate and Enforce

Every project should have from day one:

- Pre-commit hooks (formatting, linting)
- A task runner with standard verbs (`build`, `test`, `lint`, `fmt`)
- CI/CD pipeline
- A README with getting-started and architecture overview

These aren't optional polish — they're the infrastructure that lets AI agents be productive. Pre-commit hooks are especially important: they enforce standards on the LLM the same way they enforce them on human contributors. The AI will learn from the rejection and fix its own mistakes.

## 7. Review Like You Mean It

At the end of every significant change, spawn multiple diverse specialist agents to review:

- Logical consistency with the original spec
- Dead code and unused public functions
- Network timeout handling and error paths
- Test coverage gaps
- Security surface (injection, auth, secrets)

One generalist review catches obvious bugs. Multiple specialist reviews catch the subtle ones.

## 8. Make Illegal States Unrepresentable

Use the type system to prevent bugs at compile time. Newtypes, enums, builder patterns — if invalid data can't be constructed, it can't cause a runtime error. Shift validation from runtime checks to type constraints wherever possible.

---

### Also worth knowing

## 9. Orchestrate in Waves, Not All at Once

Multi-agent work follows a strict sequence:

1. **Build wave** — spawn non-overlapping agents to implement distinct parts
2. **Verify wave** — spawn a new agent to check their combined work for gaps
3. **Test wave** — run all tests, spawn agents to fix failures
4. **Review wave** — spawn diverse specialist agents for multi-faceted code review

Each wave completes fully before the next begins. Never skip the verify wave — agents working in parallel will create seams and inconsistencies at their boundaries.

## 10. Non-Overlapping Agents

When you split work across agents, give each one a clear, non-overlapping scope. Two agents editing the same file is a merge conflict waiting to happen. Define boundaries by module, layer, or feature — not by arbitrary line counts.

## 11. Cross-Boundary Analysis

After parallel agents finish, always do a pass that cuts *across* the boundaries you defined. This is where the bugs live: mismatched interfaces, duplicated logic, inconsistent naming, forgotten integration points.

## 12. Simplicity Over Cleverness

Prefer the simple implementation. Three similar lines of code is better than a premature abstraction. Don't hedge with hybrid approaches. Don't add complexity "just in case." Create a TODO for possible enhancements rather than building them speculatively.

## 13. Let Errors Bubble

Don't catch exceptions just to log and re-raise — that swallows stack traces. Don't write verbose error "helpers" that obscure the real problem. Show the actual command that failed, the return code, and the stderr. Let the AI (and your future self) see what actually went wrong.

## 14. Get a VPS for Heavy Lifting

Set up a remote machine with `et` (Eternal Terminal) and `tmux`. Run long AI tasks there in autonomous/dangerous mode to get to a beta version. Then do refinement locally where you have tighter control. The VPS is your workhorse; your laptop is your workshop.

## 15. Maintenance Is the Hard Problem

Writing code with AI is increasingly easy. Maintaining it is the emerging challenge. Build systems for ongoing maintenance: keep plans and designs updated, prune dead code regularly, and treat your `CLAUDE.md` / project instructions as living documents that teach the AI how your codebase works.

---

*Do what has been asked; nothing more, nothing less.*

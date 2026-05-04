## 3. AGENTS.md/CLAUDE.md

The LLM starts every conversation with amnesia. Re-explaining your codebase, conventions, and build commands in every prompt is wasted effort — and it never quite sticks. Persist that knowledge in the repo instead.

### Best Practices:
- *Short* — a good context file is short and load-bearing. Include only what the agent can't infer from the code.
- *Non-obvious* — conventions, architecture choices, tooling quirks. "We use bun, not node."
- *Tech stack* — Every `AGENTS.md` needs a `## Tech Stack` section.
- *No `/init`* — Do not use `/init`. Auto-generated context files measurably reduce success rates.
- *Progressive disclosure* — keep the always-loaded file small; reveal task- and path-specific context only when relevant.
- Do not describe anything that the `formatter` or `linter` can do.
- Use procedural workflows (numbered lists) for recurring tasks. Put them in slash commands or skills, not in `AGENTS.md` itself.
- Use decision tables when 2–3 valid approaches exist.
- Pair every "don't" with a "do" — a prohibition without an alternative makes the agent over-explore.

### Sources:
- https://www.augmentcode.com/blog/how-to-write-good-agents-dot-md-files
- https://www.humanlayer.dev/blog/writing-a-good-claude-md

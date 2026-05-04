## 9. Code Reviews

When agents write most of the code, a single human reviewer becomes the bottleneck. The shift that matters is moving from one human reading every diff to a panel of specialist agents reviewing in parallel — with the human as the final checkpoint, not the first one.

### Use a panel, not a single reviewer

A generalist reviewer produces generic advice. A panel surfaces issues that no single reviewer could hold in mind simultaneously.

The practical prompt is short:

> **💡 Prompt**
>
> Spawn a red team of agents to review this work\[, ensure you include an X expert\]

Claude picks reasonable specialists on its own, but it helps to name them explicitly:

- best-practices expert
- DRY expert
- `<language>` expert
- security expert
- maintainability expert
- SOC 2 / ISO 27001 compliance expert

For larger diffs, run two rounds. The first round catches the critical issues; the second round picks up important findings the first one missed. It is token-heavy, but cheap relative to the cost of a missed regression.

### Tell the agent what not to flag

The most counterintuitive finding from production deployments: a security reviewer's prompt is mostly a list of things to *ignore* — theoretical risks, defense-in-depth nits, unchanged code, "consider library X" suggestions. Without an explicit ignore list, the panel produces a firehose of speculative warnings that developers learn to tune out within a month.

This generalizes beyond review. Generate an explicit `REVIEW.md` for this task and reference it on review prompts.

### Tier the review to match the diff

Frontier-model tokens are wasted on a typo fix. A workable classification:

- **Trivial** — ≤10 lines, ≤2 files. Coordinator can downgrade from Opus to Sonnet.
- **Lite** — ≤100 lines. *Spawn a single agent to review this work*.
- **Full** — >100 lines, or any change touching auth, crypto, or other security paths. *Spawn a team of expert agents to review this work*.

Published cost data puts trivial reviews near $0.20 and full reviews near $1.68. Tiering is the most direct answer to the "Claude Code is too expensive" objection.

### Review before the PR, not after

Run the panel on the developer's laptop before the PR opens — same agents, same prompts, same risk tiers as CI. The human reviewer becomes the final checkpoint, not the first one. Every finding the panel produces also becomes a candidate prompt rule for the next iteration, which is where compound engineering starts to pay off.

# 🧠 Vibe Coding Best Practices

---

## 🧠 Learnings

- **Avoid Exponential Technical Debt**
  - Vibe coding naturally stacks “band-aids on band-aids.”
  - Debt compounds faster than expected if not managed early.

- **Collaboration Adds Hidden Complexity**
  - Working with non-technical collaborators requires deeper review.
  - Not seeing their prompts makes it harder to understand intent.
  - You end up reviewing both *code and assumptions*.

- **Agent Variability Creates Friction**
  - Different coding agents behave inconsistently.
  - Misalignment across collaborators leads to unpredictability.

- **Context Window Limits Are Real**
  - Large tasks cause the model to lose the thread.
  - This also overwhelms *you* as the reviewer.
  - Keep things small and reviewable.

- **Vibe Coding Hangovers Are Real**
  - Can trigger stress, confusion, and imposter syndrome.
  - Example: digging into AI-generated code that “works” but is nonsensical (“AI spaghetti”).
  - Wake-up call to stay closer to the code.
  - Caveat: worse with older agents; improving over time.

- **Planning Saves Massive Time**
  - Lack of upfront planning leads to backtracking.
  - Strong mental models reduce wasted effort.

- **Harder to Maintain a Mental Model**
  - You’re more detached since you didn’t write the code.
  - AI also struggles with full-system understanding.
  - Still an open problem.

- **Dev Loops Can Become Bottlenecks**
  - Especially in complex setups (e.g., voice desktop apps).
  - Slows iteration significantly.

- **Users Are Sensitive to “AI Slop”**
  - Quality and reliability are now key differentiators.
  - Perception matters.

- **System Design > Syntax**
  - Syntax matters less.
  - Real leverage comes from:
    - Architecture
    - Data flow
    - Modularity
    - Avoiding circular dependencies

- **Second Reviewers Catch Real Bugs**
  - Tools (e.g., CodeRabbit, Devin) catch subtle issues (e.g., concurrency).
  - Different perspectives are valuable.

- **Code Reviews Feel Worse—but Matter More**
  - Easy to gloss over, but consistently reveal issues (“WTFs”).
  - Also surface cleanup opportunities.

- **DX Improvements Are Easier Than Ever**
  - Internal tools (CLI, deploy scripts, test harnesses) are now cheap to build.
  - Big leverage vs. past workflows.

- **Daring Prototyping Is Now Feasible**
  - Ideas that took days now take hours.
  - Enables parallel exploration.

- **MCP Is Powerful (When Used Right)**
  - Great for logs, observability, and complex queries.
  - Reduces cognitive load and debugging fatigue.

- **Vibe Coding Depends on Product Stage**
  - Early (no PMF): speed > quality, debt is acceptable.
  - Later: rigor and structure matter more.
  - Misalignment causes “hangovers.”

- **Token Budget Shapes Your Workflow**
  - Different budgets → different strategies.
  - No one-size-fits-all.

- **Task Size vs. Confidence Tradeoff**
  - Bigger + longer + more creative = higher risk.
  - Small, narrow tasks = high confidence.
  - Exception: large but mechanical changes can still be safe.

---

## ⚙️ Strategies & Tactics

- **Actively Manage Technical Debt**
  - Don’t let patches accumulate unchecked.
  - Periodically clean up.

- **Standardize Across Teams**
  - Align on:
    - Coding agents
    - Prompting styles
    - Expectations

- **Break Work Into Small, Reviewable Units**
  - Fit tasks within the context window.
  - Keep work understandable for yourself.

- **Use Sub-Agents (When Worth It)**
  - Helpful but expensive.
  - Not required—task decomposition is the key.

- **Adopt a Plan-First Workflow**
  - Research before coding:
    - ChatGPT / deep research
    - External sources
  - Build a strong mental model first.

- **Structured Execution Flow**
  - Research → Plan → Execute
  - If too big:
    - Slice into smaller parts
    - Execute sequentially

- **Use PR-Based Iteration**
  - Small, focused PRs
  - Low-risk, easy-to-review changes

- **Prototype Boldly, Then Reset**
  - Explore ideas quickly and messily
  - Then:
    - Start fresh
    - Rebuild cleanly
    - Use structured PRs

- **Match Approach to Product Stage**
  - Early: optimize for speed and learning
  - Later: optimize for quality and maintainability

- **Invest in System Design**
  - Prioritize:
    - Clean architecture
    - Modularity
    - Clear data flow

- **Use Multi-Layer Code Review**
  - First pass: automated reviewer (e.g., Devin)
  - Second pass: manual review
  - Then clean up and squash

- **Lean Into Code Reviews**
  - Expect bugs, weird logic, and cleanup opportunities

- **Exploit Cheap Tooling**
  - Build internal tools aggressively:
    - Deployment scripts
    - Test harnesses
    - Debug tools

- **Use MCP for Heavy Queries**
  - Offload logs, observability, and data queries
  - Reduce mental load

- **Optimize for Confidence**
  - Prefer narrow, well-defined tasks
  - Be cautious with long-running, complex outputs

- **Adapt to Your Token Budget**
  - Adjust workflow based on constraints
  - Don’t copy others blindly

- **Continuously Rebuild Your Mental Model**
  - Stay close enough to the code to understand it
  - Avoid surprises later

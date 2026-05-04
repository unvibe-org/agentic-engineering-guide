## 9. Manage Technical Debt Actively

You already know what technical debt feels like, even if you've never used the term. It's that moment where a change that should take twenty minutes takes two days. It's when you fix a bug in one place and three more pop up somewhere else. It's the slow, creeping realization that your codebase is fighting you.

At its core, technical debt is complexity that's slowing you down. Duplicated logic scattered across files. Tightly coupled components where touching one thing breaks five others. That Rube Goldberg machine you built sprint by sprint, where nobody can trace the full path from input to output anymore.

And in the age of agents, this problem gets worse faster than it ever has before.

---

#### Not All Debt Is Created Equal

Sometimes technical debt is the right call. If you're building a prototype, pile it on. You're trying to validate an idea, not build a cathedral. Debt in throwaway work isn't debt — it's efficiency.

If you're working on a long-lived system — something people depend on for years — your tolerance should be close to zero. Complexity compounds. What costs you an hour today costs you a day next quarter and a week next year.

Most of us live somewhere in between. You're building a SaaS product, the product is evolving, and some parts won't survive the next pivot. Being precious about those parts is a waste. But the core? That needs to be solid.

The question you should always be asking is: *how long does this code need to live?*

---

#### Agents Will Bury You in Debt If You Let Them

Agents don't care about your codebase. They care about completing the task you gave them. That's it.

If you say "fix the performance issue," an agent will fix it — probably by bolting on a caching layer or wrapping things in a new abstraction. Did it work? Yes. Is the underlying design any better? Almost certainly not. You just got another layer on the pile.

The agent optimizes for the reward signal (task completed, tests pass) and ignores everything else. It doesn't check whether the solution is consistent with the architecture. It doesn't ask whether there's already a utility function that does the same thing. Left unchecked, your complexity grows with every task — and the agent isn't being malicious. The problem is that "what you asked" and "what you actually need" aren't always the same thing.

---

#### How to Keep It Under Control

**Know your stack.** You can't guide an agent toward good solutions if you don't understand what good looks like. You don't need to write every line yourself — but you need to understand every "semantic chunk" and know whether it belongs.

**Ensure best practices.** If your codebase has patterns for database connections, tell the agent. If there's a utility module that should be reused, point to it. Build these constraints into your reusable prompts, rules files, and agent configs. Make the guardrails part of the workflow, not something you remember on a good day.

**Catch problems early.** Review the code, run the tests, watch runtime behavior. Feed problems back into the agent while context is fresh. This matters more with agent-generated code because the volume is so much higher.

Prevent what you can, detect what you can't prevent, fix what you detect before it metastasizes.

---

#### The Vibe Coding Hangover

You've been shipping fast. The agent is cranking. Tickets are closing. Then one morning you open the project and... what is this? Three different auth patterns. Circular imports. A file structure that makes no sense. You're staring at your own codebase and you don't recognize it.

That's the Vibe Coding Hangover.

It hits hardest under pressure to deliver something new, when you realize the foundation can barely support what's already there. Your options all suck: patch it (more debt), refactor it (explain the velocity drop to stakeholders), or rewrite it (feels like admitting failure). All of them could have been avoided by paying attention along the way.

---

#### The Sneaky Stuff: Dead Code and Lost Understanding

Not all tech debt screams at you. Dead code is a perfect example — agents rewrite functions and leave the old versions behind. Nothing breaks, but your codebase fills with ghosts. Every search returns noise. You burn tokens sending useless context to the agent on the next task. Get tooling to catch it: compiler warnings in Rust, linters in TypeScript. This matters more now because agents generate dead code at scale.

But the really dangerous one is not understanding your own system. This is latent debt — it doesn't show up until something breaks and you have no mental model of how the pieces fit together. If you fall too far behind, the agent starts looping on fixes that don't work because the problem is architectural, and you can't help because you don't understand the architecture either. At that point, your only option is often to start over.

Don't let this happen. Read the code the agent writes. Sketch how the system works, even if it's boxes and arrows on a napkin. The goal isn't perfect documentation — it's a mental model close enough to reality that you can intervene when things go sideways.

---

#### Strategies That Actually Help

**Snippet databases.** Keep a collection of battle-tested code patterns you've already debugged and validated. Point the agent at them. Instead of reinventing solutions (and reinventing new bugs), it reuses something proven. You move faster *and* take on less debt. One of the rare genuine free lunches.

**Lean toward stronger typing.** Traditionally, strong typing meant more boilerplate and cognitive overhead. But agents eat that overhead for breakfast. They'll happily generate all the type annotations and interfaces you want, and you get explicit data structures, better tooling, and fewer mystery bugs. TypeScript over JavaScript. Python type hints everywhere. If the ecosystem supports it, Rust or Go.

One caveat: don't fight your ecosystem. If you're doing ML work, you're using Python — that's where the libraries live. The point is to choose the strongest typing your ecosystem supports, not to abandon your ecosystem in pursuit of type safety.

---

#### The Bottom Line

Technical debt in the agent era moves faster and hides better than it used to. But if you understand your tools, set clear constraints, and build feedback loops into your workflow, you can move fast without waking up to a codebase you can't recognize.

The agents are only as good as the guardrails you give them. Build the guardrails.

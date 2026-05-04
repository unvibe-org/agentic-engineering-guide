## Introduction

A year ago, "AI coding" mostly meant autocomplete. Today, an agent can read a ticket, plan the work, write the code, run the tests, and open the pull request — in the time it used to take to set up a branch. The leverage is real. So is the mess underneath it.

Most engineers who have shipped serious AI-assisted work have felt the same two things. First: a stretch of speed that feels like cheating. Then the comedown — code that works but you don't quite understand, a codebase drifting somewhere you didn't choose, a review queue full of pull requests no human wants to read. We call it the *vibe coding hangover*, and avoiding it is the reason this guide exists.

**Agentic engineering is the discipline of directing AI agents to ship production code without losing the quality bar, the architectural thread, or your own understanding of the system.** It is not better prompting. It is the system you build around the agent so the agent can do its best work and you can stay in charge of the result.

### What this is — and isn't

A field manual, not a textbook. Ten practices, organised around the natural arc of a piece of work:

- **Part I — Plan.** Spec the work, choose the architecture, set the rigor before you prompt.
- **Part II — Implement.** Run the agent inside fast feedback loops, with the tools and context it needs to be useful.
- **Part III — Review & Sustain.** Catch what the agent missed, manage the debt it creates, and keep the codebase yours over time.

Each chapter is short on purpose. We have written the practices in the form we wish someone had handed us a year ago: the rule, the reason behind it, and just enough texture to apply it tomorrow morning.

### Who this is for

Working software engineers who already ship code with an agent in the loop and have started to notice the seams. You have used Claude Code, Cursor, or Codex in earnest. You have felt the speed. You have also seen a pull request you couldn't fully defend, a refactor that quietly went sideways, a teammate ask "who actually wrote this?" — and wondered whether the velocity is worth the drift.

If you are still deciding whether to adopt AI coding tools at all, this is too far downstream. If you are looking for prompt templates or a list of MCP servers, you will be disappointed. The practices here assume agents are already part of your workflow; the question is how to keep them honest.

### Where this comes from

The three of us have shipped production code with AI agents daily for the better part of two years — across bare-metal Kubernetes infrastructure, B2B SaaS, autonomous driving systems, and consumer apps. None of us came to this from research. We came to it from things breaking in production and trying to figure out why.

What you are reading is the consensus view that emerged from those scars, sharpened against the public writing of practitioners we trust, and tested in the workshop we run on this material in Munich. None of it is settled. The tools change every month, the models change every quarter, and some of what is in here will look quaint within a year. We have tried to write the parts we expect to age the slowest — the ones about how humans and agents work together, not the ones about which CLI flag to pass.

### How to read it

Linearly, if it is your first pass. The three parts build on each other, and several practices in Part III only make sense once you have internalised Part I.

As a reference, after that. Each chapter stands alone. Skim the contents, find the practice that matches the failure mode you are currently looking at, and start there.

If you only have ten minutes: read Chapter 1 (*Plan Before You Prompt*) and the closing note on *Vibe Coding Hangovers*. The first is where most of the leverage lives. The second is what happens when you skip the first.

### One last thing

Agentic engineering is not about getting the agent to do more. It is about preserving the things that made you good at this work in the first place: judgment, taste, ownership, the willingness to read what was written and decide whether it should stay. The agent is a force multiplier. You are still the engineer.

Turn the page.

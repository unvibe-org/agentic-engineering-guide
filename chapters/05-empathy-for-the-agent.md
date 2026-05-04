## 5. Have Empathy for the Agent

Empathy for the agent's situation gets the most out of it, somewhat like being a manager. The LLM starts every conversation with amnesia. It doesn't know your codebase, your conventions, or the discussion that led to this task. We forget how much of our own context we carry by default. The agent has none of it.

Brief it the way you'd brief a competent direct report on their first day:

- The goal, in your words.
- The constraints. What cannot change, what must not break.
- What you already tried, and why it didn't work.
- The audience for the output. Throwaway prototype and production code call for different work.
- The urgency-versus-thoroughness tradeoff. An agent told nothing will pick a default, and it may not be the one you want.

Add screenshots of the Slack thread or ticket that prompted the request. At Lithus we also point it at our `llms-full.txt` in some cases (https://lithus.eu/llms-full.txt).

Be honest about your own uncertainty. "I think we should do X, but I don't know as I haven't worked with this stack before" gives the agent permission to disagree. Without that line it commits to your framing, and you lose a second opinion you were never going to read otherwise.

Tell it to ask questions. It will sometimes do this on its own, but not always, and the question it asks usually reminds you of context you forgot to include.

Empathy you'd otherwise repeat every session belongs in `CLAUDE.md`, or your agent's equivalent. Codebase conventions, who you are, what you care about. Write it once, stop retyping it.

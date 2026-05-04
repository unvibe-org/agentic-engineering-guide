## 6. Choose Tools For the AI, Not For You

Mandatory checks are another form of important feedback, such as pre-commit hooks.

At Lithus we use lefthook pre-commit hooks for: secret scanning (gitleaks), formatting (rustfmt, gofmt, black, prettier, nixfmt), linting (clippy, go-lint, statix, deadnix), blocking commits of unencrypted Terraform state, and requiring documentation updates.

These pre-commit hooks force the agent through a mandatory feedback loop. The commit doesn't land until the checks pass; every rejection becomes a correction the agent has to make before moving on.

It should be easy for the agent to reproduce issues. Ideally, one command brings the project to a working state. Mise or devenv are good options here.

Programming language choice is very relevant here too. Pick languages that give fast feedback at compile-time. Static type errors are easier for an agent to address than runtime ones it has to reproduce first.

The underlying principle is to build feedback loops. If you find yourself copy-pasting into the prompt window, that is likely a candidate for a feedback loop.

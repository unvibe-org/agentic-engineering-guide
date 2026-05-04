## 7. Effort Is Tending Towards Zero

The effort of actually wielding your chosen tools has historically fallen to you, the engineer. Some tools you enjoyed wielding, but some you did not. Perhaps some of these tools were conceptually harder to grasp, or required more effort than you were willing to give.

Now you have a new option. You can now reap the benefits of tools you would previously avoid. The tradeoff is that you must be willing to learn these tools from the top-down, not the bottom up. Understand the principles and the best practices, not the syntax.

Some examples of tools that may fall into this category for you:

- **Rust** — rapid feedback, and even though the type system is a head-scratcher, agents deal with it fine.
- **Nix** — a paradigm shift, but it catches system configuration issues at evaluation time, before runtime.
- **Kubernetes** — a well-known system that agents can easily deploy to, and one they are excellent at diagnosing issues on.
- **Schema-first APIs** — OpenAPI, Protobuf, GraphQL. Tedious to set up. A free reviewer forever after.
- **Infrastructure as code** — Terraform or Pulumi over clicking through cloud consoles. Declarative state is painful to learn, and easier for agents to reason about than UI clickpaths nobody can audit.
- **Strict linter and type-checker configs** — clippy at full volume, mypy strict, the ESLint rules humans turn off. The agent absorbs the friction; the codebase keeps the safety.

The principle has some limits. Tools with sparse training coverage will require the agent to have some documentation on-hand, which will increase token use.

# Contributing

Thanks for considering a contribution. This repository is dual-licensed —
MIT for the build pipeline, CC BY-NC-SA 4.0 for the written content — and
we want every contribution to fit cleanly into that model.

## How to contribute

1. **Fork** the repository and create a topic branch.
2. **Make your change.** For content edits, keep American English and the
   style rules in `README.md`. For code, run `./generate-guide-pdf.sh`
   locally to confirm the PDF still builds.
3. **Sign off your commits** (see below).
4. **Open a pull request** with a short description of what you changed
   and why.

## Developer Certificate of Origin (DCO)

We use the [Developer Certificate of Origin](https://developercertificate.org/)
to keep the project's licensing clean. The DCO is a lightweight statement
that you have the right to submit the contribution under the project's
license. There's no separate form to sign — you confirm it by adding a
`Signed-off-by:` line to every commit:

```
Signed-off-by: Your Name <your.email@example.com>
```

Most git setups can add this automatically with `git commit -s`. If you
forget on a commit, amend it with `git commit --amend -s`. For multiple
commits, `git rebase --signoff main` will add the line to every commit on
your branch.

By signing off, you certify the following (paraphrased from the full DCO
text linked above):

- The contribution was created in whole or in part by you, and you have
  the right to submit it under the project's license; **or**
- The contribution is based on previous work that is licensed under an
  open-source license that allows you to modify and submit it under the
  project's license; **or**
- The contribution was provided to you by someone who certified one of
  the above, and you are not modifying it.

You also agree that the contribution is public and that a record of it
(including your sign-off) is maintained indefinitely.

## What you're licensing

- Code contributions (anything under `.claude/skills/guide-pdf/`,
  `generate-guide-pdf.sh`, build scripts) are licensed under the **MIT
  License** — see `LICENSE`.
- Content contributions (`chapters/`, variants, `README.md`) are licensed
  under **CC BY-NC-SA 4.0** — see `LICENSE-CONTENT`.

If your contribution mixes both, the relevant license applies to each
file by location.

## What we can't accept

- Contributions you don't have the right to submit (e.g. copy-pasted from
  someone else's copyrighted work without permission).
- Photos of people other than the named instructors. Instructor photos
  are "all rights reserved" and not open to outside contributions.
- AI-generated content that you can't certify under the DCO. If you used
  an AI assistant to draft a section, that's fine — but you must have
  reviewed and edited it to the point that you'd put your name on it.

## Code of conduct

Be kind. Assume good faith. If something feels off, email
hello@bettervibe.org.

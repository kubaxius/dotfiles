---
description: Prepare a compact brief for continuing in a fresh session
---

Create a dense, self-contained handoff for a brand-new OpenCode session.

The handoff must let another capable coding agent continue immediately without
seeing this conversation. Include only information that still matters:

- the user's current objective and success criteria;
- repository/project location, relevant environment constraints, and active branch if known;
- decisions already made and why;
- work completed, including exact files changed and important implementation details;
- verification already run and its results;
- unresolved problems, risks, and assumptions;
- the next concrete actions in priority order;
- any exact commands, identifiers, error messages, or short code fragments whose
  precision is essential.

Re-check the current working tree or other local state only when needed to avoid
claiming stale facts. Do not continue implementation, call tools speculatively,
or include conversational filler. Do not reproduce the transcript. Preserve
important user preferences and constraints. Clearly label anything uncertain.

Output only the handoff in Markdown, beginning with:

# Session handoff

Optional focus supplied by the user: $ARGUMENTS

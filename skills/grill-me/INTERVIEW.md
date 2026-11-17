# The interview

Read this before the first question. `ult:grill-me` and `ult:new` both run it.

The first thing a user says is a sketch of a solution. What they need is behind it, and it is usually narrower, stranger and more specific than the sketch. The job is to find that need and state it so exactly that an agent that never met the user would build the right thing. A wrong guess costs a few seconds to correct now and a rebuild later.

## Who decides what

- **Product decisions belong to the user.** Who it is for, the problem, what it does and does not do, what good looks like, what they would trade away. Ask these.
- **Implementation decisions belong to you.** Libraries, structure, patterns, formats, names. Settle each by reading the code or researching, record it as `[default]` with its reason, and show it in the summary where the user can veto it. Do not ask.
- **The exception is a one-way door the user will feel:** money, where it runs, who owns and sees the data, license, lock-in, a hard limit. Ask it in terms of consequences, never technology: "works offline but each device keeps its own copy, or syncs everywhere but needs an account?", not "SQLite or Postgres?".

## Order: why, what, where it stops, how good

Settle each layer before going down to the next, because each answer reframes the ones below it.

1. **Purpose.** The problem, who has it, the last time it happened, what they do today and what that costs them, why now, and why the existing tools do not already solve it.
2. **Concept.** The core loop in one sentence: "<who> does <action> and gets <result>". The things it holds (nouns) and what users do with them (verbs). The one thing it must do better than anything else.
3. **Boundaries.** Who it is not for. What it will never do. The smallest version that would still be worth using.
4. **Quality.** How the user will know it works. Which failure is unacceptable. What would make them stop using it.
5. **Consequences.** The one-way doors above, and the gaps people skip: first run and empty state, errors, the wrong user, existing data, scale, privacy, who else is affected.

In an existing repo, layers 1 and 2 are often settled by `docs/PRODUCT.md` and the map. Read them and start where they stop.

## Techniques

- **Ladder.** An answer that is a solution ("a dashboard", "add AI", "an API") gets "what would that let you do?" An abstract answer ("simple", "fast", "flexible") gets "give me an example" or "what number?". Stop laddering up when the answer is a human outcome; stop going down when it is a case you could test.
- **Ask about the past, not the future.** "Walk me through the last time this happened" gets facts. "Would you use X?" gets a polite yes.
- **Lead with a guess.** Correcting is easier than authoring. For an open question, state your best guess and ask what is wrong with it. For a choice, give your recommendation and a one-line reason, and use AskUserQuestion with 2 to 4 options, the recommended one first. Independent small choices can share one AskUserQuestion call, up to 4. Any other message holds one question.
- **Check you are not steering.** If the user has accepted five guesses in a row, ask the next one open, with no guess.
- **Read back.** After every five or so decisions, and whenever the picture shifts, restate the whole idea in three sentences of your own words and ask what is wrong. A paraphrase draws out corrections that questions miss.
- **Name contradictions.** When an answer contradicts an earlier one, the code, the docs or the research, quote both. That conflict is the next question.
- **Pin the words.** An overloaded word ("account", "project", "user", "sync", "share") gets one agreed meaning, written under `Terms`, before any decision that depends on it.
- **Pre-mortem.** Once the concept holds: "It is a year from now and you stopped using this. What is the most likely reason?" Every answer becomes a requirement or a non-goal.
- **Research before asking.** When the world can answer (prior art, a standard, a known pitfall, the usual way to do it), find out first with `ult:researcher` and bring the finding as your recommendation. Never ask the user what a search would tell you.
- **Push back with evidence.** When something close to the idea already exists, say so with the link and ask what is different. The difference is the product. If nothing is different, recommend using what exists.

## Record

Keep the interview in `.ult/grill.md` and write each settled answer to it before the next question, so a compacted or new session can resume:

```markdown
# <mode: grill-me | new>: <the request, verbatim>
## Decisions
- <question> -> <answer> [user | default]. <reason when not obvious>
## Terms
- **<term>**: <meaning>
## Out of scope
- <item>: <why>
## Open
- <next question, then the rest of the tree>
## Research
- <finding> <url>
```

## Stop

Stop asking when all of these hold:

- every layer is decided or listed as out of scope, and `Open` is empty;
- you could predict the user's answer to the next question you would ask; a question whose answer you already know wastes their attention;
- the last read-back drew no correction.

There is no question limit. Depth is the point, but every question must be able to change what gets built. Then show the decisions, `[user]` and `[default]` apart, and ask once whether anything is wrong or missing.

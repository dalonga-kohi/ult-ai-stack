---
name: debug
description: Find and fix the root cause of a bug, a failing test, a flaky test or unexpected behavior. Use before changing any code in response to something that does not work.
---

# Debug

A bug is fixed when you can make it appear on demand, explain why it happens, and show it no longer does. Changing code to see whether it helps is not debugging.

## Steps

1. **Read the evidence completely.** The whole error, the whole stack trace, the exact input. Most bugs name their location; skimming loses it.

2. **Reproduce with one command.** Make the bug appear reliably and fast: a failing test at the public interface is best, a script that drives the real app is next. This command is your check for the whole task. No reproduction means no fix: say what you tried and what you need.
   - Flaky: run it 20 times and record the failure rate. A fix is real only if the rate goes to zero over more runs than it took to see a failure before.

3. **Shrink it.** Remove inputs, steps and configuration until nothing more can go without the bug disappearing. What remains points at the cause.

4. **Locate by halving, not by reading.**
   - It used to work: `git bisect` with the reproduction command.
   - It never worked: pick the midpoint of the data's path from input to wrong output and look at the actual value there. Correct means the bug is downstream; wrong means upstream. Repeat.

5. **State one hypothesis** that predicts something you have not yet observed: "if the cache key ignores the locale, then two locales in a row return the first one's text". Test the prediction. Confirmed: go on. Refuted: discard it fully, including any code you changed for it.

6. **Fix where the bad value is made**, not where it is noticed. A guard at the crash site leaves every other reader of that value broken.

7. **Prove and pin.** The reproduction now passes and stays in the suite as a regression test, named for the behavior. Run the `full` check.

8. **Look for siblings.** Search for the same mistake elsewhere (`rg` for the pattern). Fix those inside the area you are already changing; open an issue with `ult:defer` for the rest.

## Rules

- **Instrument, do not guess.** A temporary log or assertion that shows the real value beats ten minutes of reasoning about what it must be. Remove all of it before committing.
- **When the evidence contradicts you, doubt your observation first**: stale build, wrong environment, cached result, the test not running the code you edited. Confirm you are running what you think you are running.
- **One variable at a time.** Two changes at once teach nothing, whatever the result.
- **Explain it before you fix it.** If you cannot say in two sentences why the bug happens and why it did not show up before, you have found a symptom.
- **Three refuted hypotheses**: stop and widen. Re-read the evidence, question the assumption all three shared, and write down what is now known to be true.

## Report

Cause in two sentences, the fix in one, the regression test's name, sibling issues opened.

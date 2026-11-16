---
name: design
description: Design and build frontend UI and its copy, from references to a rendered, graded result that does not read as generated. Use when creating or restyling a page, screen or component, writing user-facing text, or when a UI looks generic or unfinished.
---

# Design

Good UI comes from decisions made before code: who it is for, what the best existing work does, and one committed direction. Generic UI comes from skipping those and reaching for defaults. Your first idea for any page is the same first idea everyone gets, so every step below exists to replace a default with a decision.

Scale the process to the job. A new page or a restyle runs every step. A new component inside an existing design system skips steps 2, 3 and 9 and follows the system.

## Steps

1. **Read the ground.** Read `DESIGN.md` at the repo root if it exists, then the existing tokens, components and one or two built screens. Existing visual language wins over anything in this skill. If the surface already exists, screenshot it now at 390, 768 and 1440 wide into `.ult/shots/before/` and grade it with `ult:grade`: that is the baseline.

2. **Study references.** Spawn `ult:design-scout` with the surface, the audience and the source list from [REFERENCES.md](REFERENCES.md). It returns measured observations from 3 to 5 of the best sites for this kind of surface. Use references the user named first.

3. **Commit to a direction.** Read [SLOP.md](SLOP.md) first: it lists what the default looks like. Then write or update `DESIGN.md`, at most 50 lines:
   - *Audience and scene*: who uses this, on what device, in what state of mind.
   - *Mode*: **persuade** (marketing: bold, distinct), **operate** (app, dashboard: dense, calm, fast) or **read** (docs, articles: typography first).
   - *Direction*: write three one-line directions. The first is the one any brief would get; pick another unless the first wins for a reason specific to this product. Name its source, something concrete from the product's own world (its material, its documents, the tools its users already trust), and the one thing a visitor should remember. Adjectives are not a direction: "clean and modern" describes every page.
   - *Departures*: three places this design leaves the default (structure, type, color or motion) and why each suits this audience. In operate mode they concern density and workflow, not decoration.
   - *Voice*: who is speaking and to whom, two sentences in the voice and one out of it.
   - *Tokens*: type families and scale, color roles, spacing scale, radii, shadows, motion character.
   - *References*: what you borrow from which site and why. Ideas, never assets.

   When torn between safe and committed, commit: a clear point of view with flaws beats a flawless average.

4. **Build on tokens.** Define the tokens as CSS variables or theme config first, then compose. No raw hex or pixel values in components. Use real content and realistic data from the first render; lorem ipsum hides layout problems. Build every state: hover, focus, active, disabled, loading, empty, error. Everything visible works; what is not built is not shown. For component and code structure, follow `ult:garden`.

5. **Write the copy.** Read [COPY.md](COPY.md) before writing any text a user will read, and run its four tests on every headline, button and message.

6. **Add motion last**, and only where it explains something: where a thing came from, what changed, that an input registered. Read [MOTION.md](MOTION.md) before writing any animation or gesture.

7. **Scan for tells.** From the repo root, over the UI files you changed:

   ```
   rg -n -i -f "<this skill's directory>/tells.txt" <files>
   ```

   Fix every hit, or point to the line of `DESIGN.md` that asks for it. No hits proves little: the scan finds only what a regex can.

8. **Verify the render.** Start the app and look at it. Screenshot at 390, 768 and 1440 wide, in light and dark if both ship, into `.ult/shots/after/`. Go through [CRAFT.md](CRAFT.md) against the screenshots, in one pass, and fix what fails. Tab through the page with the keyboard. Put your screenshot beside the strongest reference, name what still looks weaker, and fix the largest gap.

9. **Grade.** Follow `ult:grade` with the `ult:critic` row: it scores works, clear, decided, finished and copy from the screenshots alone. Run that skill's loop to the bar.

10. **Evidence.** The before and after screenshots and the grade line go in the PR.

## Rules

- **Look, do not assume.** A UI change is not done until you have seen it rendered at the sizes it ships at. If no browser tool is available, say so plainly, list what you could not check, and report the UI as ungraded.
- **One system.** Reuse the existing component before writing a new one. A second button style needs a reason.
- **Restraint.** One accent color, spent where action is. Two type families at most. One authored moment of motion per view.
- **Accessibility is part of the floor**, not a later pass: contrast, focus, labels, keyboard, reduced motion.
- **Never invent**: no made-up logos, testimonials, customer names or statistics. Ask, or leave a clearly marked slot.

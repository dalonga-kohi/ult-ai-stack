---
name: design
description: Design and build frontend UI from references to a verified render. Use when creating or restyling a page, screen or component, choosing type, color, layout or motion, or when a UI looks generic or unfinished.
---

# Design

Good UI comes from decisions made before code: who it is for, what the best existing work does, and one committed direction. Generic UI comes from skipping those and reaching for defaults.

Scale the process to the job. A new page or a restyle runs every step. A new component inside an existing design system skips steps 2 and 3 and follows the system.

## Steps

1. **Read the ground.** Read `DESIGN.md` at the repo root if it exists, then the existing tokens, components and one or two built screens. Existing visual language wins over anything in this skill. If there is no `DESIGN.md`, you will write it in step 3.

2. **Study references.** Spawn `ult:design-scout` with the surface, the audience and the source list from [REFERENCES.md](REFERENCES.md). It returns measured observations from 3 to 5 of the best sites for this kind of surface. Use references the user named first.

3. **Commit to a direction.** Write or update `DESIGN.md`, at most 40 lines:
   - *Audience and scene*: who uses this, on what device, in what state of mind.
   - *Mode*: **persuade** (marketing: bold, distinct), **operate** (app, dashboard: dense, calm, fast) or **read** (docs, articles: typography first).
   - *Direction*: three adjectives and the one thing a visitor should remember.
   - *Tokens*: type families and scale, color roles, spacing scale, radii, shadows, motion character.
   - *References*: what you borrow from which site and why. Ideas, never assets.

   Then choose. When torn between safe and committed, commit: a clear point of view with flaws beats a flawless average.

4. **Build on tokens.** Define the tokens as CSS variables or theme config first, then compose. No raw hex or pixel values in components. Use real copy and realistic data from the first render; lorem ipsum hides layout problems. Build every state: hover, focus, active, disabled, loading, empty, error. For component and code structure, follow `ult:garden`.

5. **Add motion last**, and only where it explains something: where a thing came from, what changed, that an input registered. Read [MOTION.md](MOTION.md) before writing any animation or gesture.

6. **Verify the render.** Start the app and look at it. Capture screenshots at 390, 768 and 1440 wide, in light and dark if both ship. Go through [CRAFT.md](CRAFT.md) against the screenshots, in one pass, and fix what fails. Tab through the page with the keyboard. Compare against the references side by side: name what still looks weaker, and fix the largest gap.

7. **Evidence.** The screenshots go in the PR as before and after.

## Rules

- **Look, do not assume.** A UI change is not done until you have seen it rendered at the sizes it ships at. If no browser tool is available, say so plainly and list what you could not check.
- **One system.** Reuse the existing component before writing a new one. A second button style needs a reason.
- **Restraint.** One accent color, spent where action is. Two type families at most. One authored moment of motion per view.
- **Accessibility is part of the floor**, not a later pass: contrast, focus, labels, keyboard, reduced motion.
- **Never invent brand assets**: no made-up logos, testimonials, customer names or statistics. Ask, or leave a clearly marked slot.

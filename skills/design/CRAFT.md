# Craft floor

Check these against the rendered result, in priority order. Each is a measurement, not an intention. The floor does not choose the direction; it catches what makes a committed direction look unfinished.

## 1. Accessibility

- Text contrast at least 4.5:1; large text and UI glyphs at least 3:1. Check placeholder and disabled text too.
- Every interactive element has a visible focus ring and is reachable in visual order by keyboard. Focus is never hidden under sticky bars.
- Icon-only buttons have an accessible name. Inputs have a visible label; a placeholder is not a label.
- One `h1`, headings in order. Meaning never carried by color alone.
- `prefers-reduced-motion` removes movement and keeps opacity changes.

## 2. Interaction

- Touch targets at least 44 by 44 px with 8 px between them. Nothing depends on hover alone.
- Feedback on press within 100 ms. Any wait over 300 ms shows progress; reserve the space so nothing jumps.
- Errors appear next to the field, say what is wrong and how to fix it, and keep what the user typed.
- Destructive actions can be undone or are confirmed. Modals only for tasks that need protected focus, and they close on Escape.

## 3. Layout

- No horizontal scroll at 390 px. No fixed-pixel container widths. Content reflows; it does not merely shrink.
- Spacing comes from the scale (4 or 8 px base). Related items sit close, groups sit apart, more space above a heading than below it.
- One clear focal point per view. If everything is emphasized, restructure.
- Images and media have reserved dimensions (no layout shift), modern formats, lazy loading below the fold.

## 4. Type

- Body at least 16 px, line height 1.5 to 1.7, measure 60 to 75 characters (`max-width: 65ch`).
- A scale with obvious steps (ratio 1.2 to 1.333). Display sizes get tighter tracking (-0.02 to -0.04em) and line height near 1.1.
- Headings balanced (`text-wrap: balance`), body `pretty`. Numbers in tables and counters use `tabular-nums`.
- Run the real copy at every breakpoint; fix overflow and orphans.

## 5. Color and depth

- Neutrals tinted toward the brand hue, never pure gray on a colored surface. Dark mode is designed, not inverted: lower contrast surfaces, no pure black with pure white.
- Semantic tokens (`--surface`, `--text-muted`, `--accent`, `--danger`), no raw values in components.
- Shadows have an offset and soft blur, layered, tinted by the surface color. Elevation means something: higher is closer.

## 6. The parts nobody draws

Themed from the palette: text selection, caret, scrollbars, focus rings, link underline offset, form autofill, the 404 page, the empty state, the loading state, favicon and social preview image. These are the cheapest signals that a page was built and not assembled.

## 7. Copy

- Buttons name their action ("Create invoice", not "Submit"). Empty states say what goes here and how to add it.
- The product's own vocabulary, consistent across the UI. Counts pluralize correctly. Old timestamps become absolute dates.

## Refuse by default

These are the tells of UI nobody decided on. Use one only when the direction in `DESIGN.md` asks for it by name.

- A grid of identical cards (icon, heading, two lines) as the page structure; cards nested in cards.
- The hero template: giant number or headline, small label, three stats, gradient accent.
- A small uppercase eyebrow label above every heading. Section numbering (01, 02, 03) that carries no information.
- Gradient text. Purple-to-blue gradients on white. Glass blur as decoration.
- A thick colored left border on cards and callouts.
- Emoji or Unicode glyphs as icons. Use one icon set at one stroke weight.
- Monospace as a costume for "technical". The system font stack as the display face of a brand page.
- Every section fading up on scroll with the same animation.
- Sparklines, progress rings and rounded gray rectangles standing in for content.
- Centered everything. Uniform rounded corners on every element regardless of size.

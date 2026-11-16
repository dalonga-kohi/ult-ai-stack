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

## 7. Holds up

- Real content at its extremes: zero, one and many items; a 40-character name; a long word with no spaces; a translated string a third longer.
- The URL carries the state a user would share or return to (tab, filter, page, open item). Back works. A refresh keeps the place.
- The page title, favicon and social preview are the product's own, not the framework's.
- The browser console is clean: no errors, no hydration warnings, no failed requests.
- Every link, button and field does something real.

What makes a finished page look generated is in `SLOP.md`; the words on it are covered by `COPY.md`.

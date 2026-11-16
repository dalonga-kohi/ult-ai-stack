# Motion

Motion is for meaning: where something came from, what changed, that an input landed. If an animation explains nothing, remove it. The more often a user sees an animation, the shorter and quieter it must be; actions repeated all day (keyboard shortcuts, command palette, typing) get none.

## Timing

| Element | Duration |
| --- | --- |
| Press feedback | 100 to 160 ms |
| Tooltip, small popover | 125 to 200 ms |
| Dropdown, select | 150 to 250 ms |
| Modal, drawer, sheet | 200 to 500 ms |

UI motion stays under 300 ms, except modals, drawers, sheets and toasts. Exits are faster than entrances. Stagger 30 to 80 ms between items and never block input while it plays.

## Easing

```css
--ease-out: cubic-bezier(0.23, 1, 0.32, 1);       /* entering, responding: the default */
--ease-in-out: cubic-bezier(0.77, 0, 0.175, 1);   /* moving on screen from A to B */
--ease-drawer: cubic-bezier(0.32, 0.72, 0, 1);    /* sheets and drawers */
```

- Never `ease-in` for UI: it starts slow and feels unresponsive.
- Never `transition: all`. List the properties.
- Never animate from `scale(0)`; start around `scale(0.95)` with opacity 0.
- `transform-origin` at the trigger for popovers and menus; modals stay centered.

## Springs, for anything the user can touch

A fixed-duration animation cannot respond to new input; a spring can. Think in two parameters: damping (1.0 is no overshoot) and response (seconds to settle).

| Interaction | Damping | Response |
| --- | --- | --- |
| Move, reposition | 1.0 | 0.4 |
| Drawer, sheet | 0.8 | 0.3 |
| Rotation | 0.8 | 0.4 |

```js
animate(el, { y: 0 }, { type: "spring", bounce: 0, duration: 0.4 });      // default
animate(el, { y: t }, { type: "spring", bounce: 0.2, duration: 0.4 });    // after a flick
```

Default to no bounce. Add a little (0.1 to 0.3) only when the gesture itself carried momentum.

## Gestures

- **Respond on pointer down**, not on release. `:active { transform: scale(0.97) }`.
- **Track 1:1.** While dragging, the element follows the pointer exactly, from the point it was grabbed. Use Pointer Events with `setPointerCapture`.
- **Always interruptible.** Never lock input during a transition. A new animation starts from the element's current on-screen value, not from its target.
- **Hand off velocity.** On release, the animation continues at the pointer's velocity.
- **Project momentum.** Choose the snap target from where the gesture is going, not where it was released:
  `projected = position + (velocity / 1000) * 0.998 / (1 - 0.998)`.
- **Resist at edges.** Past a boundary, movement is damped (rubber band), never hard-stopped.
- **Symmetric paths.** Things leave the way they came, so the user learns where they live.

## Performance

- Animate `transform` and `opacity`. Not `width`, `height`, `top`, `left`, `margin`.
- Per-frame values go to `ref.current.style` or motion values, never to React state.
- Animated `blur()` under 20 px. `will-change` only after you see a problem.
- Long lists virtualize.

## Reduced motion

Under `prefers-reduced-motion: reduce`, replace movement and scale with a short opacity fade or nothing. Keep feedback; drop travel.

Values distilled from Emil Kowalski's skills and Apple's "Designing Fluid Interfaces" (see CREDITS.md).

# Slop: the tells of UI nobody decided

A tell is a choice made because it was the first one available, and it is now on a hundred thousand generated pages. A visitor who spots three stops trusting the rest. Use one only when the direction in `DESIGN.md` asks for it by name.

Removing a tell is not enough. The next most common default moves in: the purple gradient becomes a teal gradient, Inter becomes Space Grotesk. Replace each tell with a choice you can trace to this product, this audience or this content.

## Three tests

- **Swap.** Put a competitor's logo and nouns on the page. If it still works, nothing on it was decided for this product.
- **Trace.** Point at any choice (the typeface, the accent, the shape of the hero) and name what about the product or the audience led to it. "It looks clean" and "it looks modern" are not answers.
- **Subtract.** Take away each badge, glow, icon, divider and animation in turn. If nothing was lost, leave it out.

## Structure

- The stock landing page in its stock order: hero, logo row, three feature cards, numbered "how it works", testimonials, three pricing tiers with the middle one raised, FAQ accordion, gradient call-to-action band, four-column footer. Instead: order the page by the questions this visitor asks, in the order they ask them, and drop any section that has nothing true to say.
- The stock hero: pill badge ("New", "Introducing"), centered headline, muted subtitle, a filled button beside a ghost button, a screenshot in a fake browser frame. Instead: lead with the most concrete proof there is, usually the product doing its job.
- The stock dashboard: four KPI cards with a trend percentage, one chart, a recent-activity table, an icon sidebar. Instead: lead with what this user came to do or decide today.
- A grid of identical cards (icon, heading, two lines) as the page structure. Bento grids by reflex. Cards nested in cards. A border, a radius and a shadow around every group. Instead: a card is an object the user can act on; group everything else with space, alignment and type.
- Every section built alike: centered heading, muted subtitle, the same padding. Centered everything.
- A small uppercase eyebrow label above every heading. Section numbering (01, 02, 03) that carries no information.

## Color and surface

- Purple, indigo or violet as the accent. Any two-hue gradient standing in for a brand. Gradient text.
- Blurred color blobs or a mesh behind the hero. Glow shadows. Gradient borders. Glass blur as decoration. A dot or grid pattern fading out radially.
- Near-black navy with a neon accent as the "tech" look. Dark mode chosen for no reason.
- The untouched defaults of the toolkit: the stock Tailwind palette, an unmodified component-library theme.
- A thick colored left border on cards and callouts.
- Instead: one hue with a reason (the product's material, its category's convention, or a deliberate break from it), spent in one place, with neutrals tinted from it.

## Type

- Inter, Geist or the system stack everywhere because it was already installed. The system stack as the display face of a brand page.
- The second defaults, picked to look distinctive: Space Grotesk, Plus Jakarta Sans, Playfair Display, Instrument Serif.
- One italic serif word, or one gradient word, inside a sans headline.
- Monospace as a costume for "technical". Wide-tracked uppercase micro labels everywhere.
- Instead: choose the family for the mode and the voice in `DESIGN.md`, and make hierarchy from size and weight steps large enough to see at a glance.

## Decoration

- Emoji or Unicode glyphs as icons. Sparkles for anything with a model in it. Use one icon set at one stroke weight.
- An icon in a tinted rounded square on top of every card. Green-check bullet lists. Pills and badges on everything. An arrow in every button. A pulsing status dot.
- Fake window chrome (three dots) around screenshots and code.
- The same large radius on every element regardless of its size. A shadow and a border on the same box.
- Sparklines, progress rings and gray rounded rectangles standing in for content.

## Motion

- Every section fading up on scroll with the same animation. Cards that scale or lift on hover.
- Count-up numbers, typewriter headlines, a logo marquee, a drifting gradient.

## Content and wiring

These give away a generated app faster than any visual.

- Invented proof: testimonials, customer logos, star ratings, avatar stacks ("loved by 10,000+"), round statistics.
- Placeholder people and companies (John Doe, Acme), lorem ipsum, images from a placeholder service.
- Controls that do nothing: `href="#"`, navigation to pages that do not exist, a search box that does not search, social icons that go nowhere, settings that do not persist.
- Starter leftovers: the framework's page title and favicon, the starter README, example routes, unused boilerplate assets.
- A footer year that is already in the past.
- Instead: ship less, all of it real. What is not built is not shown.

The subset a regex can find is in `tells.txt`; the design skill's verify step runs it.

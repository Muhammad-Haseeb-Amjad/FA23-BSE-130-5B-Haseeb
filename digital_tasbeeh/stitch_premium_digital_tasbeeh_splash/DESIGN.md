---
name: Premium Spiritual Design System
colors:
  surface: '#121413'
  surface-dim: '#121413'
  surface-bright: '#383939'
  surface-container-lowest: '#0d0f0e'
  surface-container-low: '#1a1c1b'
  surface-container: '#1e201f'
  surface-container-high: '#292a2a'
  surface-container-highest: '#343534'
  on-surface: '#e3e2e1'
  on-surface-variant: '#c1c8c6'
  inverse-surface: '#e3e2e1'
  inverse-on-surface: '#2f3130'
  outline: '#8b9290'
  outline-variant: '#414847'
  surface-tint: '#accdc7'
  primary: '#accdc7'
  on-primary: '#163531'
  primary-container: '#0f2f2b'
  on-primary-container: '#779892'
  inverse-primary: '#45645f'
  secondary: '#55e16b'
  on-secondary: '#00390f'
  secondary-container: '#02ad3f'
  on-secondary-container: '#00370e'
  tertiary: '#e9c349'
  on-tertiary: '#3c2f00'
  tertiary-container: '#cca730'
  on-tertiary-container: '#4f3d00'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#c8e9e3'
  primary-fixed-dim: '#accdc7'
  on-primary-fixed: '#00201d'
  on-primary-fixed-variant: '#2e4c48'
  secondary-fixed: '#73fe84'
  secondary-fixed-dim: '#55e16b'
  on-secondary-fixed: '#002106'
  on-secondary-fixed-variant: '#005319'
  tertiary-fixed: '#ffe088'
  tertiary-fixed-dim: '#e9c349'
  on-tertiary-fixed: '#241a00'
  on-tertiary-fixed-variant: '#574500'
  background: '#121413'
  on-background: '#e3e2e1'
  surface-variant: '#343534'
typography:
  display-lg:
    fontFamily: notoSerif
    fontSize: 48px
    fontWeight: '600'
    lineHeight: '1.1'
    letterSpacing: -0.02em
  headline-md:
    fontFamily: notoSerif
    fontSize: 28px
    fontWeight: '500'
    lineHeight: '1.3'
  title-sm:
    fontFamily: manrope
    fontSize: 18px
    fontWeight: '600'
    lineHeight: '1.5'
    letterSpacing: 0.05em
  body-md:
    fontFamily: manrope
    fontSize: 16px
    fontWeight: '400'
    lineHeight: '1.6'
  label-caps:
    fontFamily: manrope
    fontSize: 12px
    fontWeight: '700'
    lineHeight: '1.2'
    letterSpacing: 0.1em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  unit: 8px
  container-padding: 32px
  stack-gap: 24px
  inline-gap: 16px
  safe-area-bottom: 40px
---

## Brand & Style

The design system is centered around the concept of a "Digital Sanctuary"—a focused, serene environment that facilitates spiritual devotion and mindfulness. The brand personality is dignified, reverent, and quietly sophisticated. It aims to evoke a sense of timelessness, bridging the gap between ancient tradition and modern digital utility.

The aesthetic follows a **High-Fidelity Minimalism** style. It utilizes deep, immersive depth through layers of dark greens, punctuated by soft light sources that mimic the glow of a lantern or moonlight. Visual interest is achieved not through clutter, but through the interplay of shadow, subtle geometric textures, and refined metallic accents. Every interaction should feel intentional and graceful, avoiding jarring movements in favor of slow, ease-in-out transitions that mirror the rhythm of breath.

## Colors

The palette is rooted in the "Sacred Green" spectrum. This design system uses a dark-mode-only foundation to ensure visual comfort during nighttime prayers and to create a focused, immersive field of view.

- **Primary Backgrounds:** A deep, radial gradient transition from `#123D38` at the top-center to `#0B2623` at the edges, creating a natural vignette that draws the eye to the center of the screen.
- **Emerald Accents:** Used sparingly for active states or completion indicators, providing a vibrant but soft luminescence.
- **Elegant Gold:** Reserved for branding elements, borders of primary action containers, and significant milestones.
- **Surface Tiers:** UI cards and containers use a slightly lighter, desaturated version of the primary green (`#1A4D47`) with low opacity to maintain a sense of glass-like transparency.

## Typography

This design system employs a sophisticated typographic hierarchy that pairs the classical elegance of **Noto Serif** with the functional clarity of **Manrope**.

- **Noto Serif** is used for headlines and numerical counters. Its high-contrast strokes and traditional serifs echo the calligraphic history of Islamic arts, providing a sense of authority and grace.
- **Manrope** serves as the primary engine for body text, labels, and navigation elements. Its geometric but warm construction ensures legibility at small sizes while maintaining a modern, clean feel.
- **Stylistic Note:** All labels and secondary titles should use increased letter spacing to create a more "airy" and premium feel. Numerical counters should always use Noto Serif to emphasize the ritualistic nature of the count.

## Layout & Spacing

The layout philosophy follows a **Centered Contemplative Model**. Content is vertically stacked and centered to promote a focused, meditative user experience. 

- **Grid:** A standard 8px rhythmic grid is used, but the visual priority is on generous whitespace.
- **Margins:** High-fidelity layouts require wide margins (minimum 32px) to ensure the content never feels cramped against the edges of the device.
- **Alignment:** 90% of UI elements—including text, buttons, and counters—are center-aligned. This symmetry reinforces the sense of balance and calm.
- **Visual Breathing Room:** Vertical stacks are spaced aggressively to allow the background gradients and subtle geometric patterns to be visible, preventing a cluttered "app" feel.

## Elevation & Depth

This design system avoids harsh drop shadows in favor of **Luminous Depth**. Hierarchy is established through the following techniques:

- **Radial Glows:** Instead of traditional shadows, elevated elements are surrounded by a soft, low-opacity emerald or gold glow that appears to emanate from behind the component.
- **Backdrop Blurs:** Secondary surfaces use a high-saturation background blur (20px-30px) combined with a 10% white tint to create a "Frosted Emerald Glass" effect.
- **Subtle Patterns:** A very low-opacity (2-4%) Islamic geometric pattern (e.g., an 8-point star) is tiled across the background layer. When a card is placed above it, the pattern is blurred, naturally creating a sense of physical distance between layers.
- **Inner Glows:** Buttons and active cards feature a subtle 1px inner border in a lighter green to define edges without using high-contrast outlines.

## Shapes

The shape language is organic and soft, avoiding sharp corners that might feel aggressive or overly technical.

- **Base Radius:** Elements use a `0.5rem` (8px) base radius, but primary cards and the main Tasbeeh interaction area utilize `1.5rem` (24px) for a more substantial, cradled feel.
- **Geometric Motifs:** While UI containers are rounded rectangles, decorative elements may incorporate more traditional geometric shapes like the *Rub el Hizb* (eight-pointed star) as subtle icons or watermarks.
- **Pill Shapes:** Interactive chips and the primary counter button are fully rounded (pill-shaped) to invite tactile interaction.

## Components

### Primary Counter (The Heart)
The central interaction point. It should be a large, circular or soft-square glass vessel. The number inside uses **Noto Serif Display**. Upon each tap, a subtle radial pulse of emerald light should ripple outward.

### Navigation Bar
A floating, translucent glass bar at the bottom of the screen. Icons should be thin-stroke (1.5pt) gold or soft emerald. No labels are used here to maintain a minimalist aesthetic; visual clarity depends on iconic metaphors.

### Buttons
Primary actions are styled as "Golden Outlines"—a transparent background with a 1.5px gold stroke and gold text. Secondary actions are "Emerald Glass," using a semi-transparent green fill with no border.

### Progress Indicators
Instead of linear bars, progress is shown through a thin circular stroke around the primary counter. This stroke should be a subtle gold line that "illuminates" as the goal is approached.

### Lists & Settings
Grouped in containers with 20px padding. Each list item is separated by a 1px divider with a 5% white opacity, ensuring the division is felt rather than seen.

### Haptic Feedback
While not a visual component, haptic feedback is a core requirement of this design system. Every count should trigger a soft, "taptic" pulse that mimics the feel of a physical prayer bead clicking into place.
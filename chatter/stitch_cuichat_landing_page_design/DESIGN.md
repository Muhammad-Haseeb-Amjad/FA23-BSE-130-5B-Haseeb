---
name: Lumina Academic
colors:
  surface: '#faf8ff'
  surface-dim: '#dad9e0'
  surface-bright: '#faf8ff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f4f3f9'
  surface-container: '#efedf3'
  surface-container-high: '#e9e7ee'
  surface-container-highest: '#e3e2e8'
  on-surface: '#1a1b20'
  on-surface-variant: '#444650'
  inverse-surface: '#2f3035'
  inverse-on-surface: '#f1f0f6'
  outline: '#757682'
  outline-variant: '#c5c6d2'
  surface-tint: '#435b9f'
  primary: '#00113a'
  on-primary: '#ffffff'
  primary-container: '#002366'
  on-primary-container: '#758dd5'
  inverse-primary: '#b3c5ff'
  secondary: '#8333c6'
  on-secondary: '#ffffff'
  secondary-container: '#b96cfd'
  on-secondary-container: '#41006f'
  tertiary: '#2d0700'
  on-tertiary: '#ffffff'
  tertiary-container: '#501300'
  on-tertiary-container: '#d37758'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#dbe1ff'
  primary-fixed-dim: '#b3c5ff'
  on-primary-fixed: '#00174a'
  on-primary-fixed-variant: '#2a4386'
  secondary-fixed: '#f1daff'
  secondary-fixed-dim: '#dfb7ff'
  on-secondary-fixed: '#2d004f'
  on-secondary-fixed-variant: '#690bac'
  tertiary-fixed: '#ffdbd0'
  tertiary-fixed-dim: '#ffb59e'
  on-tertiary-fixed: '#390b00'
  on-tertiary-fixed-variant: '#783018'
  background: '#faf8ff'
  on-background: '#1a1b20'
  surface-variant: '#e3e2e8'
typography:
  h1:
    fontFamily: Manrope
    fontSize: 48px
    fontWeight: '800'
    lineHeight: '1.2'
    letterSpacing: -0.02em
  h2:
    fontFamily: Manrope
    fontSize: 32px
    fontWeight: '700'
    lineHeight: '1.3'
    letterSpacing: -0.01em
  h3:
    fontFamily: Manrope
    fontSize: 24px
    fontWeight: '600'
    lineHeight: '1.4'
    letterSpacing: '0'
  body-lg:
    fontFamily: Manrope
    fontSize: 18px
    fontWeight: '400'
    lineHeight: '1.6'
    letterSpacing: '0'
  body-md:
    fontFamily: Manrope
    fontSize: 16px
    fontWeight: '400'
    lineHeight: '1.6'
    letterSpacing: '0'
  label-caps:
    fontFamily: Manrope
    fontSize: 12px
    fontWeight: '700'
    lineHeight: '1'
    letterSpacing: 0.1em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  unit: 4px
  xs: 8px
  sm: 16px
  md: 24px
  lg: 48px
  xl: 80px
  container-max: 1280px
  gutter: 24px
---

## Brand & Style

The design system is engineered to bridge the gap between academic prestige and modern digital social dynamics. It evokes a sense of "Intellectual Sophistication," characterized by a professional architecture that feels both grounded and visionary. 

The visual language utilizes a **Modern Glassmorphism** approach blended with **Premium Minimalism**. This means high-density information is organized through clean, spacious layouts, while the "social" aspects of the platform are elevated through translucent layers, soft-focus gradients, and ethereal glows. The emotional goal is to make the user feel like they are entering a high-end, exclusive digital campus that values both focus and community.

## Colors

The palette is anchored by **Deep Royal Blue**, representing the institutional authority and trust of a university. This is offset by **Purple / Violet**, which introduces a creative, social energy. 

Contrast is achieved through two distinct modes of application:
- **Surface Foundations:** A crisp, light SaaS background (#F8FAFC) ensures readability and a professional workspace feel.
- **Dynamic Accents:** Soft Blue Glow and Subtle Cyan are used sparingly for interactive states, progress indicators, and "active" social zones.
- **Depth Gradients:** Linear gradients transition from the Primary Blue to the Secondary Purple at a 135-degree angle to signify premium areas like user profiles or featured community headers.

## Typography

The design system utilizes **Manrope** across all interfaces. This typeface was chosen for its geometric balance and modern proportions, which feel technical yet accessible. 

Hierarchy is established through aggressive weight scaling. Headlines use extra-bold weights with slight negative letter-spacing to create a compact, "editorial" impact. Body text maintains a generous line height (1.6) to ensure long-form academic discussions remain readable. Small labels and metadata utilize an uppercase, tracked-out style to distinguish them from interactive content.

## Layout & Spacing

This design system follows a **Fixed Grid** philosophy for desktop experiences to maintain a "contained" and professional feel, while transitioning to a fluid model for mobile. 

- **Grid:** A 12-column layout with 24px gutters.
- **Rhythm:** An 8px linear scale governs all padding and margins. 
- **White Space:** Intentional "macro-spacing" (48px+) is used between major sections to prevent information fatigue, characteristic of high-end SaaS platforms. Content density is kept moderate to allow the glassmorphic effects and shadows room to breathe.

## Elevation & Depth

Depth in this design system is not just about height, but about **translucency and light**.

1.  **Glass Layers:** Primary containers use a background blur (Backdrop-filter: blur(12px)) with a 60-80% opacity fill. These layers are rimmed with a 1px "inner glow" border (white at 10% opacity) to catch the light.
2.  **Layered Shadows:** Instead of heavy black shadows, the system uses "Tinted Ambient Shadows." These are multi-layered shadows with a slight hue shift toward the Primary Blue, creating a softer, more natural lift from the page.
3.  **Luminous Glows:** Interactive elements like active chat bubbles or notifications utilize a soft outer glow (drop-shadow) using the Accent Blue, suggesting the element is "powered on."

## Shapes

The shape language is defined by **Smooth Continuity**. Corners are generously rounded to soften the professional tone, making the platform feel welcoming.

- **Standard Components:** Buttons and input fields use a 12px (0.5rem) radius.
- **Containers:** Cards and modals use a 24px (1.5rem) radius to emphasize the "glass tile" aesthetic.
- **Interactive Indicators:** Small badges and chips are fully pill-shaped to contrast against the more structured rectangular forms of the main UI.

## Components

### Buttons
Buttons are high-contrast. **Primary buttons** use a linear gradient (Deep Royal Blue to Purple) with a subtle white inner-border. **Secondary buttons** are glass-based with a translucent background and a 1px cyan border.

### Cards & Glass Tiles
Cards do not have visible solid borders. Instead, they rely on a combination of a backdrop blur and a very faint, 1px light-colored stroke. They should feel like physical panes of frosted glass floating above the soft gray background.

### Inputs
Form fields are minimalist. They feature a soft gray fill (#F1F5F9) that transitions to a Subtle Cyan glow on focus. Labels sit clearly above the input in the `label-caps` typography style.

### Navigation
The sidebar or top navigation utilizes "Active State Glows." When a menu item is selected, it should be marked with a vertical or horizontal cyan line that has a blurred glow effect behind it.

### Social Specifics
- **Chat Bubbles:** The user's own messages use the Royal Blue/Purple gradient; received messages use the Glassmorphic white style.
- **Feed Items:** Posts are separated by generous whitespace and utilize "Elevation 2" shadows to stack cleanly.
---
name: CUICHAT
colors:
  surface: '#f9f9ff'
  surface-dim: '#c6dbff'
  surface-bright: '#f9f9ff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#eff3ff'
  surface-container: '#e6eeff'
  surface-container-high: '#dde9ff'
  surface-container-highest: '#d4e3ff'
  on-surface: '#001c3a'
  on-surface-variant: '#444650'
  inverse-surface: '#163152'
  inverse-on-surface: '#ebf1ff'
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
  tertiary: '#001717'
  on-tertiary: '#ffffff'
  tertiary-container: '#002e2e'
  on-tertiary-container: '#00a0a0'
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
  tertiary-fixed: '#00fbfb'
  tertiary-fixed-dim: '#00dddd'
  on-tertiary-fixed: '#002020'
  on-tertiary-fixed-variant: '#004f4f'
  background: '#f9f9ff'
  on-background: '#001c3a'
  surface-variant: '#d4e3ff'
typography:
  headline-xl:
    fontFamily: Plus Jakarta Sans
    fontSize: 48px
    fontWeight: '800'
    lineHeight: '1.1'
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 32px
    fontWeight: '700'
    lineHeight: '1.2'
    letterSpacing: -0.01em
  headline-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 24px
    fontWeight: '700'
    lineHeight: '1.3'
  headline-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 20px
    fontWeight: '600'
    lineHeight: '1.4'
  body-lg:
    fontFamily: Manrope
    fontSize: 18px
    fontWeight: '400'
    lineHeight: '1.6'
  body-md:
    fontFamily: Manrope
    fontSize: 16px
    fontWeight: '400'
    lineHeight: '1.6'
  body-sm:
    fontFamily: Manrope
    fontSize: 14px
    fontWeight: '400'
    lineHeight: '1.5'
  label-md:
    fontFamily: Manrope
    fontSize: 12px
    fontWeight: '600'
    lineHeight: '1'
    letterSpacing: 0.05em
  headline-lg-mobile:
    fontFamily: Plus Jakarta Sans
    fontSize: 28px
    fontWeight: '700'
    lineHeight: '1.2'
rounded:
  sm: 0.5rem
  DEFAULT: 1rem
  md: 1.5rem
  lg: 2rem
  xl: 3rem
  full: 9999px
spacing:
  unit: 4px
  xs: 4px
  sm: 8px
  md: 16px
  lg: 24px
  xl: 40px
  xxl: 64px
  container-max: 1280px
  gutter: 24px
  margin-mobile: 16px
  margin-desktop: 48px
---

## Brand & Style
This design system is built upon a foundation of **Modern Minimalism** infused with **Glassmorphism**. It is designed to evoke a sense of prestigious academic community combined with cutting-edge digital connectivity. The target audience—students and faculty of COMSATS University—expects a platform that feels both authoritative and vibrant.

The visual narrative prioritizes breathing room, using wide margins and generous whitespace to maintain a "high-end" feel. Depth is created not through heavy borders, but through layered translucency, soft ambient glows, and subtle mesh gradients that mimic physical light passing through frosted glass.

## Colors
The palette is rooted in a "Academic Elite" aesthetic. The **Deep Royal Blue** provides a stable, institutional foundation, while the **Rich Purple** adds a layer of modern, social energy. 

- **Primary & Secondary:** Use these for high-level branding, primary actions, and active states.
- **Accents:** The **Cyan Glow** (#00FFFF) should be used sparingly for "active" indicators, notification pings, or thin borders to simulate light emission. 
- **Backgrounds:** Avoid pure white. Use the light lavender tints to maintain a soft, premium feel that reduces eye strain during long study or social sessions.
- **Typography:** Contrast is maintained by using a dark navy for high-level hierarchy and a muted gray-blue for long-form body text to keep the interface feeling "airy."

## Typography
This design system utilizes **Plus Jakarta Sans** for headlines to provide a modern, geometric, and friendly character. Its high x-height and open counters ensure legibility even at significant weights.

For body text and UI labels, **Manrope** is employed. It offers a more technical and balanced structure that excels in data-rich SaaS environments and social feeds. 

**Hierarchy Rules:**
- Use **Headline XL** only for hero sections or major landing gates.
- Maintain a generous line-height (1.6) for body text to support the "spacious" visual style.
- Use uppercase for **Label MD** to differentiate metadata from interactive text.

## Layout & Spacing
The layout follows a **12-column fluid grid** for desktop, transitioning to a **4-column grid** for mobile. The philosophy is "Extreme Margin" — content should never feel cramped against the edges of the viewport or its container.

- **Desktop:** 12 columns / 24px gutter / 48px minimum side margins.
- **Tablet:** 8 columns / 20px gutter / 32px side margins.
- **Mobile:** 4 columns / 16px gutter / 16px side margins.

Spacing follows an 8pt rhythm (base 4px). Use `xxl` (64px) for vertical section separation to maintain the premium, spacious feel of the design system.

## Elevation & Depth
Depth in this design system is achieved through **Ambient Glows** and **Glassmorphism** rather than traditional "drop shadows."

1.  **Level 0 (Base):** Off-white background with subtle mesh gradients in corners.
2.  **Level 1 (Floating Cards):** Semi-transparent white (#FFFFFFCC) with a 20px backdrop blur. Shadows are extra-diffused: `0 8px 32px rgba(0, 31, 63, 0.04)`.
3.  **Level 2 (Modals/Popovers):** Higher opacity, `40px` backdrop blur. Shadow: `0 16px 48px rgba(0, 35, 102, 0.08)`.
4.  **Glow Effects:** Use a `box-shadow` with the Primary or Secondary color at 20% opacity and large blur radii (30px+) to create "soft light" behind interactive elements like active buttons or badges.

## Shapes
The shape language is dominated by **Pill-shaped (3)** and large rounded corners. This removes any "sharpness" from the UI, making the ecosystem feel inviting and modern.

- **Buttons & Badges:** Always use full-pill rounding (e.g., 9999px).
- **Cards:** Use `rounded-xl` (1.5rem / 24px) to complement the spacious layout.
- **Inputs:** Use `rounded-lg` (1rem / 16px) for a balanced look.
- **Selection States:** Use a 4px "Soft" radius for internal focus indicators within a larger pill container.

## Components
Consistent implementation of these components ensures the premium SaaS feel:

- **Gradient Buttons:** Primary buttons use a linear gradient from **Deep Royal Blue** to **Rich Purple** (45 degrees). They feature a `0 4px 15px` glow in the secondary color that intensifies on hover.
- **Glowing Badges:** Small status indicators or tags with a solid background and a matching 8px outer blur (e.g., a "New" tag with a soft cyan glow).
- **Floating UI Cards:** Must have a `1px` border using a semi-transparent version of the light lavender tint (#E0E7FF80) to define edges against the background without adding visual weight.
- **Input Fields:** Minimalist design with a light lavender background and a `1px` stroke that glows **Cyan** when focused.
- **Icons:** Use thin-stroke (1.5px) monolinear icons. Avoid filled icons unless they represent an active state (e.g., a filled "heart" for a liked post).
- **Glass Headers:** Top navigation should always use the glassmorphism effect (backdrop blur) to allow the mesh gradients of the background to peek through as the user scrolls.
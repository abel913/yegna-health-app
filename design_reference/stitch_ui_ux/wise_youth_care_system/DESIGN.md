---
name: Wise Youth Care System
colors:
  surface: '#faf8ff'
  surface-dim: '#d2d9f4'
  surface-bright: '#faf8ff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f2f3ff'
  surface-container: '#eaedff'
  surface-container-high: '#e2e7ff'
  surface-container-highest: '#dae2fd'
  on-surface: '#131b2e'
  on-surface-variant: '#3f484c'
  inverse-surface: '#283044'
  inverse-on-surface: '#eef0ff'
  outline: '#6f787d'
  outline-variant: '#bec8cd'
  surface-tint: '#006781'
  primary: '#005a71'
  on-primary: '#ffffff'
  primary-container: '#0e7490'
  on-primary-container: '#d3f1ff'
  inverse-primary: '#81d1f0'
  secondary: '#006398'
  on-secondary: '#ffffff'
  secondary-container: '#5bb8fe'
  on-secondary-container: '#00476e'
  tertiary: '#005f40'
  on-tertiary: '#ffffff'
  tertiary-container: '#007a53'
  on-tertiary-container: '#a3ffd0'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#b9eaff'
  primary-fixed-dim: '#81d1f0'
  on-primary-fixed: '#001f29'
  on-primary-fixed-variant: '#004d62'
  secondary-fixed: '#cce5ff'
  secondary-fixed-dim: '#93ccff'
  on-secondary-fixed: '#001d31'
  on-secondary-fixed-variant: '#004b73'
  tertiary-fixed: '#6ffbbe'
  tertiary-fixed-dim: '#4edea3'
  on-tertiary-fixed: '#002113'
  on-tertiary-fixed-variant: '#005236'
  background: '#faf8ff'
  on-background: '#131b2e'
  surface-variant: '#dae2fd'
typography:
  headline-xl:
    fontFamily: Inter
    fontSize: 30px
    fontWeight: '700'
    lineHeight: 38px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Inter
    fontSize: 22px
    fontWeight: '700'
    lineHeight: 28px
    letterSpacing: -0.015em
  headline-md:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 24px
  body-lg:
    fontFamily: Inter
    fontSize: 15px
    fontWeight: '400'
    lineHeight: 22px
  body-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  body-sm:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 17px
  label-md:
    fontFamily: Inter
    fontSize: 13px
    fontWeight: '600'
    lineHeight: 18px
  label-sm:
    fontFamily: Inter
    fontSize: 11px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.04em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 1rem
  margin: 1.25rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 0.75rem
  space-lg: 1.25rem
  space-xl: 1.75rem
---

## Brand & Style

This design system is tailored for youth empowerment, peer support, and confidential sexual and reproductive health (SRH) education across Ethiopia. It balances clinical credibility with a warm, youth-centered ethos. The visual tone is empathetic, discreet, uplifting, and safe—dispelling fear, judgment, and stigma surrounding youth health.

The aesthetic blends **Modern Clinical Polish** with **Soft Neomorphic Tactility**:
- Gentle, airy backgrounds carrying ambient cyan-to-sky skyward gradients.
- Pill-shaped accents and rounded, friendly surface geometries that avoid institutional rigidity.
- Dual-script visual parity: seamless readability across English (Latin) and Amharic (Ethiopic fidäl script) with calibrated line metrics.
- Elevated focus cards with translucent hairline borders, soft drop shadows, and luminous active states.

## Colors

The color palette grounds clinical confidence in deep aquatic teals and accessible ocean blues, accented by affirmative botanical greens and tranquil pastel surfaces.

- **Primary (`#0E7490` - Deep Cyan / Teal):** Provides authoritative yet approachable weight for primary action buttons, selected tab triggers, active indicators, and high-priority headers.
- **Secondary (`#0284C7` - Ocean Blue):** Guides interactive focus, secondary highlights, floating action beacons, and communicative subheadings.
- **Tertiary (`#10B981` with `#F0FDF4` tint - Safe Leaf Green):** Communicates safe zones, confidential status, health verification, and low-risk diagnostic assessments.
- **Neutral (`#0F172A` - Slate Ink):** Delivers crisp, high-contrast readability for headers and body copy against cool white backgrounds.
- **Canvas & Surface Tier:**
  - Base Background: `#F8FAFC` to `#F0F9FF` soft vertical atmospheric gradient.
  - Surface Pure: `#FFFFFF` for primary cards and content modules.
  - Soft Border: `#E2E8F0` with subtle teal-tinted alpha (`rgba(14, 116, 144, 0.12)`).
  - Chip & Muted Background: `#E0F2FE` (Sky 100) and `#ECFEFF` (Cyan 50).

## Typography

Typography prioritizes legibility across mobile displays with special accommodation for Amharic script metrics:

- **Font Pairing & Font Fallbacks:** 
  - `Inter` serves as the primary Latin engine.
  - Pair dynamically with `Noto Sans Ethiopic` for Amharic (አማርኛ) copy via standard font stack: `"Inter", "Noto Sans Ethiopic", system-ui, sans-serif`.
- **Amharic Script Adjustments:**
  - Amharic glyphs possess distinct baseline-to-ascender ratios. When rendered in Amharic, maintain a minimum `1.5x` to `1.6x` line-height ratio to prevent diacritics and character collisions.
- **Hierarchy Structure:**
  - `headline-xl`: Screen titles and primary hero greetings (e.g., "Welcome to Wise Youth / እንኳን ደህና መጡ").
  - `headline-lg`: Card titles, module headers, and mentor names.
  - `headline-md`: Secondary subsection titles and facility headers.
  - `body-lg` & `body-md`: Educational summaries, FAQs, and facility address descriptions.
  - `label-md` & `label-sm`: Category badges, module numbers, and navigation bar labels.

## Layout & Spacing

The layout model is optimized for high thumb-zone reachability on modern handheld devices:

- **Grid Architecture:** 
  - Mobile: Fluid single-column stack with standard `1.25rem` (20px) horizontal safe gutters.
  - Tablet/Foldables: 6-to-8 column system with max container width constrained to `640px` for mobile centered presentation.
- **Card Spacing:** 
  - Standard card interior padding utilizes `space-lg` (20px) for prominent hero banners and `space-md` (12px) for structured directory rows.
  - Vertical stacking rhythm maintains `space-md` (12px) to `space-lg` (20px) between card modules.
- **Fixed Bottom Navigation:** 
  - Retains a fixed height of `68px` plus device-safe-area padding, preserving clearance above the bottom edge.

## Elevation & Depth

Visual depth is achieved through high-diffusion oceanic ambient shadows combined with subtle border rings:

- **Ambient Layer 0 (Base Canvas):** Flat cool tone (`#F8FAFC`) with top radial wash in `#E0F2FE` (opacity 40%).
- **Ambient Layer 1 (Surface Cards):**
  - Pure `#FFFFFF` background.
  - Border: 1px solid `rgba(226, 232, 240, 0.8)`.
  - Box-shadow: `0 8px 24px -4px rgba(14, 116, 144, 0.06), 0 2px 6px -1px rgba(15, 23, 42, 0.03)`.
- **Ambient Layer 2 (Active/Floating Badges & Nav Hub):**
  - Box-shadow: `0 12px 28px -6px rgba(14, 116, 144, 0.22), 0 4px 10px -2px rgba(14, 116, 144, 0.12)`.
  - Used for the centered circular active navigation icon, floating emergency calls, and featured learning carousels.

## Shapes

The interface embraces organic, friendly rounded forms that reduce clinical intimidation:

- **Base Radius (Roundedness 2):** Standard inputs, regular actionable chips, and alert boxes use `0.75rem` (12px).
- **Module Cards:** Outer container cards employ `rounded-xl` (`1.25rem` / 20px) to `1.5rem` (24px) for prominent tactile enclosure.
- **Pill Primitives:** Buttons, filter tags, notification status counters, bilingual toggle switches, and telephone contact circular actions implement full pill geometries (`border-radius: 9999px`).

## Components

### Buttons
- **Primary Action:** Solid `#0E7490` pill button with white text, font weight 600, padding `12px 24px`. Hover/Active transitions to `#155E75` with subtle scale (`0.98`).
- **Secondary / Outlined:** White surface with 1.5px border in `#0E7490` or `#BAE6FD`, deep teal text, rounded-full geometry.
- **Quick Contact Floating Circle:** 44px x 44px circular solid `#0E7490` button housing a centered telephone or chat glyph.

### Cards & Directories
- **Action Module Card:** Large elevated white card, 20px padding, subtle border. Divided into an illustrated top banner, module label tag (`MODULE 01`), headline, summary text, and split action pills (`More →` and `Take Quiz`).
- **Directory Tile (Mentors & Facilities):** Horizontal layout featuring avatar monogram circle (`48px` diameter, `#E0F2FE` fill, `#0E7490` label), mentor/facility details, distance badge, and direct call trigger on the trailing edge.

### Bilingual Toggle Pill
- Segmented dual-pill component positioned in app headers (`EN | አማ`).
- Active segment filled with solid `#0E7490` and crisp white label; inactive segment in muted slate `#64748B`.

### Navigation Bar
- High-blur white surface (`backdrop-filter: blur(16px)`).
- Active item displays an elevated oceanic circle halo (`#0E7490` background with white icon) protruding 8px above the nav horizon, accompanied by an active indicator dot.
- Inactive items rendered in `#64748B` with 11px micro-labels.

### Accordion & FAQ
- Enclosed rounded-xl pill-cards with light `#F8FAFC` backgrounds, circular icon question indicators (`?`), bold query strings, and smooth chevron rotation transitions.
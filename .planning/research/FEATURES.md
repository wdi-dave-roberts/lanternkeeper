# Feature Landscape

**Domain:** Calm / ambient companion mobile game (ritual-based)
**Researched:** 2026-04-10
**Reference games:** Monument Valley, Alto's Odyssey (Zen Mode), Prune, Headspace, Viridi, Finch

---

## Table Stakes

Features the genre expects. Missing any of these makes the experience feel broken or unfinished.

| Feature | Why Expected | Complexity | Notes |
|---------|--------------|------------|-------|
| Ambient layered audio (music + environment) | Calm games live or die by audio atmosphere. Silence reads as broken, not minimalist. | Medium | 3-bus architecture (Music/SFX/Ambient) already decided. Crossfade on scene transition. |
| Companion idle animation | A static sprite feels like a placeholder. The companion must feel alive even when nothing is happening. | Medium | AnimatedSprite2D flipbook. Aetherling needs at least 1 idle loop per scene at launch. |
| Touch gesture interactions | Mobile-native interaction. Swipe/brush gestures are the ritual layer — without them it's a slideshow. | Medium | Tap, swipe, drag with thresholds. Haptic feedback on gesture completion adds tactile satisfaction. |
| Scene atmosphere (background, particles, light) | The world must feel inhabited. Flat backgrounds read as unfinished on mobile screens. | Medium-High | CPUParticles2D for fog/leaves. Shader-based fog layer. Each region needs a distinct ambient feel. |
| Dialogue from the companion | The companion speaking is the emotional core. Without dialogue, Aetherling is a screensaver. | Medium | DialogueManager + JSON files. Even 20 well-written lines per scene exceeds minimum. |
| Save state persistence | Player must return to where they left off. Losing progress is a calm-breaker. | Low | FileAccess.store_var() already chosen. Unlock state, return count, emotional history. |
| Legible, calm UI typography | Font choice signals genre immediately. Wrong font (system defaults, hard angles) breaks immersion. | Low | Single calm typeface. Minimal UI chrome — dialogue box, emotion picker, quest display. |
| Volume controls per audio type | Expected by modern players. Music blaring when they open it in a quiet room is jarring. | Low | Three independent sliders (Music, SFX, Ambient). ConfigFile persistence. |
| Safe area / notch handling | iOS notches and Dynamic Islands can clip content. Looks unfinished on modern hardware. | Low | Design in from day 1 per project CLAUDE.md. Use Godot's SafeAreaMargins. |
| Graceful first-launch (onboarding) | Ambient games dump players into the world — but they need one breath of orientation. | Low | Not a tutorial — just a first-launch moment where Aetherling notices the player. A few lines, then silence. |

---

## Differentiators

Features that set Lanternkeeper apart from generic calm apps and companion games. Not expected, but deeply valued when present.

| Feature | Value Proposition | Complexity | Notes |
|---------|-------------------|------------|-------|
| Emotional check-in that changes the game | Most calm games ignore how you feel. Lanternkeeper asks and responds — Aetherling's words shift based on your state. | Medium | 4 emotional states stored in GameState. Dialogue trees branch on emotion. Quest set pulled by emotion. |
| Micro-quests tied to real-world creative work | Generic calm apps offer breathing. Lanternkeeper offers a tiny next step toward Garrett's actual game. | Medium | Fire-and-forget by design — no completion pressure. 3-5 quests per emotional state minimum. Quest text is the creative prompt, not a task manager. |
| Hand-written dialogue voice | Most companion games use template dialogue. Allie writing every line gives Aetherling a real voice. | Low (time cost) | The differentiator is execution quality, not technical complexity. Protect this — no procedural dialogue. |
| Reset mechanic framed as ritual | "Begin again" is philosophically different from failure recovery. It reframes the whole experience. | Low-Medium | The lantern relighting animation is the ritual itself. Visual state resets, emotional history stays (so Aetherling can acknowledge it). |
| Five distinct ambient regions | A single scene is a screensaver. Five regions with unlock progression gives players something to look forward to returning for. | High | Each region needs unique art, audio, particle profile, and dialogue set. Phase 8 in the roadmap. |
| Region progression tied to emotional variety | Unlocking via return count alone is arbitrary. Unlocking because you showed up with curiosity, sadness, joy, and determination feels earned. | Medium | One unlock trigger design decision still outstanding (Phase 1). Emotional variety as a trigger aligns with the game's values. |
| Companion awareness of real-world context | Aetherling referencing Garrett's project (Atlas) by name makes this a gift, not a product. | Low | Achieved through dialogue content, not code. Allie writes the specificity in. |
| Tactile gesture rituals (fog clearing, leaf brushing) | The physicality of the gesture is what makes it a ritual, not just a tap target. Swipe direction, arc, duration matter. | Medium | Swipe gesture detection with visual feedback (fog disperses, leaves scatter). Haptic on completion. |

---

## Anti-Features

Things to deliberately NOT build. These patterns are common in the genre but undermine the core experience.

| Anti-Feature | Why Avoid | What to Do Instead |
|--------------|-----------|-------------------|
| Daily streaks | Streaks create guilt. Missing a day makes the player feel they failed the companion. This is the opposite of the game's value proposition. | Session count shown as a warm fact ("You've visited 14 times") — not a streak, not a counter to break. |
| Push notifications | "Aetherling misses you!" is a dark pattern. It converts a sanctuary into an obligation. | None. No notifications, full stop. The game waits. |
| Scores or performance metrics | Measuring how well you brushed leaves destroys the ritual. There is no better or worse way to perform the gesture. | Completion acknowledged with audio/visual feedback — no scoring, no timing. |
| Stamina / energy systems | Energy limits punish the player for returning too often. This game should welcome any visit at any time. | No cooldowns, no timers, no "come back tomorrow for more." |
| Loot boxes or random rewards | Randomized reward loops trigger compulsion, not calm. Even "gentle" gacha patterns are manipulative. | Progression through return and emotional variety — transparent, not gambled. |
| Social comparison (leaderboards, sharing prompts) | This experience is private. Comparing how you feel to others is antithetical to the emotional check-in design. | No social features whatsoever. |
| Tutorial forced on first launch | Long tutorials break the ambient arrival. The game should feel like stepping into a world, not loading a manual. | One orienting moment — Aetherling acknowledges you arrived — then the world is yours. |
| Unskippable animations / locked transitions | Calm games can still frustrate. Animations that the player can't skip after seeing them twice become obstacles. | All non-first-run animations should be interruptible or complete within 2 seconds. |
| Achievement / badge systems | Badges make the experience about accumulation, not presence. "You unlocked: Fog Clearer" cheapens the ritual. | Regions unlock through emotional progression, not achievement collections. |
| Monetization hooks | This is a gift. Any IAP, subscription prompt, or upgrade nag destroys the gift reading entirely. | None. This is a closed experience. |

---

## Feature Dependencies

```
Touch gesture system → Fog clearing ritual (fog disperses on swipe)
Touch gesture system → Leaf brushing ritual (leaves scatter on swipe)

Emotional check-in UI → Dialogue variation (lines branch on state)
Emotional check-in UI → Micro-quest selection (quests pulled by state)
Emotional check-in UI → GameState persistence (state stored across sessions)

DialogueManager → Aetherling speaks (lines loaded from JSON)
DialogueManager → First-launch moment (onboarding via dialogue, not tutorial)
DialogueManager → Emotional dialogue variation (branches selected by GameState)

GameState (return count + emotional history) → Region unlock logic
Region unlock logic → Scene transitions to new regions
Scene transitions → SceneTransition autoload (fade-to-black already architected)

Companion idle animation → Aetherling lives (requires sprite assets)
Companion idle animation + DialogueManager → Aetherling speaks with synchronized expression

Reset mechanic → GameState (clears visual state, preserves emotional history)
Reset mechanic → Lantern relighting animation (the ritual is the animation)

Audio architecture (3 buses) → Ambient audio per region
Audio architecture → Crossfade on scene transition
Audio architecture → Volume controls in settings
```

---

## MVP Recommendation

The minimal playable gift has:

1. **Lantern Clearing scene** — one ambient scene with atmosphere (fog particles, background, music)
2. **Aetherling idle** — red panda with at least one idle animation loop
3. **Touch ritual** — fog clearing gesture with visual + haptic feedback
4. **Emotional check-in** — 4 states, stored, influences what Aetherling says
5. **Aetherling speaks** — 15-20 hand-written lines, branching on emotional state
6. **Micro-quests** — one set of 4-5 prompts per emotional state (16-20 total)
7. **Ambient audio** — music + one ambient layer, volume controls
8. **Reset / "begin again"** — lantern relighting animation

Defer for post-MVP:
- **Regions 2-5**: High effort, not blocking the gift. Ship with one complete world.
- **Leaf brushing ritual**: Second gesture adds variety but depends on art assets.
- **Return-count dialogue variation**: Adds depth after Allie has seen what resonates.
- **Android export**: Same codebase, no cost to deferring until after iOS ships.

**Why this order:** The emotional check-in and Aetherling's voice are the gift. The fog ritual and ambient audio make it feel like a world. The rest is expansion.

---

## Complexity Reference

| Level | Meaning in Godot 4 / GDScript context |
|-------|--------------------------------------|
| Low | Signals, scene nodes, ConfigFile. Allie can contribute JSON. |
| Medium | Custom GDScript systems, AnimatedSprite2D, InputEventScreenDrag, tween chains. |
| Medium-High | Shaders, particle tuning, cross-scene state. Requires iteration. |
| High | Multiple full scenes with unique art, audio, and dialogue sets. Volume of work, not technical risk. |

---

## Sources

- Monument Valley design analysis: https://nabauer.com/monument-valley-design-analysis/ (MEDIUM confidence — third-party analysis, aligns with official design interviews)
- Designing for Coziness, Game Developer: https://www.gamedeveloper.com/design/designing-for-coziness (HIGH confidence — industry publication)
- Alto's Odyssey Zen Mode design: https://www.theshortgame.net/146-altos-odyssey-etc/ (MEDIUM confidence)
- Dark patterns in mobile games (arxiv 2024): https://arxiv.org/abs/2412.05039 (HIGH confidence — peer-reviewed research)
- Headspace UX case study: https://www.neointeraction.com/blogs/headspace-a-case-study-on-successful-emotion-driven-ui-ux-design (MEDIUM confidence)
- Cozy game design philosophy: https://www.gamedeveloper.com/design/designing-for-coziness (HIGH confidence)
- Dark Pattern Games database: https://www.darkpattern.games/ (HIGH confidence — community-sourced documentation)
- Finch companion app design: emotional check-in pattern (MEDIUM confidence — app store observation)

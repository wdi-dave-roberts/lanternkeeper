# Technical Decisions

Every technical choice and why it was made. Updated as decisions are finalized.

## Engine & Language

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Engine | Godot 4.6+ | Best 2D mobile engine. 4.6 has transformative mobile renderer improvements (16-70 FPS on budget hardware). Free, open source, indie standard. |
| Language | GDScript | C# mobile export is officially experimental with launch crashes. GDScript is Python-like and beginner-friendly for Allie. |
| Renderer | Compatibility (OpenGL) | Forward+ (Vulkan) crashes on AMD hardware, shader stutter issues, zero benefit for 2D mobile. |

## Display & Mobile

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Resolution | 1080x1920 portrait | Standard mobile portrait. canvas_items stretch mode, keep_height aspect. |
| Target | iOS first | Android deferred to post-MVP. Same codebase, different export pipeline. No architectural cost. |
| Mobile-first | Designed in from day 1 | Safe areas, resolution scaling, touch input cannot be retrofitted. Community consensus: retrofitting mobile is as hard as "just add multiplayer." |

## Architecture

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Particles | CPUParticles2D | Lower fixed cost than GPU particles at low counts (<100/emitter). Mobile-friendly. |
| State persistence | FileAccess.store_var() | Native Godot type support, safe against code injection. ConfigFile for user settings. |
| Dialogue data | JSON files in data/ | Non-technical developer (Allie) can edit directly. No GDScript needed for content. |
| Character animation | AnimatedSprite2D | Simpler mental model than AnimationPlayer for flipbook-style idles. |
| Audio | 3 buses (Music, SFX, Ambient) | Crossfade manager autoload for scene transitions. Logarithmic fade curves. |
| Version control | Git + LFS for binaries | .tres/.tscn are text (regular git). PNG/OGG/WAV/TTF tracked via LFS. |

## 4 Autoloads

Global singletons that cover every cross-cutting concern:

| Autoload | Purpose |
|----------|---------|
| `GameState` | Save/load player state (unlocks, progress, return count) |
| `SceneTransition` | Fade between scenes via tween |
| `AudioManager` | Music crossfade, SFX pool, bus management |
| `DialogueManager` | JSON dialogue loading and playback |

## GDScript Conventions

- Type hints on all variables and function signatures
- "Call down, signal up" — parents call children directly, children emit signals
- `snake_case` for files, functions, variables; `PascalCase` for classes; `UPPER_SNAKE` for constants
- Signals use past tense: `lantern_lit`, `dialogue_finished`
- Private members prefixed with `_`
- Scene scripts live next to their `.tscn` file, same name

## Community-Sourced Warnings

From Reddit research (r/godot, r/gamedev, April 2026):

1. **Do NOT use Forward+ renderer for mobile** — crashes on AMD, shader stutter, zero 2D benefit
2. **Do NOT use C# for mobile** — experimental, launch crashes on Android, reflection crashes on iOS
3. **Do NOT retrofit mobile support** — safe areas, resolution, touch must be designed in from day 1
4. **Test on real iOS hardware early** — things that work on Android crash silently on iOS
5. **Godot 4.6 is mandatory for mobile** — renderer improvements are transformative, not incremental

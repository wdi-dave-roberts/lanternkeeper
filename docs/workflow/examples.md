# Workflow Examples

Complete walkthroughs for the most common types of work. Each example shows the full flow from start to finish.

---

## Example 1: Quick Content Edit

**Scenario:** You notice a typo in existing dialogue — "The clearing is quite tonight" should be "quiet."

**Steps:**

1. Start your session:

    > "Pull the latest changes"

2. Fix it directly:

    > "/gsd-fast fix typo in lantern_clearing.json — 'quite' should be 'quiet'"

    CC fixes the typo, commits, and you're done.

3. Push:

    > "Push my changes"

**Total time:** Under a minute.

---

## Example 2: New Dialogue File

**Scenario:** You're writing all the dialogue for a new region — the Fog Forest.

**Steps:**

1. Start your session:

    > "Pull the latest changes"

2. Start a GSD task:

    > "/gsd-quick create dialogue for the fog forest region — need lines for all four emotions (calm, anxious, tired, energized), at least 2 lines each"

3. CC creates `data/dialogue/fog_forest.json` following the same format as `lantern_clearing.json`. Review what it wrote:

    > "Show me the file"

4. Edit as needed. You might say:

    > "The anxious lines feel too clinical. Make them warmer — more like a friend reassuring you, not a therapist."

5. When you're happy, CC commits. Push:

    > "Push my changes"

**Reference format:** Look at `data/dialogue/lantern_clearing.json` for the JSON structure. Each line has an `emotion`, `text`, and `weight` field.

```json
[
  {"emotion": "calm", "text": "The fog parts gently as you walk.", "weight": 1},
  {"emotion": "anxious", "text": "Even fog lifts eventually. Stay with me.", "weight": 1}
]
```

---

## Example 3: Art and Music Assets

**Scenario:** You have a sprite sheet for Aetherling's idle animation and want to add it to the project.

**Steps:**

1. Start your session:

    > "Pull the latest changes"

2. Put the file in the right place. Follow the [asset conventions](asset-conventions.md):

    - Sprites go in `assets/sprites/`
    - Audio goes in `assets/audio/`
    - Fonts go in `assets/fonts/`

    Copy or move your file to the correct directory.

3. Tell CC to commit it:

    > "/gsd-quick add aetherling idle sprite sheet to assets/sprites/"

4. CC stages the file (Git LFS handles it automatically since it's a PNG), commits, and tracks the task.

5. Push:

    > "Push my changes"

**Important notes:**

- File names should be lowercase with hyphens: `aetherling-idle.png`, not `Aetherling Idle.png`
- Git LFS handles large binary files automatically — you don't need to do anything special
- If you need to replace an existing asset, just overwrite the file and commit. Git tracks the history.

---

## Example 4: Documentation

**Scenario:** You want to add a page explaining the fog forest region's atmosphere and design intent.

**Steps:**

1. Start your session:

    > "Pull the latest changes"

2. Start the task:

    > "/gsd-quick write a design doc for the fog forest region — explain the atmosphere, what the player feels, how the rituals work here"

3. CC creates a markdown file (likely in `docs/design/` or wherever you direct it). Review:

    > "Show me what you wrote"

4. Edit until it matches your vision. This is creative work — take your time with it.

5. If the new page needs to appear in the docs site navigation, tell CC:

    > "Add this page to the mkdocs.yml nav under the Design section"

6. Commit and push:

    > "Pull latest, then commit and push"

---

## Example 5: Scene Work in Godot

**Scenario:** You're creating the visual layout for the Fog Forest scene in the Godot editor.

This is different from content work because scene files (`.tscn`) are created in the Godot editor, not in a text editor.

**Steps:**

1. Start your session in Claude Code:

    > "Pull the latest changes"

2. Open Godot and work on the scene. Save frequently in the editor (Ctrl+S / Cmd+S).

3. When you're at a good stopping point, switch back to Claude Code:

    > "What files have I changed?"

    CC shows you the modified `.tscn` and any related files.

4. Commit:

    > "Commit my changes with message 'create fog forest scene layout with background and fog layers'"

5. Push:

    > "Pull latest, then push"

**Tips for scene work:**

- Save in Godot before switching to CC — unsaved changes in the editor won't show up in Git
- Scene files (`.tscn`) are text-based, so Git can track changes normally
- If you create new image or audio assets for the scene, they go through LFS automatically
- If Godot creates a `.import` file, that's normal — it lives in `.godot/` which is gitignored

---

## Example 6: Bigger Creative Feature

**Scenario:** You're designing the entire Moss Garden region — dialogue, quest hooks, atmosphere, and how it connects to the player's emotional state.

This is too big for `/gsd-quick`. Use the full GSD cycle.

**Steps:**

1. Start your session:

    > "Pull the latest changes"

2. Discuss the feature:

    > "/gsd-discuss-phase [phase number]"

    or if you're starting from scratch:

    > "Let's brainstorm the Moss Garden region — I want to talk through the atmosphere, what emotions it serves, and how the rituals work before we plan anything"

3. GSD (or CC) asks questions to understand your vision. Answer them — this is where your creative direction shapes the work. Take your time here. Key decisions get documented.

4. When the vision is clear, plan it:

    > "/gsd-plan-phase [phase number]"

    GSD breaks your vision into concrete tasks: create dialogue JSON, write atmospheric descriptions, define quest hooks, specify how the region unlocks.

5. Execute the plan:

    > "/gsd-execute-phase [phase number]"

    GSD works through each task, creating files and committing as it goes. It will ask for your input on creative decisions.

6. Verify:

    > "/gsd-verify-work [phase number]"

    Read through everything. Does the dialogue feel right? Does the atmosphere match your vision? Flag anything that needs adjustment.

7. Push when satisfied:

    > "Push my changes"

**When to use this vs. /gsd-quick:** If the work touches multiple files, involves design decisions, or you'd benefit from thinking it through before starting — use the full cycle. If it's "add 4 dialogue lines to an existing file" — use `/gsd-quick`.

---

## The Pattern

Every example follows the same rhythm:

```
Pull → Work → Commit → Push
```

The only thing that changes is the middle part — how much structure the work needs. A typo fix needs `/gsd-fast`. A new region needs the full discuss/plan/execute cycle. The bookends (pull and push) are always the same.

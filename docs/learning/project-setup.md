# Project Setup

How to create and configure the Lanternkeeper Godot project from scratch. Follow these steps exactly — the order matters.

## Prerequisites

- Git installed and configured
- The `lanternkeeper` repo cloned to your machine
- A code editor for JSON files (VS Code, or Godot's built-in editor)

## Step 1: Install Godot 4.6.2

Download the **standard** build from [godotengine.org/download](https://godotengine.org/download). Do NOT download the .NET/C# version — we use GDScript.

=== "Mac"

    **Option A: Homebrew (recommended)**

    ```bash
    brew install --cask godot
    ```

    This installs Godot.app to `/Applications` and adds a `godot` command to your terminal. Updates with `brew upgrade godot`.

    **Option B: Manual download**

    1. Download the macOS universal build
    2. Unzip and drag **Godot.app** to `/Applications`
    3. First launch: right-click > Open (macOS will ask to verify since it's not from the App Store)

=== "PC"

    1. Download the Windows 64-bit build
    2. Unzip to a folder you'll remember (e.g., `C:\Godot\`)
    3. There is no installer — `Godot_v4.6.2-stable_win64.exe` is the entire application
    4. Optional: pin it to your taskbar or create a desktop shortcut

!!! note "No installer needed"
    Godot is a single file. No install wizard, no dependencies, no admin rights required. Just download, unzip, and run.

## Step 2: Create the Project

1. Open Godot
2. Click **New Project**
3. Fill in:
    - **Project Name:** `Lanternkeeper`
    - **Project Path:** point to your cloned repo folder

    === "Mac"

        `/Users/yourname/github/wdi-dave-roberts/lanternkeeper`

    === "PC"

        `C:\Users\yourname\github\wdi-dave-roberts\lanternkeeper`

    - **Renderer:** select **Compatibility** (OpenGL)

4. Click **Create & Edit**

Godot will generate a `project.godot` file in the repo root. This is the project configuration — it's tracked in Git.

??? info "Why Compatibility renderer?"
    Godot 4.6 has three renderers:

    - **Compatibility (OpenGL)** — The oldest and most stable. Uses OpenGL, which runs on everything: old phones, AMD GPUs, integrated graphics. No shader compilation stutter. For 2D games, the visual output is identical to the other renderers.
    - **Forward+ (Vulkan)** — Godot's flagship. Built for 3D with advanced lighting and effects. Uses Vulkan, which crashes on some AMD desktop GPUs and causes shader stutter on first run. Provides zero visual benefit for 2D sprite-based games.
    - **Mobile (Vulkan)** — A middle ground: Vulkan backend with simplified 3D features for mobile. Still has the Vulkan crash risk and stutter, still no 2D benefit over Compatibility.

    **Our choice:** Compatibility. We're building a 2D game — the other two add crash risk and complexity with no visual payoff. If you ever see a tutorial using Forward+, that's fine for their 3D project, but wrong for ours.

## Step 3: Configure Project Settings

Open **Project > Project Settings** and set each value:

!!! tip "Finding settings"
    Project Settings has a search bar at the top. Type part of the setting name (e.g., "touch") to jump straight to it instead of navigating the tree.

### Display — Window Size

| Setting Path | Value |
|---|---|
| Display > Window > Size > Viewport Width | `1080` |
| Display > Window > Size > Viewport Height | `1920` |

This is your **base resolution** — the reference size you design for. It doesn't mean the game only runs at this exact size. Godot uses these numbers as the starting point for scaling to whatever screen the game actually runs on.

We chose 1080x1920 because it's the most common phone resolution in portrait orientation. When the game runs on a phone with a different resolution (say 1440x3200), Godot scales everything to fit using the stretch settings below.

### Display — Stretch Mode

| Setting Path | Value |
|---|---|
| Display > Window > Stretch > Mode | `canvas_items` |

Stretch mode controls what happens when the game window doesn't match your base resolution. Godot has three options:

- **`disabled`** — No stretching. The game renders at exactly 1080x1920 and that's it. On a phone with a different resolution, you get black bars or clipping. Useless for mobile.
- **`canvas_items`** — Scales the entire 2D canvas (sprites, UI, text) to fit the screen. Everything scales together proportionally. Text stays crisp because the scaling happens at the rendering level, not by stretching a bitmap. **This is the standard choice for 2D mobile games.**
- **`viewport`** — Renders the game to a fixed-size texture at your base resolution, then stretches that image to fill the screen. Think of it like taking a screenshot at 1080x1920 and then zooming in. Great for pixel art games where you want chunky pixels. Bad for us because text and smooth sprites would look blurry at non-integer scale factors.

**Our choice:** `canvas_items`. Lanternkeeper has smooth art and readable text — canvas_items keeps both crisp at any screen size.

### Display — Stretch Aspect

| Setting Path | Value |
|---|---|
| Display > Window > Stretch > Aspect | `keep_width` |

Phones aren't all the same shape. Some are 16:9, others are 19:9 or even 21:9 (taller and narrower). Stretch aspect controls how Godot handles the mismatch between your base aspect ratio and the phone's actual aspect ratio.

- **`keep_width`** — Keeps your designed width (1080) and adds or removes vertical space. On a taller phone, the player sees more of the scene at the top and bottom. On a shorter phone, the view crops slightly at the top and bottom. **This is correct for portrait games.**
- **`keep_height`** — Keeps your designed height (1920) and adds or removes horizontal space. On a wider screen, the player sees more on the sides. **This is correct for landscape games.**
- **`ignore`** — Stretches to fill the screen, distorting the aspect ratio. Everything looks squished or stretched. Never use this.
- **`expand`** — Similar to keep_width/keep_height but lets the viewport grow in both directions. More complex to design for.

!!! warning "keep_width, not keep_height"
    This is a portrait game. `keep_width` adds vertical space on taller phones (19:9, 21:9). `keep_height` is for landscape games — using it here would crop the sides on narrow screens. This is a common mistake because many tutorials are written for landscape games.

### Display — Orientation

| Setting Path | Value |
|---|---|
| Display > Window > Handheld > Orientation | `portrait` |

Locks the game to portrait (tall) orientation. The screen won't rotate if the player tilts their phone sideways. Lanternkeeper is a calm, one-handed companion app — portrait is the natural hold for checking in on your phone.

### Input

| Setting Path | Value |
|---|---|
| Input Devices > Pointing > Emulate Touch From Mouse | `true` |

Lanternkeeper's interactions are all touch-based: taps, swipes, and drags. On a real phone, these come from the touchscreen. On your development computer, you don't have a touchscreen — you have a mouse.

This setting tells Godot to convert mouse clicks and drags into touch events. Without it, your touch input code (`InputEventScreenTouch`, `InputEventScreenDrag`) won't fire when you click with the mouse, and you'd have no way to test interactions without a phone.

**Leave this on during development. It has no effect on real phones.**

## Step 4: Create the SceneTransition Scene

When the game switches between scenes (say, from the Lantern Clearing to the Fog Forest), we don't want a jarring instant cut. SceneTransition handles a smooth fade-to-black effect. Because that fade is a visual element — a black rectangle that covers the screen — it needs to live in a [`.tscn` scene file](../reference/godot.md#tscn-scene-files), not just a [`.gd` script](../reference/godot.md#gd-gdscript-files).

See [Scene Transitions](../reference/godot.md#scene-transitions) in the reference for the full explanation of how this works and why it's an autoload.

<!-- screenshot: Godot editor showing completed SceneTransition scene tree (CanvasLayer > ColorRect) -->

1. **Scene > New Scene** (1)
2. Choose **Other Node** and select **CanvasLayer** (2)
3. In the Inspector, set the **Layer** property to `128` (3)
4. **Add a child node:** right-click the CanvasLayer in the Scene Tree > **Add Child Node** > select **ColorRect** (4)
5. Select the ColorRect, then in the toolbar above the viewport click **Layout > Full Rect** (5)
6. In the Inspector, set the ColorRect's **Color** to black (`#000000`) (6)
7. Select the root CanvasLayer node, then in the Inspector click the script icon (or drag `autoloads/scene_transition.gd` onto it) to attach the script (7)
8. **Save:** Ctrl+S (or Cmd+S on Mac) > save as `autoloads/scene_transition.tscn`
{ .annotate }

1.  Every time you create something new in Godot, you start with a new scene. A scene is just a tree of nodes saved to a file. Right now the scene is empty — we're about to build a tiny tree: one CanvasLayer with one ColorRect inside it.

2.  A **CanvasLayer** is a special node that draws on its own rendering layer, separate from the main scene. Normal scene content (backgrounds, characters, UI) draws on the default layer. By putting our fade overlay on a CanvasLayer, it stays independent — it won't be affected by camera movement or scene changes.

    You're choosing "Other Node" instead of the presets (2D Scene, 3D Scene, User Interface) because CanvasLayer doesn't fit any of those categories. It's a rendering utility, not a scene type.

3.  **What are layers?** Godot draws things in order — lower layer numbers are drawn first (behind), higher numbers are drawn on top. Normal scene content defaults to layer 0. We set this to 128 to guarantee the fade overlay draws on top of absolutely everything else in the game.

    Why 128 specifically? There's nothing magic about it — any high number works. 128 is a convention that leaves plenty of room for other layers below it (UI at layer 1-10, popups at layer 50, etc.) without risking a collision. Think of it like reserving the top floor of a building for the penthouse.

4.  **ColorRect** is the simplest visual node in Godot — it's just a rectangle filled with a solid color. We're using it as the fade overlay: a full-screen black rectangle that can be made transparent (invisible) or opaque (screen goes black). The SceneTransition script animates this transparency to create the fade effect.

    You're adding it as a *child* of the CanvasLayer. In Godot's scene tree, children inherit their parent's properties — so this ColorRect will draw on layer 128 because its parent CanvasLayer is on layer 128.

5.  **Full Rect** is a layout preset that stretches the node to fill its entire parent area. Without this, the ColorRect would be a tiny rectangle in the corner. With Full Rect, it covers the entire screen — which is what we need for a fade overlay.

    You'll use Full Rect frequently in Godot. Any time you want something to fill the available space (backgrounds, overlays, containers), this is the preset.

6.  The fade starts invisible (the script sets opacity to 0 on startup) and animates to fully opaque black, then back to transparent. We set the color to black here so the fade effect is a fade-to-black, which is the most natural transition for a calm game. The script handles the animation — all we're doing here is choosing the color of the overlay.

7.  **Attaching a script** tells Godot "this node should run this code." The `scene_transition.gd` script contains the `transition_to()` function that other scenes call when they want to change to a different scene. By attaching it to the CanvasLayer (the root of this scene), the script controls both itself and its child (the ColorRect overlay).

    This is a core Godot pattern: nodes are the visual/structural building blocks, scripts are the behavior. A node without a script just sits there. A node with a script does things.

## Step 5: Register Autoloads

[Autoloads](../reference/godot.md#autoloads) are scripts that Godot loads once at startup and keeps alive forever. They're how Lanternkeeper's shared services (saving progress, playing audio, fading between scenes, delivering dialogue) stay available to every scene.

Open **Project > Project Settings > Autoload** tab.

For each autoload, click the folder icon to browse for the file, type the name, and click **Add**. Register them in this exact order (top to bottom):

| Name | Path |
|---|---|
| `GameState` | `res://autoloads/game_state.gd` |
| `AudioManager` | `res://autoloads/audio_manager.gd` |
| `SceneTransition` | `res://autoloads/scene_transition.tscn` |
| `DialogueManager` | `res://autoloads/dialogue_manager.gd` |

!!! note "SceneTransition uses the .tscn"
    Notice SceneTransition points to the `.tscn` file you just created, not the `.gd` file. The scene includes both the script and the ColorRect overlay. The other three autoloads are script-only — they create their nodes in code.

!!! note "Order matters"
    GameState loads first because other autoloads may read saved state. AudioManager loads second because SceneTransition may trigger audio. The order in the Autoload tab is the initialization order.

## Step 6: Create Audio Buses

1. Click the **Audio** tab at the bottom of the editor (next to Output, Debugger, etc.)
2. You'll see a default "Master" bus
3. Click **Add Bus** three times to create three new buses
4. Rename them (click the name at the top of each bus):
    - **Music**
    - **SFX**
    - **Ambient**
5. The layout saves automatically as `default_bus_layout.tres` (a [`.tres` resource file](../reference/godot.md#tres-resource-files))

These buses let AudioManager control volume independently — you can mute sound effects without silencing the music.

## Step 7: Create the Test Scene

This is the first thing the game shows when it runs.

1. **Scene > New Scene**
2. Choose **Other Node** and select **MarginContainer**
3. Attach `shared/ui/safe_area_container.gd` as the script on the root MarginContainer (this handles iPhone notch/Dynamic Island margins — see [Safe Areas](../reference/godot.md#safe-areas) in the reference)
4. Set the MarginContainer layout to **Full Rect**
5. Add a child: **ColorRect**
    - Set layout to **Full Rect**
    - Set color to a calm dark blue: `#1a1a2e`
6. Add a child to the MarginContainer (not the ColorRect): **Label**
    - Set **Text** to `Lanternkeeper`
    - Set layout to **Center**
    - In the Inspector under Theme Overrides > Font Sizes, set the font size to `48`
7. **Save** as `scenes/main/main.tscn` (create the `scenes/main/` folder if prompted)
8. Set as main scene: **Project > Project Settings > Application > Run > Main Scene** > browse to `res://scenes/main/main.tscn`

## Step 8: Test Run

Press **F5** (or the Play button in the top-right).

**What you should see:**

- A tall portrait window with a dark blue background
- "Lanternkeeper" centered on screen
- No red errors in the Output panel at the bottom

**If something goes wrong:**

| Symptom | Likely Cause |
|---|---|
| Window is landscape (wide) | Orientation not set to `portrait` in Project Settings |
| "Lanternkeeper" text is cut off on sides | Stretch aspect set to `keep_height` instead of `keep_width` |
| Red errors mentioning an autoload name | That autoload's path is wrong in Project Settings > Autoload |
| Game doesn't start at all | Main Scene not set in Project Settings > Application > Run |
| "Cannot open file" error | File path has a typo — check `res://` paths in autoload settings |

## Step 9: Verify Autoloads

After the test scene works, Dave will attach a verification script (`scenes/main/main.gd`) that prints confirmation to the Output panel. When you run the game, you should see:

```
=== Lanternkeeper Autoload Verification ===
GameState: return_count = 0 (incremented to 1)
DialogueManager line: [some calm dialogue]
AudioManager: ready, buses configured
SceneTransition: ready
=== All autoloads verified ===
```

If any line is missing or shows an error, that autoload needs attention.

## What Gets Committed

After setup, these new files should be in Git:

```
project.godot                      # Project configuration
autoloads/scene_transition.tscn    # SceneTransition scene
default_bus_layout.tres            # Audio bus layout
scenes/main/main.tscn             # Test scene
scenes/main/main.gd               # Autoload verification script
.godot/                            # Local cache (gitignored)
```

The `.godot/` folder is Godot's local cache — it's already in `.gitignore` and should never be committed.

--8<-- "docs/_includes/glossary.md"

# Dialogue Guide

How to write and edit Aetherling's dialogue. No coding required — just edit JSON files.

## Where Dialogue Lives

All dialogue files are in `data/dialogue/`. There's one file per region:

```
data/dialogue/
  lantern_clearing.json
  workshop_glade.json
  fog_valley.json
  warm_river.json
  observatory_balcony.json
```

## The Format

Each dialogue file contains named dialogue blocks. Here's what one looks like:

```json
{
  "greeting_first": {
    "speaker": "Aetherling",
    "lines": [
      "Oh. Hello.",
      "I didn't expect anyone else out here.",
      "I've been working on something... but the fog rolled in.",
      "Could you help me clear the way?"
    ]
  }
}
```

**`speaker`** — Who's talking. Always `"Aetherling"` for now.

**`lines`** — An array of strings. Each string is one dialogue bubble. The player taps to advance through them.

## Naming Conventions

Dialogue block names should describe when they appear:

- `greeting_first` — First time the player visits
- `greeting_return` — Returning player
- `after_clearing_stuck` — After the clearing ritual, if the player chose "Stuck"
- `after_clearing_inspired` — After clearing, if "Inspired"

Use `snake_case` and be descriptive. The code references these names to trigger dialogue.

## Writing Tips

Aetherling's voice:

- **Short lines.** One thought per bubble. Let silence do the work.
- **Never says "good job."** He's a peer, not a coach.
- **Never says "you should."** He suggests and wonders, never instructs.
- **Assumes effort and goodwill.** The player showed up. That's enough.
- **Present tense.** He's here with you, not narrating.

Good:
```
"The clearing feels quieter when you're here."
"Being stuck isn't the same as being lost."
```

Avoid:
```
"Great job clearing the fog!"
"You should try to work on your project today."
```

## Micro-Quests

Quests live in `data/quests/micro_quests.json`, organized by emotion:

```json
{
  "stuck": [
    "Open your project for just 2 minutes.",
    "Write one sentence about what feels blocked.",
    "Look at something you made last week."
  ],
  "frustrated": [
    "Step away for 5 minutes. The work will wait.",
    "Protect your spark: remove one distraction.",
    "Name the frustration. Just one word."
  ]
}
```

The game picks one quest randomly from the matching emotion. Write at least 3-5 per emotion so it doesn't feel repetitive.

## Testing Your Changes

After editing a JSON file:

1. Save the file
2. Run the game in Godot (F5)
3. Play through to the point where your dialogue triggers
4. If something looks wrong, check for missing commas or quotes — JSON is picky about those

Common JSON mistakes:

- Missing comma after a line (except the last one in an array)
- Forgetting to close a `"` quote
- Trailing comma on the last item in an array (JSON doesn't allow this)

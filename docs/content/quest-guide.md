# Quest Guide

How to write micro-quests — the gentle suggestions that appear after the emotional check-in.

## The Philosophy

Quests are **ramps, not assignments.** They should feel like a friend saying "hey, what if you tried this tiny thing?" Not a task manager adding items to a list.

- Only one quest appears at a time
- No lists, no streaks, no penalties
- The player can ignore it completely — no consequence
- Each quest should take less than 5 minutes (most under 2)

## Where Quests Live

All quests are in a single file: `data/quests/micro_quests.json`

## The Format

Quests are grouped by the four emotional states:

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
  ],
  "inspired": [
    "Capture the idea — even one sentence counts.",
    "Start the smallest version of what you're imagining.",
    "Tell someone what you're excited about."
  ],
  "alright": [
    "Keep going. Steady is its own kind of brave.",
    "Do the next small thing.",
    "You don't need permission to begin."
  ]
}
```

## Writing Tips

- **Tiny scope.** "Open your project for 2 minutes" not "Work on your project."
- **Present tense, direct address.** "Write one sentence" not "You could try writing."
- **No guilt.** Never imply the player should have done more.
- **Physical when possible.** "Step away" and "remove one distraction" involve real-world action.
- **Emotionally matched.** Stuck quests lower the bar. Frustrated quests create space. Inspired quests capture momentum. Alright quests affirm the current pace.

## How Many to Write

Minimum 3-5 per emotion (12-20 total). More is better — it prevents the same quest appearing repeatedly. Aim for 8-10 per emotion if you can.

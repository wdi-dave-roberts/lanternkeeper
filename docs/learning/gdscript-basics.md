# GDScript Basics

A quick reference for reading and writing GDScript. If you know any Python, this will feel familiar.

## Variables

```gdscript
var health: int = 100
var name: String = "Aetherling"
var is_visible: bool = true
var speed: float = 2.5
```

The `: int` part is a type hint — it tells Godot (and you) what kind of value the variable holds.

## Functions

```gdscript
func greet(player_name: String) -> void:
    print("Hello, " + player_name)

func add(a: int, b: int) -> int:
    return a + b
```

`-> void` means the function doesn't return anything. `-> int` means it returns a number.

## If / Else

```gdscript
if emotion == "stuck":
    show_quest("Open your project for 2 minutes.")
elif emotion == "frustrated":
    show_quest("Step away for 5 minutes.")
else:
    show_quest("Do the next small thing.")
```

## Signals (Events)

Signals are how nodes talk to each other. Think of them like notifications.

```gdscript
# Define a signal
signal lantern_lit

# Emit it (send the notification)
func light_lantern() -> void:
    lantern_lit.emit()

# Connect to it (listen for the notification)
func _ready() -> void:
    lantern.lantern_lit.connect(_on_lantern_lit)

func _on_lantern_lit() -> void:
    print("The lantern is lit!")
```

## Common Node Functions

```gdscript
# Runs once when the node enters the scene
func _ready() -> void:
    pass

# Runs every frame (60 times per second)
func _process(delta: float) -> void:
    pass
```

`delta` is the time since the last frame — use it to make movement smooth regardless of frame rate.

## Accessing Other Nodes

```gdscript
# Get a child node by name
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

# Use it
func _ready() -> void:
    sprite.play("idle")
```

`$AnimatedSprite2D` is shorthand for "get the child node named AnimatedSprite2D." The `@onready` means "don't try to find this until the scene is loaded."

## Arrays and Dictionaries

```gdscript
# Array (a list)
var emotions: Array = ["stuck", "frustrated", "inspired", "alright"]

# Dictionary (key-value pairs, like JSON)
var save_data: Dictionary = {
    "unlocked_scenes": ["lantern_clearing"],
    "return_count": 5,
}
```

## Naming Conventions

| Thing | Style | Example |
|-------|-------|---------|
| Files | snake_case | `lantern_clearing.gd` |
| Variables | snake_case | `return_count` |
| Functions | snake_case | `light_lantern()` |
| Constants | UPPER_SNAKE | `MAX_LANTERNS` |
| Classes | PascalCase | `DialogueManager` |
| Signals | snake_case, past tense | `lantern_lit` |
| Private | prefix with `_` | `_internal_state` |

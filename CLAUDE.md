# Amaris — 2D Isometric Dungeon Crawler

## Project Identity
- **Name:** Amaris
- **Engine:** Godot 4.6 (GL Compatibility)
- **Resolution:** 1280x720
- **Genre:** 2D Isometric Dungeon Crawler
- **Input:** Xbox controller-first, keyboard fallback

---

## Architecture

### Autoloads (load order)
1. Events — Signal bus
2. GameManager — State, scene transitions, logging
3. InputSetup — Programmatic InputMap (clears project.godot drift)
4. SaveManager — Versioned save/load
5. DataRegistry — JSON data loader
6. DungeonManager — Seeds, floor memory, dungeon state
7. AudioManager — SFX routing stub

### Scene Flow
```
MainMenu → CharacterSelect → TownHall
TownHall → DungeonEntrance → DungeonFloor
DungeonFloor ↔ DungeonFloor (stairs)
DungeonFloor → TownHall (retreat)
Any → PauseMenu (overlay)
```

### 2D Isometric Approach
- Node2D / CharacterBody2D with isometric sprite positioning
- Y-sort via `CanvasItem.y_sort_enabled`
- TileMapLayer for dungeon floors (Godot 4.6 API)
- Camera2D with smoothing

---

## Data Contract
- `game.config.json` — Amatris launcher metadata
- `project_status.json` — Dashboard metrics (v1 schema)
- `data/` — JSON definitions for items, enemies, classes, shops
- All data is JSON — no markdown parsing for metrics

---

## Macro Phases

### Phase 1 — Foundation (Checkpoints 1-8)  ← CURRENT
1. Repo standardized
2. Boots without errors
3. Input map created (programmatic)
4. Controller navigation baseline
5. Base scene flow wired
6. Logging/error handling pattern
7. Config/data loading pattern
8. Version/build identifier visible

### Phase 2 — Player & Movement (Checkpoints 9-16)
- Player CharacterBody2D with 8-dir isometric movement
- Animation state machine
- Camera follow
- Collision layers
- Basic stats system

### Phase 3 — Dungeon Generation (Checkpoints 17-24)
- Procedural room generation
- TileMapLayer rendering
- Room connections
- Stairs/exits
- Fog of war

### Phase 4 — Combat (Checkpoints 25-32)
- Basic attack system
- Enemy AI
- Damage calculation
- Death/loot drops
- Health/mana bars

### Phase 5 — Loot & Inventory (Checkpoints 33-40)
- Inventory system
- Equipment slots
- Item pickups
- Item stats/comparison
- Inventory UI

### Phase 6 — Town & Shops (Checkpoints 41-48)
- Shop UI
- Buy/sell mechanics
- NPC interaction
- Town navigation

---

## Non-Negotiable Rules
- InputMap is programmatic only — never rely on project.godot input config
- GameManager is the single entry point for all scene changes
- Events bus for all cross-system communication
- JSON is the only data format for game data
- project_status.json is the Amatris dashboard contract
- All GDScript follows Godot 4.x static typing conventions

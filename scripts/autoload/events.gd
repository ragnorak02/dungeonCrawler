extends Node
## Signal bus — all cross-system communication routes through here.
## Autoload: Events

# --- Player signals ---
signal player_spawned(player_node: Node)
signal player_died
signal player_health_changed(current: int, maximum: int)
signal player_mana_changed(current: int, maximum: int)
signal player_leveled_up(new_level: int)
signal player_xp_gained(amount: int)

# --- Enemy signals ---
signal enemy_spawned(enemy_node: Node)
signal enemy_died(enemy_node: Node, drop_table: String)
signal enemy_damaged(enemy_node: Node, amount: int)

# --- Dungeon signals ---
signal dungeon_entered(seed_value: int)
signal dungeon_floor_changed(floor_number: int)
signal dungeon_exited
signal dungeon_room_entered(room_id: String)
signal dungeon_room_cleared(room_id: String)

# --- Loot signals ---
signal loot_dropped(item_data: Dictionary, position: Vector2)
signal loot_picked_up(item_data: Dictionary)
signal inventory_changed

# --- Town signals ---
signal town_entered
signal town_exited
signal shop_opened(shop_id: String)
signal shop_closed

# --- UI signals ---
signal ui_navigate(direction: String)
signal ui_confirm
signal ui_back
signal pause_requested
signal pause_resumed
signal scene_transition_started(target_scene: String)
signal scene_transition_finished

extends Node
## Dungeon state, seed management, and floor memory.
## Autoload: DungeonManager

var current_seed: int = 0
var current_floor: int = 0
var max_floors: int = 5
var is_in_dungeon: bool = false

## Floor memory — tracks cleared rooms, revealed tiles, etc.
var floor_memory: Dictionary = {}


func _ready() -> void:
	Events.dungeon_entered.connect(_on_dungeon_entered)
	Events.dungeon_exited.connect(_on_dungeon_exited)
	Events.dungeon_floor_changed.connect(_on_floor_changed)
	GameManager.log_info("DungeonManager ready")


func start_new_dungeon() -> void:
	current_seed = randi()
	current_floor = 1
	is_in_dungeon = true
	floor_memory.clear()
	GameManager.session["dungeon_seed"] = current_seed
	GameManager.session["current_floor"] = current_floor
	GameManager.log_info("DungeonManager: New dungeon — seed %d" % current_seed)
	Events.dungeon_entered.emit(current_seed)


func continue_dungeon() -> void:
	if GameManager.session["dungeon_seed"] != 0:
		current_seed = GameManager.session["dungeon_seed"]
		current_floor = GameManager.session["current_floor"]
		is_in_dungeon = true
		GameManager.log_info("DungeonManager: Continuing dungeon — seed %d, floor %d" % [current_seed, current_floor])
		Events.dungeon_entered.emit(current_seed)
	else:
		GameManager.log_warn("DungeonManager: No dungeon to continue, starting new")
		start_new_dungeon()


func go_deeper() -> void:
	if current_floor < max_floors:
		_save_floor_state()
		current_floor += 1
		GameManager.session["current_floor"] = current_floor
		Events.dungeon_floor_changed.emit(current_floor)
		GameManager.log_info("DungeonManager: Descended to floor %d" % current_floor)
	else:
		GameManager.log_info("DungeonManager: Already at max floor %d" % max_floors)


func retreat_to_town() -> void:
	_save_floor_state()
	is_in_dungeon = false
	Events.dungeon_exited.emit()
	GameManager.go_to_town()


func _save_floor_state() -> void:
	floor_memory[current_floor] = {
		"cleared": true,
		"timestamp": Time.get_datetime_string_from_system(true),
	}


func _on_dungeon_entered(_seed: int) -> void:
	pass


func _on_dungeon_exited() -> void:
	is_in_dungeon = false


func _on_floor_changed(floor_num: int) -> void:
	current_floor = floor_num

extends Node
## Core game state and scene management.
## Autoload: GameManager

enum GameState {
	NONE,
	MAIN_MENU,
	CHARACTER_SELECT,
	TOWN,
	DUNGEON_ENTRANCE,
	DUNGEON,
	PAUSED,
}

var current_state: GameState = GameState.NONE
var previous_state: GameState = GameState.NONE

## Session data — persists for the current play session
var session: Dictionary = {
	"class_name": "",
	"class_id": "",
	"player_level": 1,
	"current_floor": 0,
	"dungeon_seed": 0,
	"gold": 0,
	"play_time_seconds": 0.0,
}

var _version_data: Dictionary = {}


func _ready() -> void:
	_load_version_data()
	log_info("GameManager ready — Amaris %s" % get_version_string())


func _load_version_data() -> void:
	var file := FileAccess.open("res://game.config.json", FileAccess.READ)
	if file:
		var json := JSON.new()
		var err := json.parse(file.get_as_text())
		if err == OK and json.data is Dictionary:
			_version_data = json.data
		else:
			push_warning("GameManager: Failed to parse game.config.json")
	else:
		push_warning("GameManager: game.config.json not found")


func get_version_string() -> String:
	var v: String = _version_data.get("version", "0.0.0")
	var b: String = _version_data.get("build", "unknown")
	return "v%s build %s" % [v, b]


## Scene transition — the single entry point for all scene changes.
func change_scene(target_path: String, new_state: GameState = GameState.NONE) -> void:
	log_info("Scene transition: %s → %s" % [GameState.keys()[current_state], target_path])
	Events.scene_transition_started.emit(target_path)
	previous_state = current_state
	if new_state != GameState.NONE:
		current_state = new_state
	var err := get_tree().change_scene_to_file(target_path)
	if err != OK:
		push_error("GameManager: Failed to change scene to %s (error %d)" % [target_path, err])
		return
	Events.scene_transition_finished.emit()


func go_to_main_menu() -> void:
	reset_session()
	change_scene("res://scenes/MainMenu.tscn", GameState.MAIN_MENU)


func go_to_character_select() -> void:
	change_scene("res://scenes/CharacterSelect.tscn", GameState.CHARACTER_SELECT)


func go_to_town() -> void:
	change_scene("res://scenes/TownHall.tscn", GameState.TOWN)


func go_to_dungeon_entrance() -> void:
	change_scene("res://scenes/DungeonEntrance.tscn", GameState.DUNGEON_ENTRANCE)


func go_to_dungeon_floor() -> void:
	change_scene("res://scenes/DungeonFloor.tscn", GameState.DUNGEON)


func reset_session() -> void:
	session = {
		"class_name": "",
		"class_id": "",
		"player_level": 1,
		"current_floor": 0,
		"dungeon_seed": 0,
		"gold": 0,
		"play_time_seconds": 0.0,
	}


## Logging helpers — unified format for console output.
func log_info(msg: String) -> void:
	print("[Amaris] %s" % msg)


func log_warn(msg: String) -> void:
	push_warning("[Amaris] %s" % msg)


func log_error(msg: String) -> void:
	push_error("[Amaris] %s" % msg)

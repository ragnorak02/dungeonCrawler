extends Node2D
## Dungeon Floor — placeholder scene for a single dungeon level.

@onready var floor_label: Label = $FloorLabel


func _ready() -> void:
	GameManager.current_state = GameManager.GameState.DUNGEON
	floor_label.text = "Dungeon Floor %d  (Seed: %d)" % [
		DungeonManager.current_floor,
		DungeonManager.current_seed
	]
	Events.dungeon_floor_changed.emit(DungeonManager.current_floor)
	GameManager.log_info("DungeonFloor ready — floor %d" % DungeonManager.current_floor)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		_open_pause()
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("back"):
		_retreat()
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("cycle_right"):
		_go_deeper()
		get_viewport().set_input_as_handled()


func _retreat() -> void:
	GameManager.log_info("Retreating to town from floor %d" % DungeonManager.current_floor)
	DungeonManager.retreat_to_town()


func _go_deeper() -> void:
	if DungeonManager.current_floor < DungeonManager.max_floors:
		DungeonManager.go_deeper()
		GameManager.go_to_dungeon_floor()
	else:
		GameManager.log_info("Already at deepest floor")


func _open_pause() -> void:
	var pause_scene := preload("res://scenes/PauseMenu.tscn")
	var pause_instance := pause_scene.instantiate()
	add_child(pause_instance)

extends Control
## Town Hall — central hub with interaction points.

@onready var dungeon_btn: Button = $VBox/DungeonBtn
@onready var save_btn: Button = $VBox/SaveBtn


func _ready() -> void:
	GameManager.current_state = GameManager.GameState.TOWN
	Events.town_entered.emit()

	dungeon_btn.pressed.connect(_on_dungeon)
	save_btn.pressed.connect(_on_save)

	dungeon_btn.grab_focus()
	GameManager.log_info("TownHall ready — class: %s" % GameManager.session.get("class_name", "?"))


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		_open_pause()
		get_viewport().set_input_as_handled()


func _on_dungeon() -> void:
	AudioManager.play_sfx(AudioManager.SFX.UI_CONFIRM)
	GameManager.go_to_dungeon_entrance()


func _on_save() -> void:
	var ok := SaveManager.save_game()
	if ok:
		GameManager.log_info("Game saved!")
	AudioManager.play_sfx(AudioManager.SFX.UI_CONFIRM)


func _open_pause() -> void:
	# Add PauseMenu as overlay
	var pause_scene := preload("res://scenes/PauseMenu.tscn")
	var pause_instance := pause_scene.instantiate()
	add_child(pause_instance)

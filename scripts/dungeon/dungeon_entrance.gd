extends Control
## Dungeon Entrance — choice between new or continue dungeon run.

@onready var new_btn: Button = $VBox/NewDungeonBtn
@onready var continue_btn: Button = $VBox/ContinueBtn
@onready var back_btn: Button = $VBox/BackBtn


func _ready() -> void:
	GameManager.current_state = GameManager.GameState.DUNGEON_ENTRANCE

	new_btn.pressed.connect(_on_new_dungeon)
	continue_btn.pressed.connect(_on_continue)
	back_btn.pressed.connect(_on_back)

	# Disable continue if no active dungeon
	continue_btn.disabled = GameManager.session.get("dungeon_seed", 0) == 0

	new_btn.grab_focus()
	GameManager.log_info("DungeonEntrance ready")


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("back"):
		_on_back()
		get_viewport().set_input_as_handled()


func _on_new_dungeon() -> void:
	AudioManager.play_sfx(AudioManager.SFX.UI_CONFIRM)
	DungeonManager.start_new_dungeon()
	GameManager.go_to_dungeon_floor()


func _on_continue() -> void:
	AudioManager.play_sfx(AudioManager.SFX.UI_CONFIRM)
	DungeonManager.continue_dungeon()
	GameManager.go_to_dungeon_floor()


func _on_back() -> void:
	AudioManager.play_sfx(AudioManager.SFX.UI_BACK)
	GameManager.go_to_town()

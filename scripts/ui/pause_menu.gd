extends Control
## Pause Menu overlay — resume, quit to town, quit to menu.

@onready var resume_btn: Button = $Panel/VBox/ResumeBtn
@onready var quit_town_btn: Button = $Panel/VBox/QuitTownBtn
@onready var quit_menu_btn: Button = $Panel/VBox/QuitMenuBtn


func _ready() -> void:
	get_tree().paused = true
	process_mode = Node.PROCESS_MODE_ALWAYS

	resume_btn.pressed.connect(_on_resume)
	quit_town_btn.pressed.connect(_on_quit_town)
	quit_menu_btn.pressed.connect(_on_quit_menu)

	resume_btn.grab_focus()
	Events.pause_requested.emit()
	GameManager.log_info("PauseMenu opened")


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") or event.is_action_pressed("back"):
		_on_resume()
		get_viewport().set_input_as_handled()


func _on_resume() -> void:
	AudioManager.play_sfx(AudioManager.SFX.UI_BACK)
	get_tree().paused = false
	Events.pause_resumed.emit()
	queue_free()


func _on_quit_town() -> void:
	get_tree().paused = false
	AudioManager.play_sfx(AudioManager.SFX.UI_CONFIRM)
	DungeonManager.is_in_dungeon = false
	GameManager.go_to_town()


func _on_quit_menu() -> void:
	get_tree().paused = false
	AudioManager.play_sfx(AudioManager.SFX.UI_CONFIRM)
	GameManager.go_to_main_menu()

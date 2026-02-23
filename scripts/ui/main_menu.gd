extends Control
## Main Menu — title screen with Start and Quit.

@onready var start_button: Button = $VBox/StartButton
@onready var quit_button: Button = $VBox/QuitButton
@onready var version_label: Label = $VersionLabel


func _ready() -> void:
	GameManager.current_state = GameManager.GameState.MAIN_MENU
	version_label.text = GameManager.get_version_string()

	start_button.pressed.connect(_on_start)
	quit_button.pressed.connect(_on_quit)

	# Focus first button for controller navigation
	start_button.grab_focus()
	GameManager.log_info("MainMenu ready")


func _on_start() -> void:
	AudioManager.play_sfx(AudioManager.SFX.UI_CONFIRM)
	GameManager.go_to_character_select()


func _on_quit() -> void:
	GameManager.log_info("Quit requested")
	get_tree().quit()

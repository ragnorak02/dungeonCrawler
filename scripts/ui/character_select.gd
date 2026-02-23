extends Control
## Character class selection screen.

@onready var warrior_btn: Button = $ClassContainer/WarriorBtn
@onready var ranger_btn: Button = $ClassContainer/RangerBtn
@onready var shaman_btn: Button = $ClassContainer/ShamanBtn


func _ready() -> void:
	GameManager.current_state = GameManager.GameState.CHARACTER_SELECT

	warrior_btn.pressed.connect(_on_class_selected.bind("warrior", "Warrior"))
	ranger_btn.pressed.connect(_on_class_selected.bind("ranger", "Ranger"))
	shaman_btn.pressed.connect(_on_class_selected.bind("shaman", "Shaman"))

	warrior_btn.grab_focus()
	GameManager.log_info("CharacterSelect ready")


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("back"):
		AudioManager.play_sfx(AudioManager.SFX.UI_BACK)
		GameManager.go_to_main_menu()
		get_viewport().set_input_as_handled()


func _on_class_selected(class_id: String, class_name_str: String) -> void:
	GameManager.session["class_id"] = class_id
	GameManager.session["class_name"] = class_name_str
	GameManager.log_info("Class selected: %s" % class_name_str)
	AudioManager.play_sfx(AudioManager.SFX.UI_CONFIRM)
	GameManager.go_to_town()

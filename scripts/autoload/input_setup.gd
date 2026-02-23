extends Node
## Programmatic InputMap builder — clears project.godot drift on every boot.
## Autoload: InputSetup
##
## Xbox-first with keyboard fallback.
## All input actions are defined here, nowhere else.

const DEADZONE := 0.25


func _ready() -> void:
	_clear_all_actions()
	_setup_navigation()
	_setup_actions()
	_setup_menu()
	GameManager.log_info("InputSetup: InputMap built programmatically")


func _clear_all_actions() -> void:
	for action in InputMap.get_actions():
		# Keep built-in ui_ actions for theme/focus fallback
		if not action.begins_with("ui_"):
			InputMap.erase_action(action)


func _setup_navigation() -> void:
	# --- Move Up ---
	_add_action("move_up", [
		_key(KEY_W),
		_key(KEY_UP),
		_joy_axis(JOY_AXIS_LEFT_Y, -1.0),
		_joy_button(JOY_BUTTON_DPAD_UP),
	])

	# --- Move Down ---
	_add_action("move_down", [
		_key(KEY_S),
		_key(KEY_DOWN),
		_joy_axis(JOY_AXIS_LEFT_Y, 1.0),
		_joy_button(JOY_BUTTON_DPAD_DOWN),
	])

	# --- Move Left ---
	_add_action("move_left", [
		_key(KEY_A),
		_key(KEY_LEFT),
		_joy_axis(JOY_AXIS_LEFT_X, -1.0),
		_joy_button(JOY_BUTTON_DPAD_LEFT),
	])

	# --- Move Right ---
	_add_action("move_right", [
		_key(KEY_D),
		_key(KEY_RIGHT),
		_joy_axis(JOY_AXIS_LEFT_X, 1.0),
		_joy_button(JOY_BUTTON_DPAD_RIGHT),
	])


func _setup_actions() -> void:
	# A = Confirm / Interact
	_add_action("confirm", [
		_key(KEY_ENTER),
		_key(KEY_SPACE),
		_joy_button(JOY_BUTTON_A),
	])

	# B = Back / Dodge
	_add_action("back", [
		_key(KEY_ESCAPE),
		_key(KEY_BACKSPACE),
		_joy_button(JOY_BUTTON_B),
	])

	# X = Attack
	_add_action("attack", [
		_key(KEY_J),
		_joy_button(JOY_BUTTON_X),
	])

	# Y = Skill / Special
	_add_action("skill", [
		_key(KEY_K),
		_joy_button(JOY_BUTTON_Y),
	])

	# LB = Cycle Left
	_add_action("cycle_left", [
		_key(KEY_Q),
		_joy_button(JOY_BUTTON_LEFT_SHOULDER),
	])

	# RB = Cycle Right
	_add_action("cycle_right", [
		_key(KEY_E),
		_joy_button(JOY_BUTTON_RIGHT_SHOULDER),
	])

	# LT = Secondary Left
	_add_action("secondary_left", [
		_joy_axis(JOY_AXIS_TRIGGER_LEFT, 1.0),
	])

	# RT = Secondary Right
	_add_action("secondary_right", [
		_joy_axis(JOY_AXIS_TRIGGER_RIGHT, 1.0),
	])


func _setup_menu() -> void:
	# Start = Pause
	_add_action("pause", [
		_key(KEY_ESCAPE),
		_joy_button(JOY_BUTTON_START),
	])

	# Also wire ui_ actions so Godot theme focus works with controller
	_ensure_ui_action("ui_accept", [_joy_button(JOY_BUTTON_A)])
	_ensure_ui_action("ui_cancel", [_joy_button(JOY_BUTTON_B)])
	_ensure_ui_action("ui_up", [_joy_button(JOY_BUTTON_DPAD_UP)])
	_ensure_ui_action("ui_down", [_joy_button(JOY_BUTTON_DPAD_DOWN)])
	_ensure_ui_action("ui_left", [_joy_button(JOY_BUTTON_DPAD_LEFT)])
	_ensure_ui_action("ui_right", [_joy_button(JOY_BUTTON_DPAD_RIGHT)])


# --- Helper factories ---

func _add_action(action_name: String, events: Array) -> void:
	if not InputMap.has_action(action_name):
		InputMap.add_action(action_name, DEADZONE)
	for event in events:
		InputMap.action_add_event(action_name, event)


func _ensure_ui_action(action_name: String, events: Array) -> void:
	if not InputMap.has_action(action_name):
		InputMap.add_action(action_name, DEADZONE)
	for event in events:
		if not InputMap.action_has_event(action_name, event):
			InputMap.action_add_event(action_name, event)


func _key(keycode: int) -> InputEventKey:
	var ev := InputEventKey.new()
	ev.keycode = keycode
	return ev


func _joy_button(button_index: int) -> InputEventJoypadButton:
	var ev := InputEventJoypadButton.new()
	ev.button_index = button_index
	return ev


func _joy_axis(axis: int, value: float) -> InputEventJoypadMotion:
	var ev := InputEventJoypadMotion.new()
	ev.axis = axis
	ev.axis_value = value
	return ev

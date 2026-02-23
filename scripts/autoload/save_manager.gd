extends Node
## Save/Load system stub with versioned schema.
## Autoload: SaveManager

const SAVE_DIR := "user://saves/"
const SAVE_VERSION := 1

var _current_slot: int = 0


func _ready() -> void:
	DirAccess.make_dir_recursive_absolute(SAVE_DIR)
	GameManager.log_info("SaveManager ready — save dir: %s" % SAVE_DIR)


func save_game(slot: int = _current_slot) -> bool:
	var save_data := {
		"save_version": SAVE_VERSION,
		"timestamp": Time.get_datetime_string_from_system(true),
		"session": GameManager.session.duplicate(true),
	}

	var path := _slot_path(slot)
	var file := FileAccess.open(path, FileAccess.WRITE)
	if not file:
		GameManager.log_error("SaveManager: Cannot write to %s" % path)
		return false

	file.store_string(JSON.stringify(save_data, "\t"))
	GameManager.log_info("SaveManager: Saved slot %d" % slot)
	return true


func load_game(slot: int = _current_slot) -> bool:
	var path := _slot_path(slot)
	if not FileAccess.file_exists(path):
		GameManager.log_warn("SaveManager: No save at slot %d" % slot)
		return false

	var file := FileAccess.open(path, FileAccess.READ)
	if not file:
		GameManager.log_error("SaveManager: Cannot read %s" % path)
		return false

	var json := JSON.new()
	var err := json.parse(file.get_as_text())
	if err != OK or not json.data is Dictionary:
		GameManager.log_error("SaveManager: Corrupt save at slot %d" % slot)
		return false

	var data: Dictionary = json.data
	if data.get("save_version", 0) != SAVE_VERSION:
		GameManager.log_warn("SaveManager: Version mismatch in slot %d (expected %d, got %s)" % [
			slot, SAVE_VERSION, str(data.get("save_version", "?"))
		])
		# Future: migration logic here
		return false

	if data.has("session"):
		GameManager.session = data["session"]

	GameManager.log_info("SaveManager: Loaded slot %d" % slot)
	return true


func has_save(slot: int = _current_slot) -> bool:
	return FileAccess.file_exists(_slot_path(slot))


func delete_save(slot: int = _current_slot) -> void:
	var path := _slot_path(slot)
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(path)
		GameManager.log_info("SaveManager: Deleted slot %d" % slot)


func _slot_path(slot: int) -> String:
	return SAVE_DIR + "save_%d.json" % slot

extends SceneTree
## Headless smoke test runner for Amaris.
## Run via: godot --headless --script res://tests/test_runner.gd

var _results: Array = []
var _pass_count: int = 0
var _fail_count: int = 0


func _init() -> void:
	print("[Test] Amaris Test Runner starting...")
	_run_tests()
	_write_results()
	print("[Test] Done: %d passed, %d failed" % [_pass_count, _fail_count])
	quit(1 if _fail_count > 0 else 0)


func _run_tests() -> void:
	_test_game_config_exists()
	_test_project_status_exists()
	_test_data_files_exist()
	_test_scenes_exist()


func _test_game_config_exists() -> void:
	_assert_file_exists("res://game.config.json", "game.config.json exists")


func _test_project_status_exists() -> void:
	_assert_file_exists("res://project_status.json", "project_status.json exists")


func _test_data_files_exist() -> void:
	_assert_file_exists("res://data/items/weapons.json", "weapons.json exists")
	_assert_file_exists("res://data/items/armor.json", "armor.json exists")
	_assert_file_exists("res://data/classes/classes.json", "classes.json exists")
	_assert_file_exists("res://data/enemies/enemies.json", "enemies.json exists")
	_assert_file_exists("res://data/shops/weapon_shop.json", "weapon_shop.json exists")


func _test_scenes_exist() -> void:
	_assert_file_exists("res://scenes/MainMenu.tscn", "MainMenu.tscn exists")
	_assert_file_exists("res://scenes/CharacterSelect.tscn", "CharacterSelect.tscn exists")
	_assert_file_exists("res://scenes/TownHall.tscn", "TownHall.tscn exists")
	_assert_file_exists("res://scenes/DungeonEntrance.tscn", "DungeonEntrance.tscn exists")
	_assert_file_exists("res://scenes/DungeonFloor.tscn", "DungeonFloor.tscn exists")
	_assert_file_exists("res://scenes/PauseMenu.tscn", "PauseMenu.tscn exists")


# --- Assertion helpers ---

func _assert_file_exists(path: String, label: String) -> void:
	var exists := FileAccess.file_exists(path)
	_record(label, exists, "" if exists else "File not found: %s" % path)


func _record(label: String, passed: bool, error_msg: String = "") -> void:
	var status := "pass" if passed else "fail"
	if passed:
		_pass_count += 1
		print("[Test] PASS: %s" % label)
	else:
		_fail_count += 1
		print("[Test] FAIL: %s — %s" % [label, error_msg])
	_results.append({
		"name": label,
		"status": status,
		"error": error_msg,
	})


func _write_results() -> void:
	var output := {
		"test_runner": "amaris_smoke",
		"timestamp": Time.get_datetime_string_from_system(true),
		"total": _results.size(),
		"passed": _pass_count,
		"failed": _fail_count,
		"status": "pass" if _fail_count == 0 else "fail",
		"tests": _results,
	}
	var file := FileAccess.open("res://tests/test_results.json", FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(output, "\t"))
		print("[Test] Results written to tests/test_results.json")
	else:
		push_error("[Test] Could not write test_results.json")

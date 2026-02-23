extends Node
## JSON data loader for items, enemies, classes, shops.
## Autoload: DataRegistry
##
## Usage: DataRegistry.get_item("weapons", "short_sword")
##        DataRegistry.get_class("warrior")
##        DataRegistry.get_enemies()

var _data: Dictionary = {}

## Data directories to scan on startup
const DATA_SOURCES := {
	"weapons": "res://data/items/weapons.json",
	"armor": "res://data/items/armor.json",
	"classes": "res://data/classes/classes.json",
	"enemies": "res://data/enemies/enemies.json",
	"weapon_shop": "res://data/shops/weapon_shop.json",
}


func _ready() -> void:
	_load_all()
	GameManager.log_info("DataRegistry: Loaded %d data sources" % _data.size())


func _load_all() -> void:
	for key in DATA_SOURCES:
		var path: String = DATA_SOURCES[key]
		var result := _load_json(path)
		if result != null:
			_data[key] = result
		else:
			GameManager.log_warn("DataRegistry: Failed to load %s from %s" % [key, path])
			_data[key] = {}


func _load_json(path: String) -> Variant:
	if not FileAccess.file_exists(path):
		return null
	var file := FileAccess.open(path, FileAccess.READ)
	if not file:
		return null
	var json := JSON.new()
	var err := json.parse(file.get_as_text())
	if err != OK:
		GameManager.log_error("DataRegistry: JSON parse error in %s: %s" % [path, json.get_error_message()])
		return null
	return json.data


## Get a full data category (e.g., all weapons)
func get_data(category: String) -> Variant:
	return _data.get(category, {})


## Get a specific item by ID from a category
func get_item(category: String, item_id: String) -> Dictionary:
	var cat = _data.get(category, {})
	if cat is Dictionary:
		return cat.get(item_id, {})
	if cat is Array:
		for entry in cat:
			if entry is Dictionary and entry.get("id", "") == item_id:
				return entry
	return {}


## Shorthand for class data
func get_class(class_id: String) -> Dictionary:
	return get_item("classes", class_id)


## Shorthand for all enemies
func get_enemies() -> Variant:
	return get_data("enemies")

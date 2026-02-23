extends Node
## Audio routing stub — placeholder for SFX and music management.
## Autoload: AudioManager

enum SFX {
	UI_NAVIGATE,
	UI_CONFIRM,
	UI_BACK,
	ATTACK_SWING,
	ATTACK_HIT,
	ENEMY_DEATH,
	LOOT_PICKUP,
	PLAYER_HURT,
	LEVEL_UP,
	DOOR_OPEN,
	SHOP_BUY,
}

var _master_volume: float = 1.0
var _sfx_volume: float = 1.0
var _music_volume: float = 0.7


func _ready() -> void:
	GameManager.log_info("AudioManager ready (stub)")


## Play a sound effect by enum. Stub — logs only.
func play_sfx(sfx_id: SFX) -> void:
	GameManager.log_info("AudioManager: SFX → %s" % SFX.keys()[sfx_id])


## Play background music by path. Stub — logs only.
func play_music(_path: String, _fade_in: float = 0.5) -> void:
	GameManager.log_info("AudioManager: Music → %s" % _path)


## Stop current music. Stub.
func stop_music(_fade_out: float = 0.5) -> void:
	GameManager.log_info("AudioManager: Music stopped")


func set_master_volume(vol: float) -> void:
	_master_volume = clampf(vol, 0.0, 1.0)


func set_sfx_volume(vol: float) -> void:
	_sfx_volume = clampf(vol, 0.0, 1.0)


func set_music_volume(vol: float) -> void:
	_music_volume = clampf(vol, 0.0, 1.0)

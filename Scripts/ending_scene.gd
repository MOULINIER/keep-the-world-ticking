extends Node2D

@onready var map: TextureRect = $Map
@onready var nuke: AnimatedSprite2D = $Nuke
@onready var white: ColorRect = $White
@onready var siren: AudioStreamPlayer2D = $Siren
@onready var bombsound: AudioStreamPlayer2D = $BombExploding

const SIREN_LEAD_IN := 0.6
const NUKE_HOLD := 1.5
const FADE_TIME := 2.0

var _triggered := false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	nuke.visible = false
	# Critical: start transparent, and make sure it can actually receive alpha.
	white.color = Color(1.0, 1.0, 1.0, 0.0)
	white.mouse_filter = Control.MOUSE_FILTER_IGNORE
	white.z_index = 100


func trigger(country: String) -> void:
	if _triggered:
		return
	_triggered = true

	get_tree().paused = true
	visible = true
	siren.play()

	var marker := map.get_node_or_null(country) as Marker2D
	nuke.global_position = marker.global_position if marker else map.global_position + map.size * 0.5
	bombsound.play()
	await _wait(SIREN_LEAD_IN)
	
	
	nuke.visible = true
	nuke.frame = 0
	nuke.play("default")
	await _wait(NUKE_HOLD)

	var tween := create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(white, "color:a", 1.0, FADE_TIME)
	await tween.finished

	get_tree().paused = false
	get_tree().change_scene_to_file("res://scene/GameOver.tscn")


func _wait(seconds: float) -> void:
	await get_tree().create_timer(seconds, true, false, false).timeout

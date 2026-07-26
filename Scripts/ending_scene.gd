extends Node2D

@onready var map: TextureRect = $Map
@onready var nuke: AnimatedSprite2D = $Map/Nuke
@onready var white: ColorRect = $White
@onready var siren: AudioStreamPlayer2D = $Siren
@onready var bombsound: AudioStreamPlayer2D = $BombExploding

const FADE_IN := 1.0
const SIREN_LEAD_IN := 1.2
const NUKE_HOLD := 2
const FADE_OUT := 3.0

var _triggered := false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	nuke.visible = false
	modulate.a = 0.0
	white.color = Color(1, 1, 1, 0)
	white.mouse_filter = Control.MOUSE_FILTER_IGNORE
	white.z_index = 100


func trigger(country: String) -> void:
	if _triggered:
		return
	_triggered = true

	get_tree().paused = true
	visible = true

	var marker := map.get_node_or_null(country) as Marker2D
	nuke.global_position = marker.global_position if marker else map.global_position + map.size * 0.5
	
	var nukeArray = []
	var countryArray = ["China","India","Canada","Mexico","Egypt","Australia","France","Argentina","Russia","Japan","Danmark","SouthAfrica"]
	if !marker:
		nuke.global_position = map.get_node(countryArray[7]).global_position
		for i in range(12):
			nukeArray.insert(0,nuke.duplicate())
			self.add_child(nukeArray[0])
	
	siren.play()
	await _fade(self, "modulate:a", 1.0, FADE_IN)
	await _wait(SIREN_LEAD_IN)

	for i in range(nukeArray.size()):
		nukeArray[i].global_position = map.get_node(countryArray[i]).global_position
		nukeArray[i].visible = true
		nukeArray[i].frame = 0
		nukeArray[i].process_mode = Node.PROCESS_MODE_ALWAYS
		nukeArray[i].play("default")
		
	nuke.visible = true
	nuke.frame = 0
	await _fade(white, "color:a", 1, 0.2)
	nuke.play("default")
	bombsound.play()
	_shake(map, 1.2, 12.0)
	await _fade(white, "color:a", 0, 0.2)

	await _wait(NUKE_HOLD)


	await _fade(white, "color:a", 1.0, FADE_OUT)

	get_tree().paused = false
	visible = false
	for i in range(nukeArray.size()): nukeArray[i].visible = false
	nuke.visible = false
	white.color.a = 0.0
	_triggered = false
	get_tree().change_scene_to_file("res://scene/GameOver.tscn")


func _wait(seconds: float) -> void:
	await get_tree().create_timer(seconds, true, false, false).timeout


func _fade(node: Node, property: String, to: float, time: float) -> void:
	var tween := create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(node, property, to, time)
	await tween.finished

func _shake(node: CanvasItem, duration: float, strength: float) -> void:
	var original: Vector2 = node.position
	var elapsed := 0.0
	while elapsed < duration:
		var amount: float = strength * (1.0 - elapsed / duration)
		node.position = original + Vector2(
			randf_range(-amount, amount),
			randf_range(-amount, amount)
		)
		await get_tree().create_timer(0.02, true, false, false).timeout
		elapsed += 0.02
	node.position = original
extends Node2D

var color: Color 
var is_dragging: bool = false
var is_plugged: bool = false
var partner_location: Vector2
var isend: bool = false

@onready var sprite: Sprite2D = $Area2D/PlaceholderCable
@onready var line: Line2D = $Area2D/Line2D
@onready var sonclick: AudioStreamPlayer2D = $AudioStreamPlayer2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_plugged:
		line.set_point_position(1, line.to_local(partner_location))
	elif is_dragging:
		line.set_point_position(1, line.to_local(get_global_mouse_position()))
	else: 
		line.set_point_position(1, Vector2.ZERO)
		
	if is_dragging and Input.is_action_just_released("Click"):
		is_dragging = false
		var endposition: Vector2 =  get_global_mouse_position()
		if endposition.distance_to(partner_location) < 8:
			is_plugged = true
			

func set_color(color_temp: Color) -> void:
	color = color_temp
	sprite.modulate = color
	line.modulate = color
	

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and not is_plugged and not isend:
		is_dragging = true
		sonclick.play()

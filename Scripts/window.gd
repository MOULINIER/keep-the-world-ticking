extends Node2D

var mousePos : Vector2 = Vector2.ZERO
var difference : Vector2
var mouseIn : bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	difference = mousePos - get_global_mouse_position()
	if Input.is_action_pressed("Click") and mouseIn and difference != Vector2.ZERO:
		global_position -= difference
	mousePos = get_global_mouse_position()



func _on_move_window_area_mouse_entered() -> void:
	mouseIn = true


func _on_move_window_area_mouse_exited() -> void:
	mouseIn = false

#@tool
extends CharacterBody2D

var mouseInMove : bool
var mouseIn : bool
var onTop : bool
var shouldMove : bool
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if   ((Input.is_action_pressed("Click") and onTop) or (mouseIn and Input.is_action_just_pressed("Click"))):
		onTop = true
	else :
		onTop = false
	if  ((Input.is_action_pressed("Click") and shouldMove) or (mouseInMove and Input.is_action_just_pressed("Click"))):
		shouldMove = true
	else :
		shouldMove = false
	move_and_slide()
	velocity = Vector2.ZERO



func _on_move_window_area_mouse_entered() -> void:
	mouseInMove = true


func _on_move_window_area_mouse_exited() -> void:
	mouseInMove = false


func _on_window_area_mouse_entered() -> void:
	mouseIn = true

func _on_window_area_mouse_exited() -> void:
	mouseIn = false

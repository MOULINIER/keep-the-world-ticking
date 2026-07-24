#@tool
extends Node2D

#@export var window_texture : Texture2D:
#	set(value):
#		window_texture = value
#		if $windowSprite:
#			$windowSprite.texture = value

var mouseInMove : bool
var mouseIn : bool
var onTop : bool
var shouldMove : bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#if window_texture:
	#	$windowSprite.texture = window_texture

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if  mouseIn and ((Input.is_action_pressed("Click") and onTop) or Input.is_action_just_pressed("Click")):
		onTop = true
	else :
		onTop = false
	if  mouseInMove and ((Input.is_action_pressed("Click") and shouldMove) or Input.is_action_just_pressed("Click")):
		shouldMove = true
	else :
		shouldMove = false



func _on_move_window_area_mouse_entered() -> void:
	mouseInMove = true


func _on_move_window_area_mouse_exited() -> void:
	mouseInMove = false


func _on_window_area_mouse_entered() -> void:
	mouseIn = true

func _on_window_area_mouse_exited() -> void:
	mouseIn = false

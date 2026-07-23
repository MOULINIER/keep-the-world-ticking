extends Node2D

@onready var label: Label = $Window/Label
@onready var timer: Timer = $Timer
@onready var button: TextureButton = $Window/TextureButton

@export var total_seconds: int = 60
@export var second_added: int = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.wait_time = total_seconds
	timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	label.text = "%.2f" % timer.time_left


func _on_Timer_timeout() -> void:
	print("timeout")


func _on_texture_button_pressed() -> void:
	if timer.time_left > total_seconds - second_added :
		timer.start(timer.time_left + (total_seconds - timer.time_left))
	else:
		timer.start(timer.time_left + second_added)

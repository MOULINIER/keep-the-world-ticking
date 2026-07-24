extends Node2D

@onready var label: Label = $Window/Label
@onready var timer: Timer = $Timer
@onready var button: TextureButton = $Window/TextureButton
@onready var bar: TextureProgressBar = $Window/TextureProgressBar

@export var total_seconds: int = 60
@export var second_added: int = 5

var greenTexture = preload("res://assets/Window1TimeBarGreen.png")
var orangeTexture = preload("res://assets/Window1TimeBarOrange.png")
var redTexture = preload("res://assets/Window1TimeBarRed.png")
var whiteTexture = preload("res://assets/Window1TimeBarWhite.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.wait_time = total_seconds
	timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	label.text = "%.2f" % timer.time_left
	bar.value = timer.time_left/total_seconds * bar.max_value


func _on_Timer_timeout() -> void:
	print("timeout")


func _on_texture_button_pressed() -> void:
	if timer.time_left > total_seconds - second_added :
		timer.start(timer.time_left + (total_seconds - timer.time_left))
	else:
		timer.start(timer.time_left + second_added)


func _on_texture_progress_bar_value_changed(value: float) -> void:
	if value >= 67:
		bar.texture_progress = greenTexture
	elif value >= 33:
		bar.texture_progress = orangeTexture
	elif value >= 15:
		bar.texture_progress = redTexture
	elif int(value)%2 :
		bar.texture_progress = whiteTexture
	else :
		bar.texture_progress = redTexture

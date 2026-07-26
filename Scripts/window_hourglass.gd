extends Control

@onready var timer: Timer = $Timer
@onready var bar: TextureProgressBar = $Window/TextureProgressBar
@onready var hourglass : AnimatedSprite2D = $Window/HourglassAnimatedSprite2D
@onready var sonclick: AudioStreamPlayer2D = $Window/TextureButton/AudioStreamPlayer2D
@onready var sonsable: AudioStreamPlayer2D = $AudioStreamPlayer2D

@export var total_seconds: int = 20
@export var second_added: int = 5

@export var country: String = "Argentina"

var frameN = 19
var isRotating = false

var greenTexture = preload("res://assets/Window4TimeBarGreen.png")
var orangeTexture = preload("res://assets/Window4TimeBarOrange.png")
var redTexture = preload("res://assets/Window4TimeBarRed.png")
var whiteTexture = preload("res://assets/Window4TimeBarWhite.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.wait_time = total_seconds
	timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if isRotating:
		hourglass.rotation += 4*PI/180
		if int(hourglass.rotation/PI*180) > 90 and int(hourglass.rotation/PI*180) < 270:
			hourglass.rotation = 270*(PI/180)
			timer.start(total_seconds - timer.time_left)
		if int(hourglass.rotation/PI*180) > 360 :
			hourglass.rotation = 0
			isRotating = false
	hourglass.frame = clamp(int((total_seconds - timer.time_left) / float(total_seconds) * float(frameN)), 0, frameN - 1)
	bar.value = timer.time_left/total_seconds * bar.max_value


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

func _on_texture_button_pressed() -> void:
	isRotating = true
	sonclick.play()
	sonsable.play()

func _on_timer_timeout() -> void:
	EndingScene.trigger(country)

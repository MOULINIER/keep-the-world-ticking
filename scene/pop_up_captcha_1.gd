extends Control

@onready var timer: Timer = $Timer
@onready var bar: TextureProgressBar = $Window/TextureProgressBar

@export var total_seconds: int = 40
@export var country: String = "Russia"

var greenTexture = preload("res://assets/Window3TimeBarGreen.png")
var orangeTexture = preload("res://assets/Window3TimeBarOrange.png")
var redTexture = preload("res://assets/Window3TimeBarRed.png")
var whiteTexture = preload("res://assets/Window3TimeBarWhite.png")

var shouldBeActivated : Array[bool]
var isActivated : Array[bool]

# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	timer.wait_time = total_seconds
	timer.start()
	shouldBeActivated = [true,true,false,false,false,true,false,false,false]
	isActivated = [false,false,false,false,false,false,false,false,false]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	bar.value = timer.time_left/total_seconds * bar.max_value
	for i in range(isActivated.size()):
		if shouldBeActivated[i] != isActivated[i]:
			break
		if i == 8 :
			$Timer.paused = true
			visible = false

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


func _on_texture_button_0_toggled(toggled_on: bool) -> void:
	if toggled_on:
		isActivated[0] = true
	else :
		isActivated[0] = false

func _on_texture_button_1_toggled(toggled_on: bool) -> void:
	if toggled_on:
		isActivated[1] = true
	else :
		isActivated[1] = false

func _on_texture_button_2_toggled(toggled_on: bool) -> void:
	if toggled_on:
		isActivated[2] = true
	else :
		isActivated[2] = false

func _on_texture_button_3_toggled(toggled_on: bool) -> void:
	if toggled_on:
		isActivated[3] = true
	else :
		isActivated[3] = false

func _on_texture_button_4_toggled(toggled_on: bool) -> void:
	if toggled_on:
		isActivated[4] = true
	else :
		isActivated[4] = false

func _on_texture_button_5_toggled(toggled_on: bool) -> void:
	if toggled_on:
		isActivated[5] = true
	else :
		isActivated[5] = false

func _on_texture_button_6_toggled(toggled_on: bool) -> void:
	if toggled_on:
		isActivated[6] = true
	else :
		isActivated[6] = false

func _on_texture_button_7_toggled(toggled_on: bool) -> void:
	if toggled_on:
		isActivated[7] = true
	else :
		isActivated[7] = false

func _on_texture_button_8_toggled(toggled_on: bool) -> void:
	if toggled_on:
		isActivated[8] = true
	else :
		isActivated[8] = false


func _on_timer_timeout() -> void:
	EndingScene.trigger(country)

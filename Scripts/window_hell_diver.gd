extends Control

@onready var timer: Timer = $Timer
@onready var bar: TextureProgressBar = $Window/TextureProgressBar
@onready var buttonArray: Array[TextureButton] = [$Window/ArrowButton0,$Window/ArrowButton1,$Window/ArrowButton2,$Window/ArrowButton3,$Window/ArrowButton4]

@export var total_seconds: int = 20
@export var second_added: int = 5

var greenTexture = preload("res://assets/Window5TimeBarGreen.png")
var orangeTexture = preload("res://assets/Window5TimeBarOrange.png")
var redTexture = preload("res://assets/Window5TimeBarRed.png")
var whiteTexture = preload("res://assets/Window5TimeBarWhite.png")

var numberSpriteSheet = preload("res://assets/monkey_test-spritesheet.png")
var numberTexture: Array[AtlasTexture] = []
var numberTextureWidth = 17
var numberTextureHight = 17

var arrowOrder: Array[int]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for j in range(2):
		for i in range(4):
			var tex = AtlasTexture.new()
			tex.atlas = numberSpriteSheet
			tex.region = Rect2(i*numberTextureWidth,j*numberTextureHight,numberTextureWidth,numberTextureHight)
			numberTexture.append(tex)
	timer.wait_time = total_seconds
	timer.start()
	for i in range(4):
		var randi = randi_range(0,3)
		arrowOrder[i] = randi


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	bar.value = timer.time_left/total_seconds * bar.max_value
	for i in range(buttonArray.size):
		buttonArray[i].texture_pressed = numberTexture[arrowOrder[i]]


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

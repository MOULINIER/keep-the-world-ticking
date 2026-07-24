extends Node2D

@onready var label: Label = $Window/Label
@onready var timer: Timer = $Timer
@onready var button: TextureButton = $Window/TextureButton
@onready var bar: TextureProgressBar = $Window/TextureProgressBar
@onready var counter: AnimatedSprite2D = $Window/CounterAnimatedSprite2D
@onready var count0: Sprite2D = $Window/Counter0Sprite2D
@onready var count1: Sprite2D = $Window/Counter1Sprite2D
@onready var count2: Sprite2D = $Window/Counter2Sprite2D
@onready var count3: Sprite2D = $Window/Counter3Sprite2D

@export var total_seconds: int = 60
@export var second_added: int = 5

var greenTexture = preload("res://assets/Window1TimeBarGreen.png")
var orangeTexture = preload("res://assets/Window1TimeBarOrange.png")
var redTexture = preload("res://assets/Window1TimeBarRed.png")
var whiteTexture = preload("res://assets/Window1TimeBarWhite.png")

var numberSpriteSheet = preload("res://assets/green_counter_number-Sheet.png")
var numberTexture: Array[AtlasTexture] = []
var numberTextureWidth = 7
var numberTextureHight = 13


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(10):
		var tex = AtlasTexture.new()
		tex.atlas = numberSpriteSheet
		tex.region = Rect2(i*numberTextureWidth,0,numberTextureWidth,numberTextureHight)
		numberTexture.append(tex)
	counter.play("default")
	timer.wait_time = total_seconds
	timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	count0.texture = numberTexture[int(timer.time_left*0.1)]
	count1.texture = numberTexture[int(timer.time_left)%10]
	count2.texture = numberTexture[int(timer.time_left*10)%10]
	count3.texture = numberTexture[int(timer.time_left*100)%10]
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

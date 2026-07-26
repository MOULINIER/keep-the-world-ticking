extends Control

@onready var timer: Timer = $Timer
@onready var bar: TextureProgressBar = $Window/TextureProgressBar
@onready var buttonArray: Array[TextureButton] = [$Window/ArrowButton0,$Window/ArrowButton1,$Window/ArrowButton2,$Window/ArrowButton3,$Window/ArrowButton4]
@onready var sonclick: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var sonrate: AudioStreamPlayer2D = $AudioStreamPlayer2D2

@export var total_seconds: int = 20
@export var second_added: int = 5

@export var country: String = "France"

var greenTexture = preload("res://assets/Window6TimeBarGreen.png")
var orangeTexture = preload("res://assets/Window6TimeBarOrange.png")
var redTexture = preload("res://assets/Window6TimeBarRed.png")
var whiteTexture = preload("res://assets/Window6TimeBarWhite.png")

var numberSpriteSheet = preload("res://assets/arrows-Sheet.png")
var numberTexture: Array[AtlasTexture] = []
var numberTextureWidth = 17
var numberTextureHight = 17

var arrowOrder: Array[int]
var arrowInput: Array[int]

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
	for i in range(5):
		var randi = randi_range(0,3)
		arrowOrder.insert(i, randi)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	bar.value = timer.time_left/total_seconds * bar.max_value
	for i in range(buttonArray.size()):
		buttonArray[i].texture_normal = numberTexture[arrowOrder[i]]
		if arrowInput.size()>i:
			buttonArray[i].texture_normal = numberTexture[arrowOrder[i]+4]
			
	if Input.is_action_just_pressed("Left"):
		sonclick.play()
		arrowInput.insert(arrowInput.size(),0)
	if Input.is_action_just_pressed("Up"):
		sonclick.play()
		arrowInput.insert(arrowInput.size(),1)
	if Input.is_action_just_pressed("Down"):
		sonclick.play()
		arrowInput.insert(arrowInput.size(),2)
	if Input.is_action_just_pressed("Right"):
		sonclick.play()
		arrowInput.insert(arrowInput.size(),3)
		
	for i in range(arrowInput.size()):
		if arrowInput[i] != arrowOrder[i]:
			sonrate.play()
			arrowOrder.clear()
			arrowInput.clear()
			for j in range(5):
				var randi = randi_range(0,3)
				arrowOrder.insert(j, randi)
			break
		elif arrowInput.size() == arrowOrder.size():
			timer.start(total_seconds)
			arrowOrder.clear()
			arrowInput.clear()
			for j in range(5):
				var randi = randi_range(0,3)
				arrowOrder.insert(j, randi)
			break
			

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

func _on_timer_timeout() -> void:
	EndingScene.trigger(country)

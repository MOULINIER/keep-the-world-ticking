extends Control

@onready var timer: Timer = $Timer
@onready var bar: TextureProgressBar = $Window/TextureProgressBar
@onready var buttonArray: Array[TextureButton] = [$Window/NumOOSprite2D,$Window/NumO1Sprite2D,$Window/NumO2Sprite2D,$Window/Num1OSprite2D,$Window/Num11Sprite2D,$Window/Num12Sprite2D,$Window/Num2OSprite2D,$Window/Num21Sprite2D,$Window/Num22Sprite2D]

@export var total_seconds: int = 20
@export var second_added: int = 5

var greenTexture = preload("res://assets/Window5TimeBarGreen.png")
var orangeTexture = preload("res://assets/Window5TimeBarOrange.png")
var redTexture = preload("res://assets/Window5TimeBarRed.png")
var whiteTexture = preload("res://assets/Window5TimeBarWhite.png")

var numberSpriteSheet = preload("res://assets/monkey_test-spritesheet.png")
var numberTexture: Array[AtlasTexture] = []
var numberTextureWidth = 15
var numberTextureHight = 18

var touchOrder = [0,1,2,3,4,5,6,7,8]
var isCorrect : bool
var expectedNext : int
var isPressed : Array[bool]

var loseTime: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for j in range(4):
		for i in range(9):
			var tex = AtlasTexture.new()
			tex.atlas = numberSpriteSheet
			tex.region = Rect2(i*numberTextureWidth,j*numberTextureHight,numberTextureWidth,numberTextureHight)
			numberTexture.append(tex)
	timer.wait_time = total_seconds
	timer.start()
	isCorrect = true
	isPressed = [false,false,false,false,false,false,false,false,false]
	touchOrder.shuffle()
	expectedNext = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	bar.value = timer.time_left/total_seconds * bar.max_value
			
	for i in range(buttonArray.size()):
		if isCorrect:
			buttonArray[i].texture_normal = numberTexture[touchOrder[i]]
			buttonArray[i].texture_pressed = numberTexture[touchOrder[i]+9]
			buttonArray[i].texture_disabled = numberTexture[touchOrder[i]+9]
		else :
			buttonArray[i].disabled = true
			if isPressed[i]:
				buttonArray[i].texture_disabled = numberTexture[touchOrder[i]+18]
			else:
				buttonArray[i].texture_disabled = numberTexture[touchOrder[i]+27]
			if abs(loseTime - Time.get_unix_time_from_system())>0.5:
				touchOrder.shuffle()
				isCorrect = true
				expectedNext = 0
				isPressed = [false,false,false,false,false,false,false,false,false]
				for j in range(9):
					buttonArray[j].disabled = false

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

func _on_button_pressed(pos: int) -> void:
	buttonArray[pos].disabled = true
	isPressed[pos] = true
	if touchOrder[pos] == expectedNext:
		expectedNext += 1
		if expectedNext >= 9:
			timer.start(total_seconds)
			touchOrder.shuffle()
			isCorrect = true
			expectedNext = 0
			isPressed = [false,false,false,false,false,false,false,false,false]
			for i in range(9) :
				buttonArray[i].disabled = false
	else:
		isCorrect = false 
		loseTime = Time.get_unix_time_from_system()

func _on_num_oo_sprite_2d_pressed() -> void:
	_on_button_pressed(0)

func _on_num_o_1_sprite_2d_pressed() -> void:
	_on_button_pressed(1)

func _on_num_o_2_sprite_2d_pressed() -> void:
	_on_button_pressed(2)

func _on_num_1o_sprite_2d_pressed() -> void:
	_on_button_pressed(3)

func _on_num_11_sprite_2d_pressed() -> void:
	_on_button_pressed(4)

func _on_num_12_sprite_2d_pressed() -> void:
	_on_button_pressed(5)

func _on_num_2o_sprite_2d_pressed() -> void:
	_on_button_pressed(6)

func _on_num_21_sprite_2d_pressed() -> void:
	_on_button_pressed(7)

func _on_num_22_sprite_2d_pressed() -> void:
	_on_button_pressed(8)

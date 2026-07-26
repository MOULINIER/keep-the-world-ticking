extends Control

@onready var timer: Timer = $Timer
@onready var bar: TextureProgressBar = $Window/TextureProgressBar

@onready var num00: Sprite2D = $Window/BlueScreen/num00Sprite2D
@onready var num01: Sprite2D = $Window/BlueScreen/num01Sprite2D
@onready var num10: Sprite2D = $Window/BlueScreen/num10Sprite2D
@onready var num11: Sprite2D = $Window/BlueScreen/num11Sprite2D

@onready var res0: Sprite2D = $Window/BlueScreen/res0Sprite2D
@onready var res1: Sprite2D = $Window/BlueScreen/res1Sprite2D
@onready var res2: Sprite2D = $Window/BlueScreen/res2Sprite2D

@onready var sonclick: AudioStreamPlayer2D = $Window/calcBackgroud/AudioStreamPlayer2D

@export var country: String = "India"

var numberSpriteSheet = preload("res://assets/white_numbers-Sheet.png")
var numberTexture: Array[AtlasTexture] = []
var numberTextureWidth = 6
var numberTextureHight = 5

@export var total_seconds: int = 20
@export var second_added: int = 2

var rand0 : int
var rand1 : int
var playerRes : int

var greenTexture = preload("res://assets/Window2TimeBarGreen.png")
var orangeTexture = preload("res://assets/Window2TimeBarOrange.png")
var redTexture = preload("res://assets/Window2TimeBarRed.png")
var whiteTexture = preload("res://assets/Window2TimeBarWhite.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(10):
		var tex = AtlasTexture.new()
		tex.atlas = numberSpriteSheet
		tex.region = Rect2(i*numberTextureWidth,0,numberTextureWidth,numberTextureHight)
		numberTexture.append(tex)
	timer.wait_time = total_seconds
	timer.start()
	rand0 = randi_range(1,99)
	rand1 = randi_range(1,99)
	playerRes = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	bar.value = timer.time_left/total_seconds * bar.max_value
	num00.texture = numberTexture[rand0/10]
	num01.texture = numberTexture[rand0%10]
	num10.texture = numberTexture[rand1/10]
	num11.texture = numberTexture[rand1%10]
	res0.texture = numberTexture[playerRes/100]
	res1.texture = numberTexture[(playerRes/10)%10]
	res2.texture = numberTexture[playerRes%10]


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

func _on_texture_button_x_pressed() -> void:
	playerRes = 0
	sonclick.play()


func _on_texture_button_1_pressed() -> void:
	sonclick.play()
	if playerRes*10>999:
		pass
	else :
		playerRes = playerRes*10 + 1

func _on_texture_button_2_pressed() -> void:
	sonclick.play()
	if playerRes*10>999:
		pass
	else :
		playerRes = playerRes*10 + 2

func _on_texture_button_3_pressed() -> void:
	sonclick.play()
	if playerRes*10>999:
		pass
	else :
		playerRes = playerRes*10 + 3

func _on_texture_button_4_pressed() -> void:
	sonclick.play()
	if playerRes*10>999:
		pass
	else :
		playerRes = playerRes*10 + 4

func _on_texture_button_5_pressed() -> void:
	sonclick.play()
	if playerRes*10>999:
		pass
	else :
		playerRes = playerRes*10 + 5

func _on_texture_button_6_pressed() -> void:
	sonclick.play()
	if playerRes*10>999:
		pass
	else :
		playerRes = playerRes*10 + 6

func _on_texture_button_7_pressed() -> void:
	sonclick.play()
	if playerRes*10>999:
		pass
	else :
		playerRes = playerRes*10 + 7

func _on_texture_button_8_pressed() -> void:
	sonclick.play()
	if playerRes*10>999:
		pass
	else :
		playerRes = playerRes*10 + 8

func _on_texture_button_9_pressed() -> void:
	sonclick.play()
	if playerRes*10>999:
		pass
	else :
		playerRes = playerRes*10 + 9

func _on_texture_button_0_pressed() -> void:
	sonclick.play()
	if playerRes*10>999:
		pass
	else :
		playerRes = playerRes*10 + 0

func _on_texture_button_v_pressed() -> void:
	sonclick.play()
	if playerRes == 666:
		EndingScene.trigger("")
		
	if playerRes == rand0 + rand1 :
		timer.start(total_seconds)
	rand0 = randi_range(1,99)
	rand1 = randi_range(1,99)
	playerRes = 0


func _on_timer_timeout() -> void:
	EndingScene.trigger(country)

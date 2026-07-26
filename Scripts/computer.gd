extends Node2D

@export var volumeDbMusic = -10

@onready var sonalert : AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var sonclick : AudioStreamPlayer2D = $AudioStreamPlayer2D2
@onready var sonalarm : AudioStreamPlayer2D = $AudioStreamPlayer2D3

var mousePos : Vector2 = Vector2.ZERO
var mouseDifference : Vector2
var windowArray = []
var windowTimeArray = []
var windowAvailable = []
var windowShort = []
var windowMedium = []
var windowLong = []
var premiere = false
var windowButtonDict : Array

var cursorHandPreload = preload("res://assets/curseur.png")

var popUpPreloadArray = [preload("res://scene/popUpHeathcare.tscn"),preload("res://scene/popUpMicroslopeEdge.tscn"),preload("res://scene/popUpCaptcha1.tscn"),preload("res://scene/popUpCaptcha2.tscn"),preload("res://scene/popUpCaptcha3.tscn"),preload("res://scene/popUpCaptcha4.tscn")]
var popUpArray = []

var iClignotage : int
var shouldClignote : bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	iClignotage = 5
	shouldClignote = false
	$WindowMail.z_index = 500
	$AudioPlayerChill.volume_db = volumeDbMusic
	$AudioPlayerGame.volume_db = -80
	$AudioPlayerGameInstr.volume_db = -80
	windowShort = [$WindowPress,$WindowHourglass]
	windowMedium = [$WindowMonkey,$WindowHellDiver]
	windowLong = [$WindowCalc,$WindowCableBox]
	windowAvailable = [windowShort,windowLong,windowMedium,windowShort,windowLong,windowMedium]
	windowTimeArray = [15,15,20,30,40,999]
	windowButtonDict = [
			[$WindowButtonTest, $ChinaButton, false],
			[$WindowPress, $MexicoButton, false],
			[$WindowCalc, $IndiaButton, false],
			[$WindowHourglass, $ArgentinaButton, false],
			[$WindowMonkey, $JapanButton, false],
			[$WindowCableBox, $CanadaButton, false],
			[$WindowHellDiver, $FranceButton, false]
		]
	windowArray = [$WindowButtonTest]
	
	$WindowButtonTest.process_mode = Node.PROCESS_MODE_DISABLED
	for window in windowShort:
		window.visible = false
		window.process_mode = Node.PROCESS_MODE_DISABLED
	for window in windowMedium:
		window.visible = false
		window.process_mode = Node.PROCESS_MODE_DISABLED
	for window in windowLong:
		window.visible = false
		window.process_mode = Node.PROCESS_MODE_DISABLED
	
	for windowButton in windowButtonDict:
		windowButton[1].visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for windowButton in windowButtonDict:
		var window = windowButton[0]
		var button = windowButton[1]
		var timer = window.get_node("Timer")
		
		if window.visible and not timer.is_stopped() and window.total_seconds > 0:
			var ratio = timer.time_left / window.total_seconds
			if ratio < 0.33:
				if not windowButton[2]:
					sonalert.play()
					windowButton[2] = true 
				button.get_node("WarningAnimatedSprite2D").frame = 1
			else:
				button.get_node("WarningAnimatedSprite2D").frame = 0
				windowButton[2] = false 
		else:
			button.get_node("WarningAnimatedSprite2D").frame = 0
			windowButton[2] = false

		if window.visible:
			button.visible = true

	# Mouse movement updates
	mouseDifference = mousePos - get_global_mouse_position()
	mousePos = get_global_mouse_position()

	for i in range(windowArray.size()):
		windowArray[i].get_node("Window").velocity = Vector2.ZERO

	for i in range(windowArray.size()):
		if windowArray[i].get_node("Window").shouldMove:
			windowArray[i].get_node("Window").velocity -= mouseDifference / delta
			break

	for i in range(windowArray.size()):
		if windowArray[i].get_node("Window").onTop:
			var temp = windowArray[i]
			windowArray.remove_at(i)
			windowArray.insert(0, temp)
			break

	for i in range(windowArray.size()):
		windowArray[i].z_index = 100 - i

func _on_back_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		get_tree().change_scene_to_file("res://scene/desk.tscn")
		
func _wait(seconds: float) -> void:
	await get_tree().create_timer(seconds, true, false, false).timeout


func _on_timer_window_timeout() -> void:
	if !windowAvailable.is_empty():
		if !windowAvailable[0].is_empty():
			var randi = randi_range(0,windowAvailable[0].size()-1)
			windowArray.insert(0,windowAvailable[0][randi])
			windowAvailable[0].remove_at(randi)
			windowArray[0].visible = true
			windowArray[0].process_mode = Node.PROCESS_MODE_INHERIT
			windowAvailable.remove_at(0)
			$TimerWindow.start(windowTimeArray[0])
			windowTimeArray.remove_at(0)

func _on_timer_pop_up_timeout() -> void:
	var randi = randi_range(0,popUpPreloadArray.size()-1)
	var popUp = popUpPreloadArray[randi]
	var popUpInst = popUp.instantiate()
	add_child(popUpInst)
	windowArray.insert(0,popUpInst)
	var randX = randi_range(38,220)
	var randY = randi_range(18,125)
	popUpInst.global_position = Vector2(randX,randY)
	$TimerPopUp.start(randi_range(5,25))
	#add_child(popUpPreloadArray[randi].instanciate())

func _on_country_button_pressed(window : Control) -> void:
	if window.process_mode != Node.PROCESS_MODE_DISABLED:
		if window.z_index == 100 || !window.get_node("Window").visible:
			window.get_node("Window").visible = !window.get_node("Window").visible
		else:
			for i in range(windowArray.size()):
				if windowArray[i] == window:
					windowArray.remove_at(i)
					windowArray.insert(0,window)
					break

func _on_china_button_pressed() -> void:
	sonclick.play()
	_on_country_button_pressed($WindowButtonTest)
		
func _on_mexico_button_pressed() -> void:
	sonclick.play()
	_on_country_button_pressed($WindowPress)

func _on_argentina_button_pressed() -> void:
	sonclick.play()
	_on_country_button_pressed($WindowHourglass)

func _on_japan_button_pressed() -> void:
	sonclick.play()
	_on_country_button_pressed($WindowMonkey)

func _on_canada_button_pressed() -> void:
	sonclick.play()
	_on_country_button_pressed($WindowCableBox)

func _on_india_button_pressed() -> void:
	sonclick.play()
	_on_country_button_pressed($WindowCalc)

func _on_france_button_pressed() -> void:
	sonclick.play()
	_on_country_button_pressed($WindowHellDiver)


func _on_start_button_pressed() -> void:
	sonalarm.play()
	$StartButtonBackGroundSprite2D.visible = false
	$WindowButtonTest.visible = true
	$WindowButtonTest.process_mode = Node.PROCESS_MODE_INHERIT
	$TimerWindow.start()
	$TimerPopUp.start()
	
	$TimerFiltre0.start()
	shouldClignote = true
	$CanvasModulate.color = Color(1, 0.7, 0.7)
	
	Global.startTime = Time.get_unix_time_from_system()
	print(Global.startTime)
	
	$NukeSentAnimatedSprite2D.visible=true
	$NukeSentAnimatedSprite2D.play("default")
	
	$TimerMusicInstr.start()
	$AudioPlayerGame.play()
	$AudioPlayerGameInstr.play()
	var tween = create_tween()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	tween.set_parallel(false)
	tween.tween_property($AudioPlayerGame, "volume_db", volumeDbMusic-10, 1)
	
	tween.set_parallel(true)
	tween.tween_property($AudioPlayerChill, "volume_db", volumeDbMusic-10, 1)
	tween.tween_property($AudioPlayerGame, "volume_db", volumeDbMusic, 1)
	
	tween.set_parallel(false)
	tween.tween_property($AudioPlayerChill, "volume_db", -80, 1)


func _on_area_2d_mouse_entered() -> void:
	Input.set_custom_mouse_cursor(null)
	pass


func _on_area_2d_mouse_exited() -> void:
	Input.set_custom_mouse_cursor(null)
	pass


func _on_timer_music_instr_timeout() -> void:
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_EXPO)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	tween.set_parallel(false)
	tween.tween_property($AudioPlayerGameInstr, "volume_db", volumeDbMusic-10, 1)
	
	tween.set_parallel(true)
	tween.tween_property($AudioPlayerGame, "volume_db", volumeDbMusic-10, 1)
	tween.tween_property($AudioPlayerGameInstr, "volume_db", volumeDbMusic, 1)
	
	tween.set_parallel(false)
	tween.tween_property($AudioPlayerGame, "volume_db", -80, 1)
	


func _on_timer_filtre_timeout() -> void:
	iClignotage -= 1
	if iClignotage <= 0:
		shouldClignote = false
	$CanvasModulate.color = Color(1, 1, 1)
	if shouldClignote:
		$TimerFiltre1.start()
	

func _on_timer_filtre_1_timeout() -> void:
	$CanvasModulate.color = Color(1, 0.7, 0.7)
	$TimerFiltre0.start()

func _on_quit_button_pressed() -> void:
	sonclick.play()
	get_tree().change_scene_to_file("res://scene/game.tscn")

func _on_mute_button_toggled(toggled_on: bool) -> void:
	sonclick.play()
	var bus_index = AudioServer.get_bus_index("Master")
	if !toggled_on :
		AudioServer.set_bus_volume_db(bus_index, 0)
	else :
		AudioServer.set_bus_volume_db(bus_index, -80)

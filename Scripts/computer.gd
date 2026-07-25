extends Node2D

var mousePos : Vector2 = Vector2.ZERO
var mouseDifference : Vector2
var windowArray = []
var windowAvailable = []
var windowShort = []
var windowMedium = []
var windowLong = []

var windowButtonDict : Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	windowShort = [$WindowPress,$WindowHourglass]
	windowMedium = [$WindowMonkey]
	windowLong = [$WindowCalc,$WindowCableBox]
	windowAvailable = [windowShort,windowLong,windowMedium,windowShort,windowLong]
	windowButtonDict = [
		[$WindowButtonTest,$ChinaButton],
		[$WindowPress,$MexicoButton],
		[$WindowCalc,$IndiaButton],
		[$WindowHourglass,$ArgentinaButton],
		[$WindowMonkey,$JapanButton],
		[$WindowCableBox,$CanadaButton]
	]
	windowArray = [$WindowButtonTest]
	for window in windowShort:
		window.visible = false
		window.process_mode = Node.PROCESS_MODE_DISABLED
	for window in windowMedium:
		window.visible = false
		window.process_mode = Node.PROCESS_MODE_DISABLED
	for window in windowLong:
		window.visible = false
		window.process_mode = Node.PROCESS_MODE_DISABLED
	$TimerWindow.start()
	
	for windowButton in windowButtonDict:
		windowButton[1].visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for windowButton in windowButtonDict:
		if windowButton[0].visible :
			windowButton[1].visible = true		
	mouseDifference = mousePos - get_global_mouse_position()
	mousePos = get_global_mouse_position()
	
	for i in range(windowArray.size()) :
		windowArray[i].get_node("Window").velocity = Vector2.ZERO
	
	for i in range(windowArray.size()) :
		if windowArray[i].get_node("Window").shouldMove :
			#windowArray[i].global_position -= mouseDifference
			windowArray[i].get_node("Window").velocity -= mouseDifference/delta
			break
			
	for i in range(windowArray.size()) :
		if windowArray[i].get_node("Window").onTop :
			var temp = windowArray[i]
			windowArray.remove_at(i)
			windowArray.insert(0,temp)
			break
	for i in range(windowArray.size()) :
		windowArray[i].z_index = 100-i


func _on_back_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		get_tree().change_scene_to_file("res://scene/desk.tscn")
		


func _on_timer_window_timeout() -> void:
	if !windowAvailable.is_empty():
		if !windowAvailable[0].is_empty():
			var randi = randi_range(0,windowAvailable[0].size()-1)
			windowArray.insert(0,windowAvailable[0][randi])
			windowAvailable[0].remove_at(randi)
			windowArray[0].visible = true
			windowArray[0].process_mode = Node.PROCESS_MODE_INHERIT
			windowAvailable.remove_at(0)
		


func _on_china_button_pressed() -> void:
	print($WindowButtonTest.visible)
	if $WindowButtonTest.process_mode != Node.PROCESS_MODE_DISABLED:
		$WindowButtonTest.get_node("Window").visible = !$WindowButtonTest.get_node("Window").visible

func _on_mexico_button_pressed() -> void:
	if $WindowPress.process_mode != Node.PROCESS_MODE_DISABLED:
		$WindowPress.get_node("Window").visible = !$WindowPress.get_node("Window").visible

func _on_argentina_button_pressed() -> void:
	if $WindowHourglass.process_mode != Node.PROCESS_MODE_DISABLED:
		$WindowHourglass.get_node("Window").visible = !$WindowHourglass.get_node("Window").visible

func _on_japan_button_pressed() -> void:
	if $WindowMonkey.process_mode != Node.PROCESS_MODE_DISABLED:
		$WindowMonkey.get_node("Window").visible = !$WindowMonkey.get_node("Window").visible

func _on_canada_button_pressed() -> void:
	if $WindowCableBox.process_mode != Node.PROCESS_MODE_DISABLED:
		$WindowCableBox.get_node("Window").visible = !$WindowCableBox.get_node("Window").visible

func _on_india_button_pressed() -> void:
	if $WindowCalc.process_mode != Node.PROCESS_MODE_DISABLED:
		$WindowCalc.get_node("Window").visible = !$WindowCalc.get_node("Window").visible

extends Node2D

var mousePos : Vector2 = Vector2.ZERO
var mouseDifference : Vector2
var windowArray = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	windowArray = [$WindowButtonTest, $WindowTest1, $WindowTimeBar,$WindowPress, $WindowCalc]
	windowArray[0].z_index = 100


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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
		

extends Control
var COLORS := [
	Color.html("ea323c"),
	Color.html("0c0293"),
	Color.html("ffc825"),
	Color.html("5ac54f"),
	Color.html("ca52c9")
]
@onready var start := $Window/CabbleBox/Start.get_children()
@onready var end := $Window/CabbleBox/End.get_children()
@onready var timer: Timer = $Timer
@onready var bar: TextureProgressBar = $Window/TextureProgressBar
@onready var bulbs := $Window/BuldGroup.get_children()

var complete: bool = false
@export var total_seconds: int = 40

var greenTexture = preload("res://assets/Window3TimeBarGreen.png")
var orangeTexture = preload("res://assets/Window3TimeBarOrange.png")
var redTexture = preload("res://assets/Window3TimeBarRed.png")
var whiteTexture = preload("res://assets/Window3TimeBarWhite.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shuffle_cables_initialise()
	timer.start()
	
	bulbs.sort_custom(func(a, b): return a.position.x < b.position.x)

	for bulb in bulbs:
		if bulb is Sprite2D and bulb.texture is AtlasTexture:
			bulb.texture = bulb.texture.duplicate()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_cables()
	update_bulbs()
	bar.value = timer.time_left/total_seconds * bar.max_value
	if !complete:
		complete = check_complete()
	else: 
		reset_game()
		shuffle_cables_initialise()
		timer.start()
		complete = false
			


func check_complete() -> bool:
	for i in range(start.size()):
		if !start[i].is_plugged:
			return false
	print("complete")
	return true

func get_plugged_count() -> int:
	var count := 0
	for cable in start:
		if cable.is_plugged:
			count += 1
	return count

func update_bulbs() -> void:
	var plugged_count := get_plugged_count()
	var bulb_width := 9
	var bulb_height := 12 
	
	for i in range(bulbs.size()):
		if bulbs[i] is Sprite2D and bulbs[i].texture is AtlasTexture:
			var atlas_tex := bulbs[i].texture as AtlasTexture
			if i < plugged_count:
				atlas_tex.region = Rect2(0, 0, bulb_width, bulb_height)
			else:
				atlas_tex.region = Rect2(bulb_width, 0, bulb_width, bulb_height)

func reset_game() -> void:
	for i in range(start.size()):
		start[i].is_plugged = false
		
func shuffle_cables_initialise() -> void:
	start.shuffle()
	end.shuffle()
	for i in range(start.size()):
		start[i].set_color(COLORS[i])
		end[i].set_color(COLORS[i])
		end[i].isend = true

func update_cables() -> void:
	for i in range(start.size()):
		var partner
		var color = start[i].color
		for j in range(end.size()):
			if end[j].color == color:
				partner = j
		start[i].partner_location = end[partner].global_position + Vector2(-4,0)

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

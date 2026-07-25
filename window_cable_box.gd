extends Node2D
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

var complete: bool = false
@export var total_seconds: int = 40

var greenTexture = preload("res://assets/Window1TimeBarGreen.png")
var orangeTexture = preload("res://assets/Window1TimeBarOrange.png")
var redTexture = preload("res://assets/Window1TimeBarRed.png")
var whiteTexture = preload("res://assets/Window1TimeBarWhite.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shuffle_cables_initialise()
	timer.start()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_cables()
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
		start[i].partner_location = end[partner].global_position

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

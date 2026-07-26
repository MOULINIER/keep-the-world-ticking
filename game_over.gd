extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Black/TimeRichTextLabel.text = "[font=res://assets/fonts/Ordin-Bold.otf]%02d:%02d" % [int(int(Global.loseTime - Global.startTime)/60),(int(Global.loseTime - Global.startTime)%60)]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	get_tree().paused = false


func _on_restart_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/game.tscn")

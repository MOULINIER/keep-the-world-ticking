extends Node2D

var greenTexture = preload("res://assets/placeHolder/placeHolderProgressBarGreen.png")
var orangeTexture = preload("res://assets/placeHolder/placeHolderProgressBarOrange.png")
var redTexture = preload("res://assets/placeHolder/placeHolderProgressBarRed.png")
var whiteTexture = preload("res://assets/placeHolder/placeHolderProgressBarWhite.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$ProgressBar.value = $Timer.time_left/$Timer.wait_time * $ProgressBar.max_value


func _on_texture_button_pressed() -> void:
	$Timer.start()


func _on_progress_bar_value_changed(value: float) -> void:
	if value >= 67:
		$ProgressBar.texture_progress = greenTexture
	elif value >= 33:
		$ProgressBar.texture_progress = orangeTexture
	elif value >= 15:
		$ProgressBar.texture_progress = redTexture
	elif int(value)%2 :
		$ProgressBar.texture_progress = whiteTexture
	else :
		$ProgressBar.texture_progress = redTexture
		
		
		
	

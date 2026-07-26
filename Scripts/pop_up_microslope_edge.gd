extends Control

var i: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	i = 0
	$Window/AnimatedSprite2D.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if i >= 2:
		$Window/AnimatedSprite2D.visible = false


func _on_animated_sprite_2d_animation_looped() -> void:
	i += 1

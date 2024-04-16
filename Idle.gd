extends AnimatedSprite2D


var _animated_sprite

func _ready():
	_animated_sprite = $AnimatedSprite2D

func _process(_delta):
	if Input.is_action_pressed("ui_right"):
		_animated_sprite.play("Idle")
	else:
		_animated_sprite.play("Idle")

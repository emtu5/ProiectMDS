extends CharacterBody2D
const bulletPath = preload('res://Bullet.tscn')

var _animated_sprite = 1
func _ready():
	_animated_sprite = $AnimatedSprite2D
func name():
	return "Player"
func _process(_delta):
	_animated_sprite.play("Idle")
	if Input.is_action_just_pressed("ui_accept"):
		shoot()
	$Node2D.look_at(get_global_mouse_position())


func shoot():
	var bullet = bulletPath.instantiate()
	get_parent().add_child(bullet)
	bullet.position = $Node2D/Marker2D.global_position
	bullet.velocity = get_global_mouse_position() - bullet.position






var max_speed : int = 3
var acceleration : int = 500

func _physics_process(_delta):

	if Input.is_action_pressed("ui_right"):
		position.x += max_speed
		$AnimatedSprite2D.flip_h = false
	if Input.is_action_pressed("ui_left"):
		position.x -= max_speed
		$AnimatedSprite2D.flip_h = true
	if Input.is_action_pressed("ui_down"):
		position.y += max_speed
		$AnimatedSprite2D.flip_h = false
	if Input.is_action_pressed("ui_up"):
		position.y -= max_speed
		$AnimatedSprite2D.flip_h = false
	else:
		position.x += 0

	position.x += 0

	if Input.is_action_just_released("ui_select"):
		if velocity.y < 0:
			velocity.y += 400


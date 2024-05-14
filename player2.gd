extends CharacterBody2D
const bulletPath = preload('res://Bullet.tscn')

var healing = 0
var _animated_sprite = 1

var MAX_HP = 3
var hp = MAX_HP

func _ready():
	_animated_sprite = $AnimatedSprite2D
	set_hp()
	
	
	
## Setez hp-ul
func set_hp():
	set_hp_label()
	$HealthBar.max_value = MAX_HP
	set_hp_bar()
	
	
func name():
	return "Player"
	
## Setez label-ul la hp (e cam mare, ma mai gandesc daca sa il folosesc sau nu)
func set_hp_label():
	$HealthLabel.text =  "Health: "
	
## Setez bara de hp(se updateaza hp ul actual) 
func set_hp_bar():
	$HealthBar.value = hp

	
func damaged():
	hp -= 1
	set_hp_bar()
func healed():
	hp = MAX_HP
	set_hp_bar()
	
func _process(_delta):
	
	 ## $TimeRemaining.text = "%s" % roundf($BulletTimer.time_left) -- ref for spells timers
	_animated_sprite.play("Idle2")
	
	
	if Input.is_action_just_pressed("shoot") and $BulletTimer.get_time_left() == 0:
		##shoot()
		$BulletTimer.start()
	$Node2D.look_at(get_global_mouse_position())


func shoot():
	var bullet = bulletPath.instantiate()
	get_parent().add_child(bullet)
	bullet.position = $Node2D/Marker2D.global_position
	bullet.velocity = get_global_mouse_position() - bullet.position






var max_speed : int = 2
var acceleration : int = 500

func _physics_process(_delta):
	
	##if is_on_floor()
	
	
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
	move_and_slide()
	if Input.is_action_just_released("ui_select"):
		if velocity.y < 0:
			velocity.y += 400
	

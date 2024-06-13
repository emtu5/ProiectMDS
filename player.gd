extends CharacterBody2D
const bulletPath = preload('res://Bullet.tscn')
@onready var pause_menu = $PauseMenu

var score = 0
var collect = 0
var _animated_sprite = 1

var MAX_HP = 5
var hp = MAX_HP

var paused = true;


func _ready():
	_animated_sprite = $AnimatedSprite2D
	pause_menu = $PauseMenu
	set_hp()
	pauseMenu()
	

func pauseMenu():
	print("Paused ")
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1

	else:
		pause_menu.show()
		Engine.time_scale = 0
		
	paused = !paused
	
## Setez hp-ul
func set_hp():
	set_hp_label()
	$HealthBar.max_value = MAX_HP
	set_hp_bar()
	
	
func name():
	return "Player"
	
## Setez label-ul la hp (e cam mare, ma mai gandesc daca sa il folosesc sau nu)
func set_hp_label():
	$HealthLabel.text =  "A"
	
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
	_animated_sprite.play("Idle")
	#pause_menu.hide()
	if paused == false:
		if Input.is_action_just_pressed("shoot") and $BulletTimer.get_time_left() == 0:
			shoot()
			$BulletTimer.start()
		$Node2D.look_at(get_global_mouse_position())
	
	if Input.is_action_just_pressed("pause"):
		pauseMenu()


func kill():
	score += 1

func shoot():
	var bullet = bulletPath.instantiate()
	get_parent().add_child(bullet)
	bullet.position = $Node2D/Marker2D.global_position
	bullet.velocity = get_global_mouse_position() - bullet.position






var max_speed : int = 3
var acceleration : int = 500

func _physics_process(_delta):
	
	##if is_on_floor()
	
	if paused == false:
		if Input.is_action_pressed("move_right"):
			position.x += max_speed 
			$AnimatedSprite2D.flip_h = false
		if Input.is_action_pressed("move_left"):
			position.x -= max_speed
			$AnimatedSprite2D.flip_h = true
		if Input.is_action_pressed("move_down"):
			position.y += max_speed
			$AnimatedSprite2D.flip_h = false 
		if Input.is_action_pressed("move_up"):
			position.y -= max_speed
			$AnimatedSprite2D.flip_h = false
		else:
			position.x += 0
		
		position.x += 0
		move_and_slide()
	
	

extends CharacterBody2D
const BULLET_PATH = preload('res://Bullet.tscn')

const MAX_HP = 5

var score = 0
var coins = 0

var hp = MAX_HP

var paused = true;

var max_speed : int = 3
var acceleration : int = 500

var _animated_sprite = 1

@onready var pause_menu = $PauseMenu

## Presetez grafica caracterului, meniul de pauza, hp, label-ul cu scorul
func _ready():
	_animated_sprite = $AnimatedSprite2D
	pause_menu = $PauseMenu
	set_hp()
	toggle_pause_menu()
	set_score_label()
## Cand ajungi la 0 hp, te despawnezi (inchidem si jocul in acelasi timp)
func unalive():
	Persistence.delete_autosave()
	Persistence.save_score(score)
	get_tree().quit()
## Functie pentru pauza
func toggle_pause_menu():
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1

	else:
		pause_menu.show()
		Engine.time_scale = 0

	paused = !paused

## Setez hp-ul
func set_hp():
	##set_hp_label()
	$HealthBar.max_value = MAX_HP
	set_hp_bar()


func name():
	return "Player"

## Setez label-ul la hp (e cam mare, ma mai gandesc daca sa il folosesc sau nu)
func set_hp_label():
	##$HealthLabel.text =  "A"
	pass

## Setez bara de hp(se updateaza hp ul actual)
func set_hp_bar():
	$HealthBar.value = hp
## Setez label-ul de scor + coins.
func set_score_label():

	$ScoreLabel.text = "Score: " + str(score) + "\n" + "Coins: " + str(coins)

func damaged():
	hp -= 1
	set_hp_bar()
	if hp == 0:
		unalive()
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
		toggle_pause_menu()


func kill():
	score += 1
	print("Killed")
	set_score_label()
func coin():
	coins += 1
	set_score_label()

func shoot():
	var bullet = BULLET_PATH.instantiate()
	get_parent().add_child(bullet)
	bullet.position = $Node2D/Marker2D.global_position
	bullet.velocity = get_global_mouse_position() - bullet.position

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
			position.y += 0

		position.x += 0
		move_and_slide()


func get_save_data():
	return {
		"score": score,
		"coins": coins,
		"hp": hp,
		"x": position.x,
		"y": position.y,
	}

func load_save_data(data):
	score = data["score"]
	coins = data["coins"]
	hp = data["hp"]
	position.x = data["x"]
	position.y = data["y"]
	set_hp_bar()
	set_score_label()

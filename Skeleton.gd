extends CharacterBody2D

const MAX_HEALTH : float = 15.0
const SPEED = 50

@export var player : Node
var chase = false
var health : float = MAX_HEALTH
var damage_target = null

func _ready():
	player = get_node("../../Player")
	get_node("AnimatedSprite2D").play("Idle")
	# adjust timer settings
	$DamageTimer.wait_time = 0.5
	$DamageTimer.one_shot = false

func _physics_process(_delta):
	# direction to player
	var direction = global_position.direction_to(player.global_position)
	if chase == true:
		velocity = direction * SPEED
	else:
		velocity = direction * 0
	# turning the direction of sprite based on player position
	if velocity.x < 0:
		get_node("AnimatedSprite2D").flip_h = true
	elif velocity.x > 0:
		get_node("AnimatedSprite2D").flip_h = false

	move_and_slide()

# if player in chase range
func _on_player_detection_body_entered(body):
	if body.has_method("name"):
		if body.name() == "Player":
			chase = true


# if player exits chase range
func _on_player_detection_body_exited(body):
	if body.has_method("name"):
		if body.name() == "Player":
			chase = false

# take damage function
func take_damage(amount):
	health -= amount
	$HealthBar.update_health_bar()
	if health <= 0:
		player.kill()
		queue_free()

# if collides with player
func _on_damage_detection_body_entered(body):
	if body.has_method("name"):
		if body.name() == "Player":
			damage_target = body
			$DamageTimer.start()

# if stops colliding with player
func _on_damage_detection_body_exited(body):
	if body == damage_target:
		damage_target = null
		$DamageTimer.stop()


# take damage once per timer
func _on_damage_timer_timeout():
	if damage_target != null:
		damage_target.damaged()

func get_save_data():
	return {
		"health": health,
		"x": position.x,
		"y": position.y
		# player and chase will be recalculated on save load
	}

func load_save_data(data):
	health = data["health"]
	position.x = data["x"]
	position.y = data["y"]
	call_deferred("update_health_bar", $HealthBar)

extends CharacterBody2D

const BULLET_PATH = preload('res://Bullet.tscn')
const OFFSET = Vector2(15, 0)
const MAX_HEALTH : float = 25.0
const BULLET_SPEED = 200.0

var player
var health : float = MAX_HEALTH
var shooting = false
var shoot_timer = 0
var shoot_interval = 1.5

func _ready():
	player = get_node("../../Player")
	get_node("AnimatedSprite2D").play("Idle")

func _physics_process(delta):
	shoot_timer += delta
	# get direction and compute the angle to player and rotation degrees for shooting direction
	var direction = player.global_position
	var angle_to_player = atan2(direction.y - global_position.y, direction.x - global_position.x)
	var rotation_degrees = rad_to_deg(angle_to_player)

	# Flip sprite based on player's position
	if direction.x - global_position.x < 0:
		get_node("AnimatedSprite2D").flip_h = true
	elif direction.x - global_position.x > 0:
		get_node("AnimatedSprite2D").flip_h = false

	if shooting and shoot_timer >= shoot_interval:
		shoot(angle_to_player)
		shoot_timer = 0

func shoot(angle_to_player):
	var bullet = BULLET_PATH.instantiate()
	var rotated_offset = OFFSET.rotated(angle_to_player)  # Rotate using radians
	bullet.position = position + rotated_offset  # Adjust bullet position using position instead of global_position
	print(bullet.position)
	bullet.rotation = angle_to_player  # Ensure the bullet faces the correct direction
	bullet.velocity = Vector2(cos(angle_to_player), sin(angle_to_player)) * BULLET_SPEED  # Calculate velocity based on angle
	bullet.sender = "Skull"
	get_parent().add_child(bullet)

# if in shooting range
func _on_player_detection_body_entered(body):
	if body.has_method("name"):
		if body.name() == "Player":
			shooting = true

# when player exits the shooting range
func _on_player_detection_body_exited(body):
	if body.has_method("name"):
		if body.name() == "Player":
			shooting = false

func take_damage(amount):
	health -= amount
	$HealthBar.update_health_bar()
	if health <= 0:
		player.kill()
		queue_free()

func get_save_data():
	return {
		"health": health,
		"timer": shoot_timer,
		"interval": shoot_interval,
		"x": position.x,
		"y": position.y,
		# no need for player or shooting, will be recalculated
	}

func load_save_data(data):
	health = data["health"]
	shoot_timer = data["timer"]
	shoot_interval = data["interval"]
	position.x = data["x"]
	position.y = data["y"]
	call_deferred("update_health_bar", $HealthBar)

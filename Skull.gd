extends CharacterBody2D


const bulletPath = preload('res://Bullet.tscn')
var player
const MAX_HEALTH : float = 25.0
var health : float = MAX_HEALTH
var shooting = false
const OFFSET = Vector2(15, 0)
var shoot_timer = 0
var shoot_interval = 1.5


func _ready():
	player = get_node("../../Player")
	get_node("AnimatedSprite2D").play("Idle")


func _physics_process(delta):
	shoot_timer += delta
	var direction = player.global_position
	var angle_to_player = atan2(direction.y - global_position.y, direction.x - global_position.x)
	var rotation_degrees = rad_to_deg(angle_to_player)
	if direction.x - global_position.x < 0:
		get_node("AnimatedSprite2D").flip_h = true
	elif direction.x - global_position.x > 0:
		get_node("AnimatedSprite2D").flip_h = false
	if shooting and shoot_timer >= shoot_interval:
		shoot(direction, rotation_degrees)
		shoot_timer = 0


func shoot(direction, rotation_degrees):
	var bullet = bulletPath.instantiate()
	get_parent().add_child(bullet)
	var rotated_offset = OFFSET
	bullet.position = global_position + rotated_offset.rotated(rotation_degrees)
	bullet.velocity = direction - bullet.position


func _on_player_detection_body_entered(body):
	if body.has_method("name"):
		if body.name() == "Player":
			shooting = true


func _on_player_detection_body_exited(body):
	if body.has_method("name"):
		if body.name() == "Player":
			shooting = false

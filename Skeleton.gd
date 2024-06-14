extends CharacterBody2D


@export var player : Node
var chase = false
const MAX_HEALTH : float = 15.0
var health : float = MAX_HEALTH
const SPEED = 50
var damage_target = null

func _ready():
	player = get_node("../../Player")
	get_node("AnimatedSprite2D").play("Idle")
	$DamageTimer.wait_time = 0.5
	$DamageTimer.one_shot = false

func _physics_process(_delta):
	var direction = global_position.direction_to(player.global_position)
	if chase == true:
		velocity = direction * SPEED
	else:
		velocity = direction * 0
	if velocity.x < 0:
		get_node("AnimatedSprite2D").flip_h = true
	elif velocity.x > 0:
		get_node("AnimatedSprite2D").flip_h = false
	
	move_and_slide()

func _on_player_detection_body_entered(body):
	if body.has_method("name"):
		if body.name() == "Player":
			chase = true
	


func _on_player_detection_body_exited(body):
	if body.has_method("name"):
		if body.name() == "Player":
			chase = false


func take_damage(amount):
	health -= amount
	$HealthBar.update_health_bar()
	if health <= 0:
		player.kill()
		queue_free()


func _on_damage_detection_body_entered(body):
	if body.has_method("name"):
		if body.name() == "Player":
			damage_target = body
			$DamageTimer.start()


func _on_damage_detection_body_exited(body):
	if body == damage_target:
		damage_target = null
		$DamageTimer.stop()



func _on_damage_timer_timeout():
	if damage_target != null:
		damage_target.damaged()

extends CharacterBody2D


var player
var chase = false
var health = 10
const SPEED = 50

func _physics_process(delta):
	player = get_node("/root/MyTest/Player")
	get_node("AnimatedSprite2D").play("Idle")
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
	if health <= 0:
		queue_free()

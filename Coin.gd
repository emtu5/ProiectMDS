extends Node2D


func _ready():
	get_node("AnimatedSprite2D").play("Idle")

func _on_collect_area_body_entered(body):
	if body.has_method("name"):
		if body.name() == "Player":
			body.coin()
			queue_free()

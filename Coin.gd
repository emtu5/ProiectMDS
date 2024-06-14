extends Node2D


func _ready():
	get_node("AnimatedSprite2D").play("Idle")

# if collected by player
func _on_collect_area_body_entered(body):
	if body.has_method("name"):
		if body.name() == "Player":
			body.coin()
			queue_free()

func get_save_data():
	# coins don't move around, no position to save, just a marker so the Persistence scripts knows to delete collected coins
	return {}

func load_save_data(_data):
	pass

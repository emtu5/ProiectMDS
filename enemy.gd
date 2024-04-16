extends Area2D

# Functie in momentul in care intra ceva in range ul inamicilor. Partea cu luat dmg e on going.
func _on_body_entered(body):
	if body.name() == "Player":
		print("Took dmg")
	elif body.name() == "Bullet":
		queue_free()
		body.bye()

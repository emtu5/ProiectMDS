extends CharacterBody2D

var speed = 200
const DAMAGE = 5
# Functie pentru a ma folosi de ea in enemy ca sa iau numele( e doar peticeala, trebuie sa gasesc o metoda umana data viitoare)
func name():
	return "Bullet"
# Functie pentru a face glontul sa dispara
func bye():
	queue_free()

# Functie pentru a seta traictoria gloantelor
func _physics_process(delta):
	var collision_info = move_and_collide(velocity.normalized() * delta * speed)


func _on_damage_area_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(DAMAGE)
		bye()

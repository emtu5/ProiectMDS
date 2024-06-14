extends CharacterBody2D

const DAMAGE = 5

var speed = 200
var sender
# Functie pentru a ma folosi de ea in enemy ca sa iau numele( e doar peticeala, trebuie sa gasesc o metoda umana data viitoare)
func name():
	return "Bullet"
# Functie pentru a face glontul sa dispara
func bye():
	queue_free()

func _ready():
	print(sender)

# Functie pentru a seta traictoria gloantelor
func _physics_process(delta):
	move_and_collide(velocity.normalized() * delta * speed)


func _on_damage_area_body_entered(body):
	if sender != "Skull":
		if body.has_method("take_damage"):
			body.take_damage(DAMAGE)
			bye()
	else:
		if body.has_method("name"):
			if body.name() == "Player":
				body.damaged()
				bye()
	bye()

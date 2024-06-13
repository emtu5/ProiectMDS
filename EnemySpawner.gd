extends Node2D

var skeleton_scene = preload("res://Skeleton.tscn")
var skull_scene = preload("res://Skull.tscn")
var spawn = true
const MAX_ENEMIES = 10
var enemies = [] # Array to keep track of spawned enemies

var spawn_area
var restricted_area

func _ready():
	$Timer.start()
	spawn_area = $SpawnArea/Spawn
	restricted_area = $RestrictedArea/NoSpawn

func _on_timer_timeout():
	if enemies.size() < MAX_ENEMIES:
		var spawn_position = get_valid_spawn_position()
		if spawn_position != null:
			# Randomly choose between spawning a skeleton or a skull
			var enemy
			enemy = skull_scene.instantiate()
			#if randi() % 2 == 0:
				#enemy = skeleton_scene.instantiate()
			#else:
				#enemy = skull_scene.instantiate()
			enemy.position = spawn_position
			print("from spawn point")
			print(enemy.position)
			add_child(enemy)
			enemies.append(enemy)
			enemy.connect("tree_exited", Callable(self, "_on_enemy_tree_exited"))

func get_valid_spawn_position():
	for i in range(100): # Try up to 100 times to find a valid position
		var x = randi() % int(spawn_area.shape.extents.x * 2) - spawn_area.shape.extents.x + spawn_area.position.x
		var y = randi() % int(spawn_area.shape.extents.y * 2) - spawn_area.shape.extents.y + spawn_area.position.y
		var potential_position = Vector2(x, y)
		if !is_in_restricted_area(potential_position):
			return potential_position
	return null # Return null if no valid position is found after 100 attempts

func is_in_restricted_area(pos):
	var restricted_rect = restricted_area.shape.extents * 2
	var restricted_position_offset = restricted_area.global_position - restricted_area.shape.extents
	var restricted_rect_global = Rect2(restricted_position_offset, restricted_rect)
	return restricted_rect_global.has_point(pos)

func _on_enemy_tree_exited():
	# Remove enemy from the array when it exits the tree
	for enemy in enemies:
		if not enemy.is_inside_tree():
			enemies.erase(enemy)
			break

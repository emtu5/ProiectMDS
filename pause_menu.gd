extends Control
@onready var player = $"../"

func _on_resume_pressed():
	player.pauseMenu()
	print("pressed")
	
	
func _on_quit_pressed():
	get_tree().quit()
	pass

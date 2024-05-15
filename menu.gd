extends BoxContainer

@export var _startScene : PackedScene;
@export var _start : Button;
@export var _settings : Button;
@export var _exit : Button;

func _ready():
	_start.pressed.connect(_start_button)
	_settings.pressed.connect(_settings_button)
	_exit.pressed.connect(_exit_button)

func _process(delta):
	pass

func _start_button():
	get_tree().root.add_child(_startScene.instantiate())
	queue_free()

func _settings_button():
	OS.alert("Settings not implemented yet!", "Not Implemented")

func _exit_button():
	get_tree().quit()

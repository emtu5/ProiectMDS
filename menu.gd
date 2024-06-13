extends BoxContainer

@export var _startScene : PackedScene;
@export var _start : Button;
@export var _settings : Button;
@export var _closeSettings : Button;
@export var _exit : Button;
@export var _mainMenu : Node;
@export var _settingsMenu : Node;
@export var _volumeSlider : Slider;

var _prev_scale_factor : float

func _ready():
	_prev_scale_factor = get_tree().root.content_scale_factor
	get_tree().root.content_scale_factor = 1
	_start.pressed.connect(_start_button)
	_settings.pressed.connect(_settings_button)
	_closeSettings.pressed.connect(_close_settings_button);
	_exit.pressed.connect(_exit_button)
	_volumeSlider.drag_ended.connect(_volume_drag_ended)

func _process(delta):
	pass

func _start_button():
	get_tree().root.content_scale_factor = _prev_scale_factor
	get_tree().root.add_child(_startScene.instantiate())
	queue_free()

func _settings_button():
	_mainMenu.hide()
	_settingsMenu.show()

func _close_settings_button():
	_mainMenu.show();
	_settingsMenu.hide();

func _volume_drag_ended(value_changed: bool):
	if not value_changed:
		return
	# TODO: slider is from 0 to 100, is this the right scale? maybe it should be 0 to 1 or something
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), _volumeSlider.value)
	# TODO: instead of printing to console, play a test sound, like when setting the volume in Windows
	print("set volume to %f" % _volumeSlider.value)

func _exit_button():
	get_tree().quit()

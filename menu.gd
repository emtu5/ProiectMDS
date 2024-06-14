extends Node

@export var _startScene : PackedScene;
@export var _loadSave : Button;
@export var _start : Button;
@export var _settings : Button;
@export var _closeSettings : Button;
@export var _exit : Button;
@export var _mainMenu : Node;
@export var _settingsMenu : Node;
@export var _volumeSlider : Slider;
@export var _leaderboardLabel : RichTextLabel;

var _prev_scale_factor : float

func _ready():
	_prev_scale_factor = get_tree().root.content_scale_factor
	get_tree().root.content_scale_factor = 1
	_loadSave.pressed.connect(_load_save_button)
	_loadSave.disabled = not Persistence.can_load_autosave()
	_start.pressed.connect(_start_button)
	_settings.pressed.connect(_settings_button)
	_closeSettings.pressed.connect(_close_settings_button);
	_format_leaderboard()
	_exit.pressed.connect(_exit_button)
	_volumeSlider.drag_ended.connect(_volume_drag_ended)

func _process(delta):
	pass

func _load_save_button():
	get_tree().root.content_scale_factor = _prev_scale_factor
	Persistence.load_autosave()
	queue_free()

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

func _format_leaderboard():
	var scores = Persistence.score_load()
	var text = "[center]Leaderboard:\n"
	for i in range(0, 3):
		text += str(i + 1) + ". "
		if i < len(scores):
			var time_str = Time.get_datetime_string_from_unix_time(scores[i].time, true)
			text += str(scores[i].score) + " points, at " + time_str + "\n"
		else:
			text += "N/A\n"
	text += "[/center]"
	_leaderboardLabel.bbcode_text = text

func _exit_button():
	get_tree().quit()

extends Node

@export var start_scene : PackedScene;
@export var load_save : Button;
@export var start : Button;
@export var settings : Button;
@export var close_settings : Button;
@export var exit : Button;
@export var main_menu : Node;
@export var settings_menu : Node;
@export var volume_slider : Slider;
@export var leaderboard_label : RichTextLabel;
@export var delete_data : Button;

var _init_delete_label : String
var _confirming_delete : bool = false

var _prev_scale_factor : float

func _ready():
	_prev_scale_factor = get_tree().root.content_scale_factor
	get_tree().root.content_scale_factor = 1
	load_save.pressed.connect(_load_save_button)
	load_save.disabled = not Persistence.can_load_autosave()
	start.pressed.connect(_start_button)
	settings.pressed.connect(_settings_button)
	close_settings.pressed.connect(_close_settings_button);
	_format_leaderboard()
	exit.pressed.connect(_exit_button)
	volume_slider.drag_ended.connect(_volume_drag_ended)
	delete_data.pressed.connect(_delete_all_data)

func _process(_delta):
	pass

func _load_save_button():
	get_tree().root.content_scale_factor = _prev_scale_factor
	Persistence.load_autosave()
	queue_free()

func _start_button():
	get_tree().root.content_scale_factor = _prev_scale_factor
	get_tree().root.add_child(start_scene.instantiate())
	queue_free()

func _settings_button():
	main_menu.hide()
	settings_menu.show()

func _close_settings_button():
	main_menu.show();
	settings_menu.hide();

func _volume_drag_ended(value_changed: bool):
	if not value_changed:
		return
	# TODO: slider is from 0 to 100, is this the right scale? maybe it should be 0 to 1 or something
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), volume_slider.value)
	# TODO: instead of printing to console, play a test sound, like when setting the volume in Windows
	print("set volume to %f" % volume_slider.value)

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
	leaderboard_label.bbcode_text = text

func _delete_all_data():
	if not _confirming_delete:
		_init_delete_label = delete_data.text
		delete_data.text = "Are you sure? Save data and leaderboard will be lost."
		_confirming_delete = true
	else:
		Persistence.delete_autosave()
		Persistence.delete_scores()
		delete_data.text = _init_delete_label
		_format_leaderboard()
		_confirming_delete = false

func _exit_button():
	get_tree().quit()

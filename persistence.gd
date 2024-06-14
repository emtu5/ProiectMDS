extends Node

var _scene_to_autosave: Node = null
var _scene_save_nodes: Array[Node] = []
var _time_since_autosave: float = 0.0
const AUTOSAVE_INTERVAL_MSEC: float = 1000.0
const SAVE_GROUP: String = "Save"

var _save_location: String = "user://"
const SAVE_FILE: String = "autosave.json"
const SCORES_FILE: String = "scores.json"

func _process(delta):
	_time_since_autosave += delta * 1000.0
	if _time_since_autosave < AUTOSAVE_INTERVAL_MSEC:
		return
	_time_since_autosave = 0.0

	if is_instance_valid(_scene_to_autosave) == false:
		print("Scene to autosave was unloaded")
		_scene_to_autosave = null
		_scene_save_nodes = []

	if _scene_to_autosave == null:
		print("No scene to autosave")
		return

	autosave_now()

func _notification(what: int):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		autosave_now()

func autosave_now():
	var nodes_json = {}
	for node in _scene_save_nodes:
		if not is_instance_valid(node):
			continue
		nodes_json[str(node.get_path())] = node.get_save_data()
	var save_data = {
		"scene": _scene_to_autosave.scene_file_path,
		"nodes": nodes_json
	}
	var save_file = FileAccess.open(_save_location + SAVE_FILE, FileAccess.WRITE)
	save_file.store_string(JSON.stringify(save_data))
	save_file.close()

func can_load_autosave() -> bool:
	return FileAccess.file_exists(_save_location + SAVE_FILE)

func load_autosave() -> int:
	var save_file = FileAccess.open(_save_location + SAVE_FILE, FileAccess.READ)
	var save_txt = save_file.get_as_text()
	save_file.close()
	var json = JSON.new()
	var json_err = json.parse(save_txt)
	if json_err != OK:
		print("Failed to parse autosave file: " + str(json_err))
		return json_err
	var save_data = json.data
	var scene = load(save_data["scene"]).instantiate()
	get_tree().root.add_child(scene)
	var nodes_json = save_data["nodes"]
	# objects in Save group are prompted to reload their save data
	for node in scene.get_tree().get_nodes_in_group(SAVE_GROUP):
		var node_path = str(node.get_path())
		if nodes_json.has(node_path):
			node.load_save_data(nodes_json[node_path])
		else:
			node.queue_free()
	return OK

func register_scene_to_autosave(scene: Node):
	_scene_to_autosave = scene
	if _scene_to_autosave == null:
		return
	for node in _scene_to_autosave.get_tree().get_nodes_in_group(SAVE_GROUP):
		# only nodes that exist at this time will be saved
		# newly spawned skeletons must be saved by the spawner node
		_scene_save_nodes.append(node)

# for testing the autosave system
func override_save_location(location: String):
	_save_location = location

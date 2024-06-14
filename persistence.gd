extends Node

var scene_to_autosave: Node = null
var time_since_autosave: float = 0.0
const AUTOSAVE_INTERVAL_MSEC: float = 1000.0

func _process(delta):
    time_since_autosave += delta * 1000.0
    if time_since_autosave < AUTOSAVE_INTERVAL_MSEC:
        return
    time_since_autosave = 0.0

    if is_instance_valid(scene_to_autosave) == false:
        print("Scene to autosave was unloaded")
        scene_to_autosave = null

    if scene_to_autosave == null:
        print("No scene to autosave")
        return

    print("Autosaving...")

func register_scene_to_autosave(scene: Node):
    scene_to_autosave = scene

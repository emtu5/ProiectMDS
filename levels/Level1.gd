extends Node2D

var game_over_next_scene = "res://menu.tscn"

@onready var minimap = $Minimap
@onready var tilemap = $TileMap
@onready var player = $Player

# Called when the node enters the scene tree for the first time.
func _ready():
	Persistence.register_scene_to_autosave(self)
	minimap.add_tilemap(tilemap)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	minimap.update_camera(player.position)

extends Node2D

var game_over_next_scene = "res://menu.tscn"

var _level_music = preload("res://Art/2019-12-11_-_Retro_Platforming_-_David_Fesliyan.mp3")
var _player

@onready var minimap = $Minimap
@onready var tilemap = $TileMap
@onready var player = $Player

# Called when the node enters the scene tree for the first time.
func _ready():
	Persistence.register_scene_to_autosave(self)
	minimap.add_tilemap(tilemap)
	_player = AudioStreamPlayer.new()
	_player.stream = _level_music
	add_child(_player)
	_player.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	minimap.update_camera(player.position)

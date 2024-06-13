extends Control

@onready var subviewport = $CanvasLayer/ColorRect/SubViewportContainer/SubViewport

func add_tilemap(tilemap):
	subviewport.add_child(tilemap.duplicate())

func update_camera(position):
	subviewport.get_node("Camera2D").position = position
	

extends Node

@onready var houselet_scene = load("res://houselet.tscn")

var block_textures = []
func block_texture():
	return block_textures[next_block.texture_i]
	return block_textures[randi() % block_textures.size()]
#var block_texture = preload("res://assets/Buildings/Buildings3.png")

var houselet_shapes = [
	[Vector2(0,0), Vector2(1,0), Vector2(2,0), Vector2(1,1)],
	[Vector2(0,0), Vector2(1,0), Vector2(1,1), Vector2(2,1)],
	[Vector2(0,0), Vector2(0,1), Vector2(1,1), Vector2(2,1), Vector2(2,0)],
]
var houselet_pivots = []

var next_block = {
	"rotation": 0,
	"x": 0,
	"y": 0,
	"shape_i": 0,
	"texture_i": 0
}
var tile_size = 32

var screen_dimensions

func _ready():
	for i in range(1, 6):
		block_textures.append(load("res://assets/Buildings/Buildings"+str(i)+".png"))
	
	for houselet in houselet_shapes:
		var avg = Vector2.ZERO
		for pos in houselet:
			avg += pos
		avg /= houselet.size()
		houselet_pivots.append(avg)
	
	var camera = get_viewport().get_camera_2d()
	var screen_size = get_viewport().get_size()
	screen_dimensions = Vector2(screen_size) / camera.zoom

extends Node

@onready var houselet_scene = load("res://houselet.tscn")
@onready var text_scene = load("res://Text.tscn")

var mouse_on_button = false

var ghost_block_textures = []
var placed_block_textures = []
func ghost_block_texture():
	return ghost_block_textures[next_block.texture_i]

func placed_block_texture():
	return placed_block_textures[next_block.texture_i]
#var block_texture = preload("res://assets/Buildings/Buildings3.png")

var houselet_shapes = [
	[Vector2(0, 0), Vector2(1, 0), Vector2(2, 0), Vector2(1, 1)], # T
	[Vector2(0, 0), Vector2(1, 0), Vector2(1, 1), Vector2(2, 1)], # Z
	[Vector2(0, 0), Vector2(0, 1), Vector2(1, 1), Vector2(2, 1), Vector2(2, 0)], # U
	[Vector2(0, 0), Vector2(1, 0), Vector2(2, 0), Vector2(3, 0)], # I
	[Vector2(0, 0), Vector2(1, 0), Vector2(1, -1), Vector2(2, -1)], # S
	[Vector2(0, 0), Vector2(1, 0), Vector2(2, 0), Vector2(2, 1)], # L
	[Vector2(0, 0), Vector2(1, 0), Vector2(2, 0), Vector2(2, -1)], # upside down L
]
var houselet_pivots = []

var can_drop = true
var next_block = {
	"rotation": 0,
	"x": 0,
	"y": 0,
	"shape_i": 0,
	"texture_i": 0
}
var tile_size = 32

var screen_dimensions

var music_play = false

var game_over = false
var win_game = false

var drop_height

func reload():
	ghost_block_textures = []
	placed_block_textures = []
	houselet_shapes = [
	[Vector2(0, 0), Vector2(1, 0), Vector2(2, 0), Vector2(1, 1)], # T
	[Vector2(0, 0), Vector2(1, 0), Vector2(1, 1), Vector2(2, 1)], # Z
	[Vector2(0, 0), Vector2(0, 1), Vector2(1, 1), Vector2(2, 1), Vector2(2, 0)], # U
	[Vector2(0, 0), Vector2(1, 0), Vector2(2, 0), Vector2(3, 0)], # I
	[Vector2(0, 0), Vector2(1, 0), Vector2(1, -1), Vector2(2, -1)], # S
	[Vector2(0, 0), Vector2(1, 0), Vector2(2, 0), Vector2(2, 1)], # L
	[Vector2(0, 0), Vector2(1, 0), Vector2(2, 0), Vector2(2, -1)], # upside down L
	]
	houselet_pivots = []
	can_drop = true
	next_block = {
	"rotation": 0,
	"x": 0,
	"y": 0,
	"shape_i": 0,
	"texture_i": 0
}
	tile_size = 32
	screen_dimensions
	music_play = false
	game_over = false
	win_game = false
	drop_height
	get_tree().paused = false
	
	for i in range(1, 7):
		ghost_block_textures.append(load("res://assets/Buildings/Dotted Buildings"+str(i)+".png"))
		placed_block_textures.append(load("res://assets/Buildings/Buildings"+str(i)+".png"))
	
	for houselet in houselet_shapes:
		var avg = Vector2.ZERO
		for pos in houselet:
			avg += pos
		avg /= houselet.size()
		houselet_pivots.append(avg)
	
	var camera = get_viewport().get_camera_2d()
	var screen_size = get_viewport().get_size()
	screen_dimensions = Vector2(screen_size) / camera.zoom
	
	drop_height = tile_size*3

func _ready():
	for i in range(1, 6):
		ghost_block_textures.append(load("res://assets/Buildings/Dotted Buildings"+str(i)+".png"))
		placed_block_textures.append(load("res://assets/Buildings/Buildings"+str(i)+".png"))
	
	for houselet in houselet_shapes:
		var avg = Vector2.ZERO
		for pos in houselet:
			avg += pos
		avg /= houselet.size()
		houselet_pivots.append(avg)
	
	var camera = get_viewport().get_camera_2d()
	var screen_size = get_viewport().get_size()
	screen_dimensions = Vector2(screen_size) / camera.zoom
	
	drop_height = tile_size*3

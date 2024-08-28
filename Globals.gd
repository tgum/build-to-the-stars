extends Node

@onready var houselet_scene = load("res://houselet.tscn")

var block_texture = preload("res://assets/Buildings/Buildings3.png")

var houselet_shapes = [
	[Vector2(0,0), Vector2(1,0), Vector2(2,0), Vector2(1,1)],
	[Vector2(0,0), Vector2(1,0), Vector2(1,1), Vector2(2,1)],
	[Vector2(0,0), Vector2(0,1), Vector2(1,1), Vector2(2,1), Vector2(2,0)],
]
var houselet_pivots = []

var tile_size = 32
var rotation = 0
var block_x = 0
var block_index = 0

func _ready():
	for houselet in houselet_shapes:
		var avg = Vector2.ZERO
		for pos in houselet:
			avg += pos
		avg /= houselet.size()
		houselet_pivots.append(avg)

extends Node2D

@onready var line = $Line2D
@onready var raycast = $RayCast2D
@onready var block_container = $Blocks

# Called when the node enters the scene tree for the first time.
func _ready():
	make_display()

func clear_children():
	for i in block_container.get_children():
		block_container.remove_child(i)
		i.queue_free()

func make_display():
	clear_children()
	var shape = Globals.houselet_shapes[Globals.block_index]
	var center = Globals.houselet_pivots[Globals.block_index]
	for pos in shape:
		var image = Sprite2D.new()
		image.texture = Globals.block_texture
		block_container.add_child(image)
		image.position = (pos-center) * Globals.tile_size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation = Globals.rotation
	position.x = Globals.block_x
	position.y = -100
	
	raycast.rotation = -rotation
	line.rotation = -rotation
	if raycast.is_colliding():
		var point = raycast.get_collision_point()
		line.set_point_position(1, Vector2(0, point.y - position.y))

extends RigidBody2D

func init(blocks, x, y, angle):
	#
	mass = randi() % 100
	#if randi() % 2 == 0:
	#	gravity_scale = 0.1
	
	rotation = angle
	position = Vector2(x, y)
	
	var center = Globals.houselet_pivots[Globals.next_block.shape_i]
	for block in blocks:
		var collision = CollisionShape2D.new()
		add_child(collision)
		
		collision.shape = RectangleShape2D.new()
		collision.shape.size = Vector2(Globals.tile_size, Globals.tile_size)
		collision.position = (block - center) * Globals.tile_size
		
		var image = Sprite2D.new()
		image.texture = Globals.placed_block_texture()
		collision.add_child(image)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

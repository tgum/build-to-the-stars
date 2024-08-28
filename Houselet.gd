extends Node2D

var bodies = []
var joints = []

func _ready():
	pass

func init(blocks, x, y, angle):
	var body = RigidBody2D.new()
	bodies.append(body)
	body.rotation = angle
	body.position = Vector2(x, y)
	add_child(body)
	for block in blocks:
		var collision = CollisionShape2D.new()
		body.add_child(collision)
		
		var image = Sprite2D.new()
		image.texture = Globals.block_texture
		collision.add_child(image)
		
		var center = Globals.houselet_pivots[Globals.block_index]
		
		collision.shape = RectangleShape2D.new()
		collision.shape.size = Vector2(Globals.tile_size, Globals.tile_size)
		collision.position = (block - center) * Globals.tile_size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

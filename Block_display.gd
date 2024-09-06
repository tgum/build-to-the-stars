extends Node2D

# I drew dotted versions of everything


#variables which are important
@onready var line = $Line2D
@onready var raycast = $RayCast2D
@onready var block_container = $Blocks
@onready var sprite = $Magnet

# Called when the node enters the scene tree for the first time.
func _ready():
	make_display()

#Read the title, Idiot
func clear_children():
	for i in block_container.get_children():
		block_container.remove_child(i)
		i.queue_free()

#Same here
func make_display():
	clear_children()
	var shape = Globals.houselet_shapes[Globals.next_block.shape_i]
	var center = Globals.houselet_pivots[Globals.next_block.shape_i]
	for pos in shape:
		var image = Sprite2D.new()
		image.texture = Globals.ghost_block_texture()
		#image.use_parent_material = true # should the shader be applied to the blocks?
		block_container.add_child(image)
		image.position = (pos-center) * Globals.tile_size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#make_display()
	
	block_container.rotation = Globals.next_block.rotation
	position.x = Globals.next_block.x
	if Globals.can_drop:
		position.y = lerpf(position.y, float(Globals.next_block.y), 0.2)
		block_container.visible = true
		line.visible = true
		block_container.rotation = Globals.next_block.rotation

		if raycast.is_colliding():
			var point = raycast.get_collision_point()
			line.set_point_position(1, Vector2(0, point.y - position.y))
	else:
		line.set_point_position(0, Vector2.ZERO)
		block_container.visible = false
		line.visible = false

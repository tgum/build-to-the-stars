extends Node2D

@export var noise_texure : NoiseTexture2D
var shader = preload("res://wave-shader.gdshader")
var numb = 0

@onready var line = $Line2D
@onready var raycast = $RayCast2D
@onready var block_container = $Blocks
@onready var sprite = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	make_display()

func clear_children():
	for i in block_container.get_children():
		block_container.remove_child(i)
		i.queue_free()

func make_display():
	clear_children()
	var shape = Globals.houselet_shapes[Globals.next_block.shape_i]
	var center = Globals.houselet_pivots[Globals.next_block.shape_i]
	for pos in shape:
		var image = Sprite2D.new()
		image.texture = Globals.block_texture()
		block_container.add_child(image)
		image.material = ShaderMaterial.new()
		image.material.set("shader", shader)
		image.material.set_shader_parameter("dissolve_form", noise_texure)
		image.material.set_shader_parameter("dissolve_state", 0.5)
		if image.material.get_shader_parameter("dissolve_form/Noise_Texture2D/FastNoiseLite/offset") != null:
			print(image.material.get_shader_parameter("dissolve_form/Noise_Texture2D/FastNoiseLite/offset"))
		image.position = (pos-center) * Globals.tile_size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	make_display()
	numb = numb + 50
	
	rotation = Globals.next_block.rotation
	position.x = Globals.next_block.x
	if Globals.can_drop:
		block_container.visible = true
		line.visible = true
		block_container.rotation = Globals.next_block.rotation
		position.y = Globals.next_block.y

		if raycast.is_colliding():
			var point = raycast.get_collision_point()
			line.set_point_position(1, Vector2(0, point.y - position.y))
	else:
		line.set_point_position(0, Vector2.ZERO)
		block_container.visible = false
		line.visible = false

extends Node2D

@onready var block_display = $Block_display
@onready var camera = $Camera2D
@onready var spawn_timer = $Spawn_timer

var can_spawn = true
func do_can_spawn():
	can_spawn = true

var houselets = []

func _ready():
	pass

func _input(event):
	if event is InputEventMouseMotion:
		Globals.next_block.x = event.position.x/2 - get_viewport().get_visible_rect().size.x/4
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT and can_spawn:
			new_houselet(Globals.next_block.x, Globals.next_block.y)
			can_spawn = false
			spawn_timer.start()
			Globals.next_block.rotation = 0
			Globals.next_block.shape_i = randi() % Globals.houselet_shapes.size()
			Globals.next_block.texture_i = randi() % Globals.block_textures.size()
			block_display.make_display()
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			Globals.next_block.rotation += 0.1
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			Globals.next_block.rotation -= 0.1

func new_houselet(x=300, y=0):
	var hl = Globals.houselet_scene.instantiate()
	hl.init(Globals.houselet_shapes[Globals.next_block.shape_i], x, y, Globals.next_block.rotation)
	add_child(hl)
	houselets.append(hl)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var highest_block = 0
	for hl in houselets:
		for block in hl.get_children():
			var pos = block.global_position
			if pos.y < highest_block:
				highest_block = pos.y
	Globals.next_block.y = highest_block - 100
	camera.position.y = round(Globals.next_block.y + 100)

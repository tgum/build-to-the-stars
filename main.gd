extends Node2D

@onready var block_display = $Block_display
@onready var camera = $Camera2D
@onready var spawn_timer = $Spawn_timer

var timer_thing = true
func do_can_spawn():
	timer_thing = true

var houselets = []

func _ready():
	camera.limit_bottom = Globals.screen_dimensions.y/2
	#camera.limit_left = -Globals.screen_dimensions.x/2
	#camera.limit_right = Globals.screen_dimensions.x/2

func _input(event):
	if event is InputEventMouseMotion:
		Globals.next_block.x = event.position.x/2 - get_viewport().get_visible_rect().size.x/4
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT and Globals.can_drop:
			new_houselet(Globals.next_block.x, Globals.next_block.y)
			Globals.can_drop = false
			timer_thing = false
			spawn_timer.start()
			Globals.next_block.rotation = 0
			Globals.next_block.shape_i = randi() % Globals.houselet_shapes.size()
			Globals.next_block.texture_i = randi() % Globals.block_textures.size()
			block_display.make_display()
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			Globals.next_block.rotation += PI/16
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			Globals.next_block.rotation -= PI/16

func new_houselet(x=300, y=0):
	var hl = Globals.houselet_scene.instantiate()
	hl.init(Globals.houselet_shapes[Globals.next_block.shape_i], x, y, Globals.next_block.rotation)
	add_child(hl)
	houselets.append(hl)

func _process(delta):
	check_exit()

	if not Globals.game_over:
		var highest_block = 0
		var block_outside = false
		for hl in houselets:
			for block in hl.get_children():
				var pos = block.global_position
				if pos.y < highest_block:
					highest_block = pos.y
				if pos.x < -Globals.screen_dimensions.x/2 or pos.x > Globals.screen_dimensions.x/2:
					block_outside = true
		if block_outside:
			get_tree().paused = true
			block_display.visible = false
			Globals.game_over = true
		Globals.next_block.y = highest_block - Globals.drop_height
		if Globals.can_drop:
			camera.position.y = round(highest_block)
		
		if houselets.size() > 0 and timer_thing:
			var last_houselet = houselets[houselets.size()-1]
			if last_houselet.linear_velocity.length() < 5:
				Globals.can_drop = true
	else:
		camera.position = Vector2.ZERO
		if camera.zoom.length() > 1:
			camera.zoom = camera.zoom * 0.98
			
func check_exit():
	if Input.is_action_pressed("Escape"):
		get_tree().quit()

extends Node2D

@onready var block_display = $Block_display
@onready var camera = $Camera2D
@onready var spawn_timer = $Spawn_timer
@onready var win_animation = $WinAnimation
@onready var lose_text = $Lose_stuff
@onready var sky = $Background
@onready var heightline = $Height_line
@onready var score_text = $Height_line/Text
@onready var height_markers = $Height_markers
@onready var base_img = $Base

var timer_thing = true
func do_can_spawn():
	timer_thing = true

var houselets = []

var play_area_size
var play_area_origin
var base_img_height

func _ready():
	play_area_size = sky.get_texture().get_size()
	play_area_origin = sky.position - play_area_size/2
	base_img_height = base_img.texture.get_size().y
	
	camera.limit_bottom = sky.position.y + play_area_size.y/2
	
	heightline.points[0].x = -play_area_size.x
	heightline.position.x = play_area_size.x/2
	
	var num_numbers = 10
	for i in range(1, num_numbers):
		var text_label = Globals.text_scene.instantiate()
		add_child(text_label)
		text_label.text = str(i*(1000/num_numbers)) + "m"
		text_label.position.x = play_area_size.x/2 - text_label.size.x
		text_label.position.y = remap(i,
						   0, 10,
						   play_area_origin.y+play_area_size.y-base_img_height, play_area_origin.y)
		text_label.position.y -= text_label.size.y
	get_viewport().connect("size_changed", _on_viewport_resize)

func _on_viewport_resize():
	var screen_size = get_viewport().get_size()
	Globals.screen_dimensions = Vector2(screen_size) / camera.zoom
	#camera.limit_left = -Globals.screen_dimensions.x/2
	#camera.limit_right = Globals.screen_dimensions.x/2

func _input(event):
	if event is InputEventMouseMotion:
		Globals.next_block.x = event.position.x/camera.zoom.x  - Globals.screen_dimensions.x/2
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT and Globals.can_drop:
			new_houselet(Globals.next_block.x, Globals.next_block.y)
			Globals.can_drop = false
			timer_thing = false
			spawn_timer.start()
			Globals.next_block.rotation = 0
			Globals.next_block.shape_i = randi() % Globals.houselet_shapes.size()
			Globals.next_block.texture_i = randi() % Globals.placed_block_textures.size()
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
		var highest_block = (play_area_origin + play_area_size).y
		var block_outside = false
		for hl in houselets:
			for block in hl.get_children():
				var pos = block.global_position
				if pos.y < highest_block:
					highest_block = pos.y
				if abs(pos.x) > play_area_size.x/2:
					block_outside = true
		if highest_block >= -145:
			Globals.win_game = true
		
		if block_outside:
			get_tree().paused = true
			block_display.visible = false
			Globals.game_over = true
			lose_text.visible = true
		Globals.next_block.y = min(highest_block, 0) - Globals.drop_height
		if Globals.can_drop:
			camera.position.y = round(highest_block)
		heightline.position.y = min(highest_block, play_area_origin.y+play_area_size.y-base_img_height)
		var meters = remap(highest_block,
						   play_area_origin.y+play_area_size.y-base_img_height, play_area_origin.y,
						   0, 1000)
		score_text.text = str(round(max(meters, 0))) + "m"
		
		if houselets.size() > 0 and timer_thing:
			var last_houselet = houselets[houselets.size()-1]
			if last_houselet.linear_velocity.length() < 5:
				Globals.can_drop = true
	else:
		camera.position = Vector2.ZERO
		if camera.zoom.x > 1:
			camera.zoom = camera.zoom * 0.99
	
	if Globals.win_game == true:
		#get_tree().paused = true
		win_animation.visible = true
		win_animation.play("default")

func check_exit():
	if Input.is_action_pressed("Escape"):
		get_tree().quit()


func _on_quit_button_up():
	get_tree().quit()


func _on_restart_button_up():
	Globals.reload()

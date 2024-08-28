extends Node2D

@onready var block_display = $Block_display
@onready var spawn_timer = $Spawn_timer
var can_spawn = true
func do_can_spawn():
	can_spawn = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _input(event):
	if event is InputEventMouseMotion:
		Globals.block_x = event.position.x/2 - get_viewport().get_visible_rect().size.x/4
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT and can_spawn:
			new_houselet(Globals.block_x, -100)
			can_spawn = false
			spawn_timer.start()
			Globals.rotation = 0
			Globals.block_index = randi() % Globals.houselet_shapes.size()
			block_display.make_display()
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			Globals.rotation += 0.1
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			Globals.rotation -= 0.1

func new_houselet(x=300, y=0):
	var hl = Globals.houselet_scene.instantiate()
	hl.init(Globals.houselet_shapes[Globals.block_index], x, y, Globals.rotation)
	add_child(hl)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

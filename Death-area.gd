extends Area2D

@onready var camera = get_node("../Camera2D")

var end_position = Vector2(0,0)
var paused = false

func _on_body_entered(body):
	if get_tree().paused != true:
		get_tree().paused = true
		paused = true
	end_position = body.position
	move_camera()

func move_camera():
	monitoring = false
	camera.position.x = lerp(camera.position.x, end_position.x, 1)
	camera.position.y = lerp(camera.position.y, end_position.y, 1)

func _physics_process(delta):
	if paused == true and Input.is_anything_pressed():
		get_tree().paused = false
		get_tree().reload_current_scene()

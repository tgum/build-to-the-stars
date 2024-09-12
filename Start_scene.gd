extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(randf_range(1,10)).timeout
	get_tree().change_scene_to_file("res://main.tscn")

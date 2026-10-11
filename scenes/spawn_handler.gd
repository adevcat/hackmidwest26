extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var type = "thing" #SET ARBITRARILY FOR NOW BUT CAN BE CHANGED LATER
	var main = get_parent()
	print("what is parent of this", main)
	main.spawn_entity.connect(_handle_spawn_entity.bind(type))
	print("spawn signal connected: ", type)
	pass # Replace with function body.

func _handle_spawn_entity(type) -> void:
	print("spawning new thing")
	var obj_scene = preload("res://scenes/test_obj.tscn")
	var child_node = obj_scene.instantiate()
	child_node.obj_type = "THINGJY"
	add_child(child_node)
	print("what is child node: ", child_node)
	return

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

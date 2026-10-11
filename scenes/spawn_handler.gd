extends Node

var coords_array = [Vector2(0,0),Vector2(0,0),Vector2(0,0),Vector2(0,0),Vector2(0,0)]
var type = "thing" #SET ARBITRARILY FOR NOW BUT CAN BE CHANGED LATER

func set_spawn_coords() -> Vector2:
	var pos = randi_range(0, 4)
	# need coords for the 5 spots
	var coords: Vector2 = coords_array[pos]
	return Vector2(250, 250)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var main = get_parent()
	main.spawn_entity.connect(_handle_spawn_entity.bind(type))
	print("spawn signal connected: ", type)
	pass

func _handle_spawn_entity(type) -> void:
	print("spawning new thing")
	var obj_scene = preload("res://scenes/test_obj.tscn")
	var child_node = obj_scene.instantiate()
	child_node.obj_type = "THINGJY"
	child_node.set_global_position(set_spawn_coords())
	add_child(child_node)
	return

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

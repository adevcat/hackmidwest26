extends Node
signal item_hit(sound_type: AudioManager.Sound)
@export var beat_count = 0
var obj_scene = preload("res://scenes/test_obj.tscn")

var coords_array = [Vector2(0,0),Vector2(0,0),Vector2(0,0),Vector2(0,0),Vector2(0,0)]

func set_spawn_coords(col) -> Vector2:
	return get_parent().get_node("Spots/Spot_0_{1}".format({1: col})).get_child(0).global_position

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _on_new_count_beats() -> void:
	beat_count += 1
	if beat_count > 4 and randfn(0, 1.0) >= 0.8:
		_handle_spawn_entity()	

func _handle_spawn_entity() -> void:
	print("spawning new thing")
	var child_node = obj_scene.instantiate()
	var sound: AudioManager.Sound = randi_range(0, AudioManager.Sound.size()-1)
	var col = randi_range(0, 4)
	child_node.col = col
	child_node.row = 0
	child_node.sound_type = sound
	child_node.set_global_position(set_spawn_coords(col))
	child_node.set_icon(sound)
	add_sibling(child_node)
	return

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

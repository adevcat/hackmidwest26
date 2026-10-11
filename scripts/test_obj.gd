class_name TestObj
extends Area2D

var obj_type = ""

func _get_curr_position(node_name) -> Vector2:
	var curr_position = get_parent().get_node(node_name).position
	return curr_position

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("my type is: ", obj_type)
	pass # Replace with function body.

func _on_area_entered(area: Area2D) -> void:
	if area is Player:
		get_parent().get_parent().item_hit.emit(obj_type)
		queue_free()
		# CALL WHATEVER FUNCTION TO APPLY EFFECT
		print("u hitted the freakin player bro")
	return

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

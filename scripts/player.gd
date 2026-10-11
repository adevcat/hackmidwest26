class_name Player
extends Area2D

# tile-by-tile movement
var tile_size = 64
var inputs = {"move_right": Vector2.RIGHT,
			"move_left": Vector2.LEFT}

# Called when the node enters the scene tree for the first time.
@export var speed = 400
var screen_size # Size of the game window.
func _ready() -> void:
	print(get_parent().get_children())
	var node = get_parent().get_node("TestObj")
	node.item_hit.connect(_on_item_hit)
	screen_size = get_viewport_rect().size
	position = position.snapped(Vector2.ZERO * tile_size)
	position += Vector2.ZERO * tile_size/2

func _unhandled_input(event):
	pass

func _on_item_hit(type):
	print("ITGEM HIGT")

func _process(delta:float) -> void:
	for dir in inputs.keys():
		if Input.is_action_pressed(dir):
			var bounds = get_overlapping_areas()
			for index in bounds.size():
				if (bounds[index].name == "left_wall" and dir == "move_left") or (bounds[index].name == "right_wall" and dir == "move_right"):
					return
			move(dir)
	
func move(dir):
	position += inputs[dir] * tile_size

extends Area2D

# tile-by-tile movement
var tile_size = 64
var inputs = {"move_right": Vector2.RIGHT,
			"move_left": Vector2.LEFT,
			"move_up": Vector2.UP,
			"move_down": Vector2.DOWN}

# Called when the node enters the scene tree for the first time.
@export var speed = 400
var screen_size # Size of the game window.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	position = position.snapped(Vector2.ZERO * tile_size)
	position += Vector2.ZERO * tile_size/2

func _unhandled_input(event):
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			move(dir)

func move(dir):
	position += inputs[dir] * tile_size

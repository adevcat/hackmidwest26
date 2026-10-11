class_name Player
extends Area2D

# tile-by-tile movement
var tile_size = 64
var inputs = {"move_right": Vector2.RIGHT,
			"move_left": Vector2.LEFT,
			"move_up": Vector2.ZERO,
			"move_down": Vector2.ZERO
			}
var audiomgr: Node
# Called when the node enters the scene tree for the first time.
@export var speed = 400
var row: int
var col: int
var new_beat: bool = true
var to_move = false
var screen_size # Size of the game window.
func _ready() -> void:
	print(get_parent().get_children())
	get_parent().item_hit.connect(_on_item_hit)
	screen_size = get_viewport_rect().size
	col = 2
	row = 3
	_jump_to_spot(row, col)
	audiomgr = get_node("../AudioManager")

func _unhandled_input(event):
	pass
	
func _jump_to_spot(ro: int, co: int) -> void:
	global_position = get_parent().get_node("Spots/Spot_{0}_{1}".format({0: ro, 1: co})).get_child(0).global_position
	to_move = false
	new_beat = false

func beat_update():
	new_beat = true
	to_move = false

func _on_item_hit(type):
	print("ITGEM HIGT")

func _process(delta:float) -> void:
	if to_move:
		_jump_to_spot(row, col)
	if Input.is_action_just_pressed("clap"):
		audiomgr.add_sound("clap")
	if Input.is_action_just_pressed("snare"):
		audiomgr.add_sound("clap")
	for dir in inputs.keys():
		if Input.is_action_pressed(dir) && new_beat:
			print("move")
			match dir:
				"move_left":
					move_left()
				"move_right":
					move_right()
				"move_up":
					move_up()
				"move_down":
					move_down()

func move_left() -> void:
	if col < 1:
		return
	col -= 1
	to_move = true
	
func move_right() -> void:
	if col > 3:
		return
	col += 1
	to_move = true

func move_up() -> void:
	if row < 1:
		return
	row -= 1
	to_move = true

func move_down() -> void:
	if row >= 3:
		return
	row += 1
	to_move = true

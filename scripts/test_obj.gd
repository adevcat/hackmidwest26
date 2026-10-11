class_name TestObj
extends Area2D

@export var sound_type: AudioManager.Sound
@export var col: int
var ro = 0
var to_move = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var manager = get_parent().get_node("AudioManager")
	manager.new_beat.connect(_need_move)
	pass # Replace with function body.

func _move_down_spot(ro: int, co: int) -> void:
	global_position = get_parent().get_node("Spots/Spot_{0}_{1}".format({0: ro, 1: co})).get_child(0).global_position
	to_move = false
	
func set_icon(sound: AudioManager.Sound) -> void:
	match sound:
		AudioManager.Sound.PERC:
			#set sprite to wahtev
			pass
	pass

func _need_move():
	to_move = true

func _on_area_entered(area: Area2D) -> void:
	if area is Player:
		var manager = get_parent().get_node("SpawnManager")
		manager.item_hit.emit(sound_type)
		queue_free()
		# CALL WHATEVER FUNCTION TO APPLY EFFECT
		print("u hitted the freakin player bro")
	return

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if to_move:
		if ro > 3:
			queue_free()
			return
		ro += 1
		_move_down_spot(ro, col)
	pass

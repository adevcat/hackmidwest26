class_name TestObj
extends Area2D

@export var sound_type: AudioManager.Sound
@export var col: int
@export var row: int
var can_move = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var manager = get_parent().get_node("AudioManager")
	manager.new_beat.connect(_need_move)
	pass # Replace with function body.

func _move_down_spot(ro: int, co: int) -> void:
	if row > 3:
		queue_free()
		return
	global_position = get_parent().get_node("Spots/Spot_{0}_{1}".format({0: ro, 1: col})).get_child(0).global_position
	can_move = false
	
# PERC, VOX, INST, SFX, SPECIAL
func set_icon(sound: AudioManager.Sound) -> void:
	var item_sprite = null
	match sound:
		AudioManager.Sound.PERC:
			item_sprite = preload("res://sprites/drum.tres")
			$Sprite2D.sprite_frames = item_sprite
			pass
		AudioManager.Sound.VOX:
			item_sprite = preload("res://sprites/vox.tres")
			$Sprite2D.sprite_frames = item_sprite
			pass
		AudioManager.Sound.INST:
			item_sprite = preload("res://sprites/inst.tres")
			$Sprite2D.sprite_frames = item_sprite
			pass	
		AudioManager.Sound.SFX:
			item_sprite = preload("res://sprites/sfx.tres")
			$Sprite2D.sprite_frames = item_sprite
			pass	
		AudioManager.Sound.SPECIAL:
			item_sprite = preload("res://sprites/cube.tres")
			$Sprite2D.sprite_frames = item_sprite
			$Sprite2D.play()
			pass
	pass

func _need_move():
	can_move = true

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
	if can_move:
		row += 1
		_move_down_spot(row, col)
	pass

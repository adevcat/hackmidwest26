extends Node

var audiomgr: Node
var screen_size
var sound_dict = {
	AudioManager.Sound.PERC : "res://art/SeqStatic/drum.png",
	AudioManager.Sound.VOX : "res://art/SeqStatic/vox.png",
	AudioManager.Sound.INST : "res://art/SeqStatic/inst.png",
	AudioManager.Sound.SFX : "res://art/SeqStatic/sfx.png",
	AudioManager.Sound.SPECIAL : "res://art/SeqStatic/special.png",
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	audiomgr = get_node("../AudioManager") # Replace with function body.
	#with current implementation nodes wont become unactivated

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#check for update from audio manager
	#audiomgr. whatever update function
	# each beat, check array at index 0 through 4 to check for corresponding sound
	# if there is, update data structure
	#add_child(block)
	#block.set_global_position(Vector2(50.0,50.0))
	pass
	
func create_icon(sound: AudioManager.Sound, beat: int, j: int) -> void:
	if get_node("{0}_{1}".format({0: sound, 1: beat})) != null:
		return
	var block = get_node("seq_block").duplicate()
	block.name = "{0}_{1}".format({0: sound, 1: beat})
	add_child(block)
	var x = beat * 20
	var y = 80 + j *20
	block.set_global_position(Vector2(x,y))
	block.sprite = sound_dict[sound]
	block.visible = true

func draw_blocks():
	var max_index = audiomgr.MEASURES * audiomgr.BEATS_PER_MEASURE
	for i in range(0,max_index):
		var sounds = audiomgr.get_current_sounds(i)
		if sounds.size() >= 1:
			for j in range(0,len(sounds)):
				create_icon(sounds[j], i, j)
	
	

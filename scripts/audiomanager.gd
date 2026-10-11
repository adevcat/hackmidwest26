class_name AudioManager
extends Node
@export var BPM: float = 135
@export var BEATS_PER_MEASURE: int = 4
@export var BEAT_VALUE = 1
@export var MEASURES: int = 2
@export var TOTAL_BEATS: int = int(MEASURES * BEATS_PER_MEASURE)
@export var CURRENT_BEAT = -1
@export var old_bpm: int
var MAX_SOUNDS_PER_STREAM: int = 5
# enum-like structure to store audio types

enum Sound { PERC, VOX, INST, SFX, SPECIAL }
signal new_beat
signal new_sound
# -------------------
var DEBUG: bool = true
var audiostreams: Array[AudioStreamPlayer] = []
var sound_bank = { 
	AudioManager.Sound.PERC: [],
	AudioManager.Sound.VOX: [],
	AudioManager.Sound.INST: [],
	AudioManager.Sound.SFX: [],
	AudioManager.Sound.SPECIAL: []
}
func _ready():
	print(get_parent().get_parent().get_parent())
	audiostreams.resize(TOTAL_BEATS)
	for i in range(TOTAL_BEATS):
		var new = AudioStreamPlayer.new() #$SyncAudio.duplicate()
		new.name = "BEAT_{0}".format({"0": i})
		new.stream = AudioStreamSynchronized.new()
		new.stream.stream_count = MAX_SOUNDS_PER_STREAM
		audiostreams[i] = new
		add_child(new)
	print("AudioManager initialized")
	var manager = get_node("../SpawnManager")
	manager.item_hit.connect(add_sound)
	_populate_sounds()
	begin()

func _populate_sounds():
	var folders = {"perc": AudioManager.Sound.PERC, "vox": AudioManager.Sound.VOX, "inst": AudioManager.Sound.INST, "sfx": AudioManager.Sound.SFX, "special": AudioManager.Sound.SPECIAL}
	var dirac = DirAccess.open("res://audio")
	for key in folders:
		for file in dirac.get_files_at("res://audio/"+key):
			if file.ends_with(".wav"):
				var path = "res://audio/" + key + "/" + file
				sound_bank[folders[key]].append(path)
		

func begin() -> void:
	#_add_test_patterns()
	$BG.play()

func _process(delta: float) -> void:
	#var time = self.get_playback_position() + AudioServer.get_time_since_last_mix()
	var time = $BG.get_playback_position() + AudioServer.get_time_since_last_mix()
	# Compensate for output latency.
	time -= 0.25* AudioServer.get_output_latency()
	var beat = int(time * (BPM / 60.0)/BEAT_VALUE)
	if beat != CURRENT_BEAT:
		update(beat)
	CURRENT_BEAT = beat
	
func _run_audiostream(index: int) -> void:
	audiostreams[index].play(0.0)


func update(beat) -> void:
	CURRENT_BEAT = beat % TOTAL_BEATS
	if DEBUG:
		print("measure: {1} beat {0}".format({0: CURRENT_BEAT, 1: int(floor(CURRENT_BEAT / BEATS_PER_MEASURE))}))
	_run_audiostream(CURRENT_BEAT)
	if CURRENT_BEAT % 4 == 3:
		get_node("../player").get_child(1).animation = &"default"
	if CURRENT_BEAT % 4 == 1:
		get_node("../player").get_child(1).animation = &"default"
	if CURRENT_BEAT % 4 == 2:
		get_node("../player").get_child(1).animation = &"right"		
	if CURRENT_BEAT % 4 == 0:
		get_node("../Background").play(&"moving_sky")
		get_node("../player").get_child(1).animation = &"left"
	new_beat.emit()

func add_sound(type: AudioManager.Sound) -> void:
	var soundfile = _get_rand_sound(type)
	if soundfile == "":
		return
	audiostreams[CURRENT_BEAT%TOTAL_BEATS].stream.set_sync_stream(type, AudioStreamWAV.load_from_file(soundfile))
	emit_signal("new_sound")
	#_run_audiostream(CURRENT_BEAT%TOTAL_BEATS)

func _get_rand_sound(type: AudioManager.Sound) -> String:
	if sound_bank[type].size() != 0:
		return sound_bank[type][randi_range(0, sound_bank[type].size()-1)]
	return ""

func _add_test_patterns() -> void:
	for x in range(TOTAL_BEATS):
		if x % 8 == 0:
			audiostreams[x].stream.set_sync_stream(AudioManager.Sound.PERC, AudioStreamWAV.load_from_file("res://audio/DDR Snare.wav"))
		if x % 16 == 0:
			audiostreams[x].stream.set_sync_stream(AudioManager.Sound.PERC, AudioStreamWAV.load_from_file("res://audio/Sadkey Clap.wav"))

func get_current_sounds(beat: int) -> Array[AudioManager.Sound]:
	var end: Array[AudioManager.Sound] = []
	for sound in range(AudioManager.Sound.size()):
		if audiostreams[beat].stream.get_sync_stream(sound) != null:
			end.append(sound)
	return end

func bg_loud(loud: float) -> void:
	$BG.volume_db = loud

func bg_nc(loudness: float) -> void:
	if loudness == 24.0:
		old_bpm = BPM
		BPM = BPM * 0.5
		$BG.pitch_scale = 0.5
	else:
		BPM = old_bpm
		$BG.pitch_scale = 1

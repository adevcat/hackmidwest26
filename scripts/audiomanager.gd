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
# -------------------
var DEBUG: bool = true
var audiostreams: Array[AudioStreamPlayer] = []
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
	audiostreams[0].stream.set_sync_stream(AudioManager.Sound.PERC, AudioStreamWAV.load_from_file("res://audio/DDR Snare.wav"))
	begin()

func begin() -> void:
	_add_test_patterns()
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
	if CURRENT_BEAT % 4 == 0:
		get_node("../Background").play(&"moving_sky")
	new_beat.emit()

func add_sound(type: String) -> void:
	if type == "snare":
		audiostreams[CURRENT_BEAT].stream.set_sync_stream(AudioManager.Sound.PERC, AudioStreamWAV.load_from_file("res://audio/DDR Snare.wav"))
	elif type == "clap":
		audiostreams[CURRENT_BEAT].stream.set_sync_stream(AudioManager.Sound.SFX, AudioStreamWAV.load_from_file("res://audio/Sadkey Clap.wav"))
	_run_audiostream(CURRENT_BEAT)

func _add_test_patterns() -> void:
	for x in range(TOTAL_BEATS):
		if x % 8 == 0:
			audiostreams[x].stream.set_sync_stream(AudioManager.Sound.PERC, AudioStreamWAV.load_from_file("res://audio/DDR Snare.wav"))
		if x % 16 == 0:
			audiostreams[x].stream.set_sync_stream(AudioManager.Sound.PERC, AudioStreamWAV.load_from_file("res://audio/Sadkey Clap.wav"))


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

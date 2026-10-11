extends Node
@export var BPM: float = 135.0
@export var BEATS_PER_MEASURE: int = 4
@export var MEASURES: int = 1
@export var TOTAL_BEATS: int = int(MEASURES * BEATS_PER_MEASURE)
@export var CURRENT_BEAT = 0
var MAX_SOUNDS_PER_STREAM: int = 5
# enum-like structure to store audio types
class AudioManager:
	enum Sound { PERC, VOX, INST, SFX, SPECIAL }
var xas
# -------------------
var last = -1
var audiostreams: Array[AudioStreamPlayer] = []
func _ready():
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
	time -= 0.1 * AudioServer.get_output_latency()
	var beat = int(time * BPM / 60.0)
	if beat != last:
		update(beat)
	last = beat
	
func _run_audiostream(index: int) -> void:
	print(index)
	audiostreams[index].play(0.0)


func update(beat) -> void:
	CURRENT_BEAT = beat % TOTAL_BEATS
	_run_audiostream(CURRENT_BEAT)

func add_sound(type: String) -> void:
	if type == "snare":
		audiostreams[CURRENT_BEAT].stream.set_sync_stream(AudioManager.Sound.PERC, AudioStreamWAV.load_from_file("res://audio/DDR Snare.wav"))
	elif type == "clap":
		audiostreams[CURRENT_BEAT].stream.set_sync_stream(AudioManager.Sound.SFX, AudioStreamWAV.load_from_file("res://audio/Sadkey Clap.wav"))

func _add_test_patterns() -> void:
	for x in range(TOTAL_BEATS):
		if x % 2 == 0:
			audiostreams[x].stream.set_sync_stream(AudioManager.Sound.PERC, AudioStreamWAV.load_from_file("res://audio/DDR Snare.wav"))
		if x % 4 == 0:
			audiostreams[x].stream.set_sync_stream(AudioManager.Sound.PERC, AudioStreamWAV.load_from_file("res://audio/Sadkey Clap.wav"))

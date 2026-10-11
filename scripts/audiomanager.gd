extends Node
@export var BPM = 135.0
var go: bool = false
var curr_beat = 0
var last_played = 0
var last = 0
var player
func _ready():
	print(AudioServer.get_time_since_last_mix())
	#self.play()
	$BG.play()
	player = get_node("../player")
	#$AudioStreamPlayer.play()


func _process(delta: float):
	#var time = self.get_playback_position() + AudioServer.get_time_since_last_mix()
	var time = $BG.get_playback_position() + AudioServer.get_time_since_last_mix()
	# Compensate for output latency.
	time -= 0.1 * AudioServer.get_output_latency()
	var beat = int(time * BPM / 60.0)
	if beat != last:
		update(beat)
	last = beat

func update(beat):
	match beat % 4 + 1:
		1:
			if last_played != 1:
				last_played = 1
				print("ahh")
				$Snare.play(0)
				player.move("move_left")
				player.move("move_left")
				player.move("move_left")
		3: 
			if last_played != 3:
				last_played = 3
				$Clap.play(0)
				player.move("move_right")
				player.move("move_right")
				player.move("move_right")

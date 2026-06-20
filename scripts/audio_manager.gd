extends Node


## 主音量
var _master_volume: float = 1.0
## 音效音量
var _sfx_volume: float = 1.0


func _ready() -> void:
	_setup_audio_buses()


## 设置音频总线
func _setup_audio_buses() -> void:
	# 检查 SFX 总线是否存在，不存在则创建
	var sfx_bus = AudioServer.get_bus_index("SFX")
	if sfx_bus == -1:
		AudioServer.add_bus()
		sfx_bus = AudioServer.get_bus_count() - 1
		AudioServer.set_bus_name(sfx_bus, "SFX")


## 播放合成音效
func _play_beep(frequency: float, duration: float, amplitude: float = 0.3) -> void:
	var generator = AudioStreamGenerator.new()
	generator.mix_rate = 44100
	generator.buffer_length = duration

	var player = AudioStreamPlayer.new()
	player.stream = generator
	player.bus = "SFX"
	add_child(player)
	player.play()

	var playback = player.get_stream_playback()
	if playback == null:
		player.queue_free()
		return

	var sample_count: int = int(44100 * duration)
	for i in range(sample_count):
		var sample: float = sin(2.0 * PI * frequency * float(i) / 44100.0) * amplitude * _sfx_volume
		playback.push_frame(Vector2(sample, sample))

	player.finished.connect(player.queue_free)


## 播放跳跃音效
func play_jump() -> void:
	_play_beep(600.0, 0.1, 0.3)


## 播放得分音效
func play_score() -> void:
	_play_beep(880.0, 0.12, 0.4)


## 播放死亡音效
func play_death() -> void:
	_play_beep(200.0, 0.35, 0.5)


## 设置主音量 (0.0 - 1.0)
func set_master_volume(volume: float) -> void:
	_master_volume = clamp(volume, 0.0, 1.0)
	var master_bus := AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(master_bus, linear_to_db(_master_volume))


## 设置音效音量 (0.0 - 1.0)
func set_sfx_volume(volume: float) -> void:
	_sfx_volume = clamp(volume, 0.0, 1.0)
	var sfx_bus := AudioServer.get_bus_index("SFX")
	if sfx_bus >= 0:
		AudioServer.set_bus_volume_db(sfx_bus, linear_to_db(_sfx_volume))
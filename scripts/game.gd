extends Node2D


@onready var bird: CharacterBody2D = $Bird
@onready var pipe_spawner: Node2D = $PipeSpawner
@onready var ground: Node2D = $Ground
@onready var score_label: Label = $CanvasLayer/ScoreLabel
@onready var game_over_panel: Control = $CanvasLayer/GameOverPanel


func _ready() -> void:
	# 初始状态：隐藏游戏结束面板
	game_over_panel.hide()

	# 连接 GameManager 信号
	GameManager.game_started.connect(_on_game_started)
	GameManager.game_over.connect(_on_game_over)
	GameManager.score_changed.connect(_on_score_changed)

	# 连接小鸟死亡信号
	bird.bird_died.connect(_on_bird_died)

	# 连接小鸟得分信号
	bird.score_passed.connect(_on_bird_score_passed)

	# 连接 ScoreManager 信号
	ScoreManager.score_updated.connect(_on_score_updated)

	# 启动游戏
	GameManager.start_game()


func _on_game_started() -> void:
	pipe_spawner.start_spawning()
	update_score_display()


func _on_game_over() -> void:
	pipe_spawner.stop_spawning()
	ground.set_process(false)
	game_over_panel.show()


func _on_bird_died() -> void:
	ScoreManager.save_high_score()
	GameManager.end_game()


func _on_bird_score_passed() -> void:
	ScoreManager.add_score()


func _on_score_changed(_new_score: int) -> void:
	update_score_display()


func _on_score_updated(_current: int, _best: int) -> void:
	update_score_display()


func update_score_display() -> void:
	score_label.text = str(ScoreManager.current_score)


func _on_start_button_pressed() -> void:
	# 重新开始游戏
	get_tree().reload_current_scene()

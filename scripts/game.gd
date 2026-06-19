extends Node2D


## 返回菜单信号
signal back_to_menu

@onready var bird: CharacterBody2D = $Bird
@onready var pipe_spawner: Node2D = $PipeSpawner
@onready var ground: Node2D = $Ground
@onready var score_label: Label = $CanvasLayer/ScoreLabel
@onready var game_over_panel: Control = $CanvasLayer/GameOverPanel

var _is_new_best: bool = false


func _ready() -> void:
	# 初始状态：隐藏游戏结束面板
	game_over_panel.hide()

	# 连接 GameManager 信号
	GameManager.game_started.connect(_on_game_started)
	GameManager.game_over.connect(_on_game_over)

	# 连接小鸟死亡信号
	bird.bird_died.connect(_on_bird_died)

	# 连接小鸟得分信号
	bird.score_passed.connect(_on_bird_score_passed)

	# 连接 ScoreManager 信号
	ScoreManager.score_updated.connect(_on_score_updated)
	ScoreManager.new_best.connect(_on_new_best)

	# 连接游戏结束面板重新开始信号
	game_over_panel.restart_requested.connect(_on_restart_requested)

	# 启动游戏
	GameManager.start_game()


func _on_game_started() -> void:
	# 重置分数
	ScoreManager.reset_score()
	_is_new_best = false
	pipe_spawner.start_spawning()
	update_score_display()


func _on_game_over() -> void:
	pipe_spawner.stop_spawning()
	ground.set_process(false)
	# 更新游戏结束面板显示
	game_over_panel.setup(ScoreManager.current_score, ScoreManager.best_score, _is_new_best)
	game_over_panel.show()


func _on_bird_died() -> void:
	ScoreManager.save_high_score()
	GameManager.end_game()


func _on_bird_score_passed() -> void:
	ScoreManager.add_score()


func _on_score_updated(_current: int, _best: int) -> void:
	update_score_display()


func _on_new_best(_score: int) -> void:
	_is_new_best = true


func update_score_display() -> void:
	score_label.text = str(ScoreManager.current_score)


func _on_restart_requested() -> void:
	# 返回主菜单
	back_to_menu.emit()
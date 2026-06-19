extends Control


## 游戏场景路径
const GAME_SCENE: String = "res://scenes/game.tscn"

## 最高分标签
@onready var best_score_label: Label = $BestScoreLabel
## 开始按钮
@onready var start_button: Button = $StartButton


func _ready() -> void:
	# 设置游戏状态为菜单
	GameManager.go_to_menu()
	# 显示最高分
	update_best_score_display()
	# 连接开始按钮信号
	start_button.pressed.connect(_on_start_button_pressed)


## 更新最高分显示
func update_best_score_display() -> void:
	best_score_label.text = "Best: " + str(ScoreManager.best_score)


## 开始按钮回调：切换到游戏场景
func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file(GAME_SCENE)

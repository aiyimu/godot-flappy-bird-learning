extends Control


## 重新开始信号
signal restart_requested

@onready var final_score_label: Label = $FinalScoreLabel
@onready var best_score_label: Label = $BestScoreLabel
@onready var new_best_label: Label = $NewBestLabel
@onready var restart_button: Button = $RestartButton


func _ready() -> void:
	restart_button.pressed.connect(_on_restart_button_pressed)


## 设置游戏结束面板显示内容
func setup(final_score: int, best_score: int, is_new_best: bool) -> void:
	final_score_label.text = "Score: " + str(final_score)
	best_score_label.text = "Best: " + str(best_score)
	if is_new_best:
		new_best_label.show()
	else:
		new_best_label.hide()


## 重新开始按钮回调
func _on_restart_button_pressed() -> void:
	restart_requested.emit()
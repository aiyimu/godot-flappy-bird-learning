extends Node

## 当前分数
var current_score: int = 0

## 历史最高分
var best_score: int = 0

const SAVE_PATH: String = "user://highscore.save"

## 信号定义
signal score_updated(current: int, best: int)
signal new_best(score: int)


func _ready() -> void:
	load_high_score()


## 增加分数
func add_score(amount: int = 1) -> void:
	current_score += amount
	if current_score > best_score:
		best_score = current_score
		new_best.emit(best_score)
	score_updated.emit(current_score, best_score)


## 重置当前分数
func reset_score() -> void:
	current_score = 0
	score_updated.emit(current_score, best_score)


## 保存最高分到文件
func save_high_score() -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_32(best_score)
		file.close()


## 从文件加载最高分
func load_high_score() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		if file:
			best_score = file.get_32()
			file.close()
	else:
		best_score = 0
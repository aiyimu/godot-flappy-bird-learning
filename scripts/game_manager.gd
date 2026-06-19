extends Node

## 游戏状态枚举
enum GameState { MENU, PLAYING, GAME_OVER }

## 当前游戏状态
var current_state: GameState = GameState.MENU

## 信号定义
signal game_started()
signal game_over()
signal score_changed(new_score: int)


func _ready() -> void:
	pass


## 切换游戏状态
func set_state(new_state: GameState) -> void:
	current_state = new_state


## 开始游戏
func start_game() -> void:
	set_state(GameState.PLAYING)
	game_started.emit()


## 结束游戏
func end_game() -> void:
	set_state(GameState.GAME_OVER)
	game_over.emit()


## 返回菜单
func go_to_menu() -> void:
	set_state(GameState.MENU)


## 通知分数变化
func notify_score_changed(new_score: int) -> void:
	score_changed.emit(new_score)
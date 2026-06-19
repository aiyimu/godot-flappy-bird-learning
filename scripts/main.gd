extends Node


const START_MENU_SCENE: String = "res://scenes/ui/start_menu.tscn"
const GAME_SCENE: String = "res://scenes/game.tscn"

var _current_scene: Node = null


func _ready() -> void:
	_load_start_menu()


## 加载开始菜单场景
func _load_start_menu() -> void:
	_clear_current_scene()
	var start_menu = load(START_MENU_SCENE).instantiate()
	add_child(start_menu)
	_current_scene = start_menu
	start_menu.start_game.connect(_on_start_game)


## 加载游戏场景
func _load_game() -> void:
	_clear_current_scene()
	var game = load(GAME_SCENE).instantiate()
	add_child(game)
	_current_scene = game
	game.back_to_menu.connect(_on_back_to_menu)


## 清除当前场景
func _clear_current_scene() -> void:
	if _current_scene:
		_current_scene.queue_free()
		_current_scene = null


## 开始游戏回调
func _on_start_game() -> void:
	_load_game()


## 返回菜单回调
func _on_back_to_menu() -> void:
	_load_start_menu()
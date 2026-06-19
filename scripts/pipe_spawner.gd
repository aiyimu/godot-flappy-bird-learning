extends Node2D


## 生成间隔最小值（秒）
@export var spawn_interval_min: float = 1.5

## 生成间隔最大值（秒）
@export var spawn_interval_max: float = 2.5

## 管道间隙最小值
@export var gap_min: float = 180.0

## 管道间隙最大值
@export var gap_max: float = 260.0

## 管道移动速度
@export var pipe_speed: float = 150.0

## 管道对场景
const PIPE_PAIR_SCENE: PackedScene = preload("res://scenes/pipe_pair.tscn")

## 屏幕宽度
const SCREEN_WIDTH: float = 576.0

## 生成 X 坐标（屏幕右侧外，管道宽度约52，留出余量）
const SPAWN_X: float = SCREEN_WIDTH + 60.0

## Y 坐标范围
const Y_MIN: float = 250.0
const Y_MAX: float = 750.0

var _timer: Timer


func _ready() -> void:
	_timer = Timer.new()
	add_child(_timer)
	_timer.timeout.connect(_on_spawn)
	_start_next_timer()


## 开始下一次计时器
func _start_next_timer() -> void:
	_timer.wait_time = randf_range(spawn_interval_min, spawn_interval_max)
	_timer.start()


## 生成管道对
func _on_spawn() -> void:
	var pipe_pair = PIPE_PAIR_SCENE.instantiate()
	add_child(pipe_pair)

	# 随机 Y 位置
	pipe_pair.position.y = randf_range(Y_MIN, Y_MAX)
	pipe_pair.position.x = SPAWN_X

	# 随机间隙
	pipe_pair.gap_size = randf_range(gap_min, gap_max)

	# 设置管道速度
	_set_pipe_speed(pipe_pair, pipe_speed)

	_start_next_timer()


## 递归设置管道对中所有节点的速度
func _set_pipe_speed(node: Node, speed: float) -> void:
	if "speed" in node:
		node.set("speed", speed)
	for child in node.get_children():
		_set_pipe_speed(child, speed)


## 停止生成
func stop_spawning() -> void:
	_timer.stop()


## 开始生成
func start_spawning() -> void:
	_start_next_timer()

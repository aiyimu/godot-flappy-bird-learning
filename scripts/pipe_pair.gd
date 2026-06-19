extends Node2D


## 管道间隙大小
@export var gap_size: float = 200.0


func _ready() -> void:
	setup_pipes()


## 根据 gap_size 设置上下管道位置和得分区域
func setup_pipes() -> void:
	var top_pipe = $TopPipe
	var bottom_pipe = $BottomPipe
	var score_zone = $ScoreZone

	if top_pipe:
		top_pipe.position.y = -gap_size / 2.0
	if bottom_pipe:
		bottom_pipe.position.y = gap_size / 2.0
	if score_zone:
		score_zone.position.y = 0

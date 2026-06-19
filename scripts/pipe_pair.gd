extends Node2D


## 管道间隙大小
@export var gap_size: float = 200.0


func _ready() -> void:
	setup_pipes()


## 管道精灵高度（与屏幕等高，确保始终覆盖到屏幕边缘）
const PIPE_HEIGHT: float = 1024.0


## 根据 gap_size 设置上下管道位置和得分区域
## 管道精灵原点在中心，通过偏移使管口精确对齐间隙边缘
func setup_pipes() -> void:
	var top_pipe = $TopPipe
	var bottom_pipe = $BottomPipe
	var score_zone = $ScoreZone

	if top_pipe:
		# 上管道：管口（精灵底边）对齐间隙上边缘，身体向上延伸到屏幕外
		# 精灵底边在本地坐标 y = +PIPE_HEIGHT/2，因此:
		#   position.y + PIPE_HEIGHT/2 = -gap_size/2
		#   position.y = -gap_size/2 - PIPE_HEIGHT/2
		top_pipe.position.y = -gap_size / 2.0 - PIPE_HEIGHT / 2.0
		top_pipe.rotation = 0.0
	if bottom_pipe:
		# 下管道：管口（精灵顶边）对齐间隙下边缘，身体向下延伸到屏幕外
		# 精灵顶边在本地坐标 y = -PIPE_HEIGHT/2，因此:
		#   position.y - PIPE_HEIGHT/2 = gap_size/2
		#   position.y = gap_size/2 + PIPE_HEIGHT/2
		bottom_pipe.position.y = gap_size / 2.0 + PIPE_HEIGHT / 2.0
		bottom_pipe.rotation = 0.0
	if score_zone:
		score_zone.position.y = 0

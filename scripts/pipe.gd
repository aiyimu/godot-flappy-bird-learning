extends StaticBody2D


## 管道移动速度（像素/秒）
@export var speed: float = 150.0


func _process(delta: float) -> void:
	position.x -= speed * delta

	# 超出屏幕左侧后销毁（使用世界坐标判断）
	if global_position.x < -100:
		queue_free()

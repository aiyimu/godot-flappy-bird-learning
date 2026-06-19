extends StaticBody2D


## 管道移动速度（像素/秒）
@export var speed: float = 150.0


func _process(delta: float) -> void:
	position.x -= speed * delta

	# 超出屏幕左侧后销毁（屏幕宽度576，管道宽度约52）
	if position.x < -100:
		queue_free()

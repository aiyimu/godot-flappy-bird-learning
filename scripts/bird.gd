extends CharacterBody2D


## 跳跃速度（负值表示向上）
@export var jump_velocity: float = -400.0

## 重力加速度
@export var gravity: float = 980.0

## 最大下落速度
@export var max_fall_speed: float = 600.0

## 旋转速度
@export var rotation_speed: float = 3.0

## 小鸟死亡信号
signal bird_died


func _physics_process(delta: float) -> void:
	# 重力模拟
	velocity.y += gravity * delta
	# 限制最大下落速度
	velocity.y = min(velocity.y, max_fall_speed)

	# 跳跃输入检测
	if Input.is_action_just_pressed("jump"):
		velocity.y = jump_velocity

	# 移动角色
	move_and_slide()

	# 旋转动画：根据垂直速度调整旋转角度
	var target_rotation: float = clamp(velocity.y / max_fall_speed, -0.5, 0.5) * 1.5
	rotation = lerp(rotation, target_rotation, rotation_speed * delta)


## 触发死亡
func die() -> void:
	bird_died.emit()
	set_physics_process(false)

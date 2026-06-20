extends CharacterBody2D


## 跳跃速度（负值表示向上）
@export var jump_velocity: float = -400.0

## 重力加速度
@export var gravity: float = 980.0

## 最大下落速度
@export var max_fall_speed: float = 600.0

## 旋转速度
@export var rotation_speed: float = 3.0

## 屏幕上边界（小鸟飞到此 Y 坐标时死亡）
@export var top_boundary: float = 0.0

## 小鸟死亡信号
signal bird_died

## 小鸟通过管道得分信号
signal score_passed

var _is_dead: bool = false


func _ready() -> void:
	# 连接 Area2D 碰撞检测信号
	var area = $Area2D
	area.body_entered.connect(_on_body_entered)
	area.area_entered.connect(_on_area_entered)


func _physics_process(delta: float) -> void:
	if _is_dead:
		return

	# 重力模拟
	velocity.y += gravity * delta
	# 限制最大下落速度
	velocity.y = min(velocity.y, max_fall_speed)

	# 跳跃输入检测
	if Input.is_action_just_pressed("jump"):
		velocity.y = jump_velocity
		AudioManager.play_jump()

	# 移动角色
	move_and_slide()

	# 物理碰撞检测：检查是否撞到管道或地面
	# move_and_slide() 会阻止 CharacterBody2D 穿过碰撞体，
	# 但 Area2D 的 body_entered 信号需要重叠才会触发，
	# 因此使用 get_slide_collision_count() 检测物理碰撞
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider and (collider.is_in_group("obstacle") or collider.is_in_group("ground")):
			die()
			return

	# 旋转动画：根据垂直速度调整旋转角度
	var target_rotation: float = clamp(velocity.y / max_fall_speed, -0.5, 0.5) * 1.5
	rotation = lerp(rotation, target_rotation, rotation_speed * delta)

	# 屏幕边界检测：飞出屏幕上方
	if global_position.y < top_boundary:
		die()


## 碰撞体检测：管道、地面
func _on_body_entered(body: Node) -> void:
	if _is_dead:
		return
	if body.is_in_group("obstacle") or body.is_in_group("ground"):
		die()


## 区域检测：得分触发器
func _on_area_entered(area: Area2D) -> void:
	if _is_dead:
		return
	if area.is_in_group("score"):
		score_passed.emit()


## 触发死亡
func die() -> void:
	if _is_dead:
		return
	_is_dead = true
	bird_died.emit()
	set_physics_process(false)
